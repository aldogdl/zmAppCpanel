import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zmcpanel/data_shared.dart';
import 'package:zmcpanel/repository/app_varios_repository.dart';
import 'package:zmcpanel/repository/autos_repository.dart';
import 'package:zmcpanel/repository/notifics_repository.dart';
import 'package:zmcpanel/repository/procc_roto_repository.dart';
import 'package:zmcpanel/repository/user_repository.dart';
import 'package:zmcpanel/singletons/config_gms_sngt.dart';
import 'package:zmcpanel/globals.dart' as globals;
import 'package:zmcpanel/shared_preference_const.dart' as spConst;


class InitConfigPage extends StatefulWidget {
  @override
  _InitConfigPageState createState() => _InitConfigPageState();
}

class _InitConfigPageState extends State<InitConfigPage> {

  ConfigGMSSngt configGMSSngt = ConfigGMSSngt();
  UserRepository emUser = UserRepository();
  DataShared dataShared = DataShared();
  AutosRepository emAutos = AutosRepository();
  ProccRotoRepository emProccsRotos = ProccRotoRepository();
  NotificsRepository emNotific = NotificsRepository();
  AppVariosRepository emVarios = AppVariosRepository();

  String _haciendo = 'Iniciando Configuración';
  bool _recibirNotif;
  SharedPreferences _sess;
  BuildContext _context;
  bool _iniConfig = false;
  String _tokenDB;
  DataShared _dataShared;
  bool _isNewInstalationApp = true;

  @override
  Widget build(BuildContext context) {

    this._context = context;
    context = null;

    if(!this._iniConfig) {
      this._iniConfig = true;
      configGMSSngt.setContext(this._context);
      emNotific.setContext(this._context);
      _initConfig();
    }

    return Scaffold(
      backgroundColor: Color(0xff002F51),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(this._context).size.width,
              height: MediaQuery.of(this._context).size.height,
                child: FadeInImage(
                placeholder: AssetImage('assets/images/no_pixel.png'),
                image: AssetImage('assets/images/zona_motora.png'),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 40,
              child: Container(
                width: MediaQuery.of(this._context).size.width,
                height: 30,
                child: Center(
                  child: Text(
                    '${this._haciendo}',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  /* */
  Future<void> _initConfig() async {

    this._sess = await SharedPreferences.getInstance();
    if(globals.env == 'dev'){
      this._sess.setString('ipDev', globals.ip);
    }

    this._dataShared = Provider.of<DataShared>(this._context, listen: false);
    this._recibirNotif = this._sess.getBool(spConst.sp_notif);
    this._haciendo = 'Checando Procesos Rotos';
    setState(() {});

    Map<String, dynamic> procesoRoto = await emProccsRotos.checkProcesosRotos();
    
    this._haciendo = 'Configurando zmcpanel App.';
    setState(() {});

    await _checkMarcasAndModelos();
    await _checkConfigPush();
    await _checkCategos();
    
    this._haciendo = 'Bienvenid@';
    setState(() {});

    PaintingBinding.instance.imageCache.clear();

    if(procesoRoto.isNotEmpty) {
      // si existe el campo ftosCot es que es llamado el proceso roto desde
      // la seleccion de imagenes para una respuesta a alguna solicitud.
      if(procesoRoto.containsKey('altaLogoSocio')){
        this._dataShared.setTokenAsesor({'token':procesoRoto['tokenAsesor']});
      }
      if(procesoRoto.containsKey('altSoc')){
        this._dataShared.setTokenAsesor({'token':procesoRoto['tokenAsesor']});
      }

      Navigator.of(this._context).pushNamedAndRemoveUntil(procesoRoto['path'], (Route rutas) => false,
        arguments: (procesoRoto.containsKey('indexAuto')) ? {'indexAuto':procesoRoto['indexAuto']} : null
      );

    }
  }

  ///
  Future<void> _checkConfigPush() async {

    this._haciendo = 'Configurando Notificaciones';
    setState(() {});
    
    // Para no duplicar el hilo actual ya configurado - solo en DEV
    if(globals.env == 'dev') {
      int devClv = this._sess.getInt(spConst.sp_devClv);
      devClv = (devClv == null) ? 1 : devClv;
      if(devClv != globals.devClvTmp){
        return;
      }
    }

    if(this._dataShared.segReg == 0) {

      if(this._recibirNotif == null) {
        await this._sess.setBool(spConst.sp_notif, true);
      }else{

        if(this._recibirNotif) {
          //Grabamos la clave permanente para utilizarla de señal y no duplicar el hilo actual ya configurado - solo en DEV
          this._sess.setInt(spConst.sp_devClv, 1);
          if(!dataShared.isConfigPush){
            await configGMSSngt.initConfigGMS();
          }
          String token = await configGMSSngt.getTokenDevice();
          if(token != this._tokenDB) {
            // Actualizar el token nuevo en la BD y servidor.
            await emUser.updateTokenDevice(token);
          }
        }
      }
    }

    // Vemos si hay notificaciones almacenadas en la BD, para mostrar el Icon.
    int notif = await _checkHasNotific();
    if(notif > 0){
      configGMSSngt.showNotificacionesIcon(notif);
    }
  }

  ///
  Future<int> _checkHasNotific() async {

    if(!this._isNewInstalationApp){
      final hasBackup = await emNotific.descargarNotificacionesBackUp();
      if(hasBackup){
        List<Map<String, dynamic>> notis = await emNotific.createObjectsFromSave(emNotific.result['body']);
        if(notis.isNotEmpty){
          Provider.of<DataShared>(this._context, listen: false).setAllNotifics(notis);
        }
      }
      List<Map<String, dynamic>> res = await emNotific.makeBackupNotificaciones(has: true);
      return res[0]['has'];
    }
    return 0;
  }

  ///
  Future<void> _checkMarcasAndModelos() async {

    this._haciendo = 'Revisando Marcas y Modelos';
    setState(() {});
    bool hasAutos = await emAutos.hasMarcasAndModelos();
    if(!hasAutos) {
      await emAutos.getSetMarcasAndModelos();
    }
  }

  ///
  Future<void> _checkCategos() async {

    this._haciendo = 'Categorías y Servicios';
    setState(() {});
    await emVarios.getAllCategosFromServer();
  }

}