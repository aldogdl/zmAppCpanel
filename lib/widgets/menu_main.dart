import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zmcpanel/data_shared.dart';
import 'package:zmcpanel/globals.dart' as globals;
import 'package:zmcpanel/widgets/frm_change_ip.dart';


class MenuMain extends StatelessWidget {

  MenuMain({Key key}) : super(key: key);

  final btns = {
    'config': {
      'titulo' : 'Ver Configuraciones',
      'ico' : Icons.settings,
      'path'  : 'config_page'
    },
    'vincular': {
      'titulo': 'Vincular Dispositivo',
      'ico'   : Icons.phone_android,
      'path'  : 'inxed_page'
    },
  };

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height * 0.25;
    
    return SafeArea(
      child: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: w, height: h,
              child: _cabecera(w, h),
            ),
            Consumer<DataShared>(
              builder: (_, dataShared, __){
                String tipoApp;
                if(dataShared.username == null){
                  tipoApp = 'Aplicaión Genérica';
                }else{
                  tipoApp = 'Aplicaión Genérica';
                }
                if(dataShared.username != 'Anónimo') {
                  tipoApp = 'App. Autorizada para ${dataShared.username}';
                }
                return _titulo(w, '$tipoApp');
              },
            ),
            (globals.env == 'dev')
            ?
            FrmChangeIpWidget()
            :
            SizedBox(height: 0),
            Expanded(
              child: ListView(
                children: [

                  Column(
                    children: [
                      _getDivider(),
                      _btnCreate(context, btns['vincular'])
                    ],
                  ),
                  _getDivider(),
                  _btnCreate(context, btns['config']),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  Widget _getDivider() {
    return Divider(height: 1, color: Colors.red[200]);
  }

  ///
  Widget _cabecera(double w, double h) {

    return Stack(
      alignment: Alignment.center,
      overflow: Overflow.clip,
      children: <Widget>[
        Positioned(
          top: 0,
          child: Container(
            width: w,
            height: h,
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Color(0xffffffff),
                  Color(0xffffffff),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
          )
        ),
        Positioned(
          top: 20,
          child: SizedBox(
            width: w * 0.8,
            height: h * 0.8,
            child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/zona_motora.png'),
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 10,
          child: Text(
            '${globals.version}',
            textScaleFactor: 1,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          )
        ),
      ],
    );
  }

  /* */
  Widget _titulo(double w, String titulo) {

    return Container(
      height: 30,
      width: w,
      color: Colors.grey[300],
      child: Center(
        child: Text(
          '$titulo',
          textScaleFactor: 1,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  /* */
  Widget _btnCreate(BuildContext context, Map<String, dynamic> data) {

    return ListTile(
      onTap: (){
        if(data['path'] == 'config_page') {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(data['path']);
        }else{
          Navigator.of(context).pushNamedAndRemoveUntil(data['path'], (Route rutas) => false);
        }
      },
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
      dense: true,
      title: Text(
        '${data['titulo']}',
        textScaleFactor: 1,
        textAlign: TextAlign.start,
      ),
      leading: Icon(data['ico'])
    );
  }

}