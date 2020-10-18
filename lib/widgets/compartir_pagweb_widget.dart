import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';

import 'package:zmcpanel/globals.dart' as globals;
import 'package:zmcpanel/singletons/alta_user_sngt.dart';

class CompartiPagWebWidget extends StatefulWidget {

  final BuildContext contextFromCall;

  CompartiPagWebWidget({Key key, this.contextFromCall}) : super(key: key);

  @override
  _CompartiPagWebWidgetState createState() => _CompartiPagWebWidgetState();
}

class _CompartiPagWebWidgetState extends State<CompartiPagWebWidget> {

  AltaUserSngt altaUserSngt = AltaUserSngt();
  
  bool _showMsgSend = false;
  bool _showBtnClose = false;
  String _txtMsgSend = 'Enviando...';
  String _telefono;
  int _idPagina;
  StateSetter _setStateDialog;

  @override
  Widget build(BuildContext context) {

    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: 10),
        child: IconButton(
          icon: Icon(Icons.share, size: 35, color: Colors.red),
          onPressed: () async {
            await _showListDialog();
          },
        ),
      ),
    );
  }

  ///
  Future<void> _showListDialog() async {

    showDialog(
      context: this.widget.contextFromCall,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            this._setStateDialog = setState;
            setState = null;

            return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(5),
              scrollable: true,
              content: FutureBuilder(
                future: _getNumberPhone(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {

                  if(snapshot.hasData) {
                    if(snapshot.data) {
                    return  _lstDeAcciones();
                    }else{
                      return _sinData();
                    }
                  }

                  return Center(
                    child: SizedBox(
                      height: 45,
                      width: 45,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              )
            );
          },
        );
      }
    );
  }

  ///
  Widget _lstDeAcciones() {

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        (this._showMsgSend)
        ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const  LinearProgressIndicator(),
            const SizedBox(height: 3),
            Text(
              '${this._txtMsgSend}',
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey
              ),
            )
          ],
        )
        :
        const SizedBox(height: 0),
        _machoteTile(
          keySend: 'pw',
          titulo: 'Página Web',
          subTitulo: 'compartir el Link',
          icono: Icons.language_rounded
        ),
        _machoteTile(
          keySend: 'td',
          titulo: 'Tarjeta Digital',
          subTitulo: 'Link de Descarga',
          icono: Icons.contact_phone
        ),
        Padding(
          padding: EdgeInsets.all(7),
          child: Text(
            'Enviar a: ${this._telefono}',
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue
            ),
          ),
        ),
        (this._showBtnClose)
        ?
        RaisedButton(
          onPressed: () => Navigator.of(widget.contextFromCall).pop(true),
          child: Text(
            'CERRAR ACCIONES',
            textScaleFactor: 1,
          ),
          color: Color(0xff002f51),
          textColor: Colors.white,
        )
        :
        const SizedBox(height: 0)
      ],
    );
  }

  ///
  Widget _machoteTile({
    String keySend,
    String titulo,
    String subTitulo,
    IconData icono
  }) {

    return ListTile(
      title: Text(
        '$titulo',
        textScaleFactor: 1,
      ),
      subtitle: Text(
        '$subTitulo',
        textScaleFactor: 1,
      ),
      leading: Icon(icono),
      trailing: Icon(Icons.navigate_next_rounded),
      onTap: (){
        switch (keySend) {
          case 'td':
             _enviarTarjetaDigital();
            break;
          case 'pw':
             _enviarLinkPaginaWeb();
            break;
          default:
        }
      },
    );
  }
  
  ///
  Widget _sinData() {

    return Container(
      child: Text(
        'No se detectaron los datos del usuario',
        textScaleFactor: 1,
      ),
    );
  }

  ///
  Future<bool> _getNumberPhone() async {

    Map<String, dynamic> dataPag = altaUserSngt.createDataSitioWeb;

    if(dataPag.containsKey('idp')){
      if(dataPag['idp'] > 0 && dataPag['idp'].toString().isNotEmpty){
        this._idPagina = dataPag['idp'];
      }else{
        this._idPagina = 0;
      }
    }
    dataPag = null;

    if(altaUserSngt.rolesFromPagWeb.isEmpty) {
      return false;
    }

    this._telefono = altaUserSngt.movilTel;

    if(this._telefono.isEmpty) {
      if(this._idPagina == 0){
        print('buscar el id de la pagina');  
      }else{
        print('buscar número de telefono');
      }
      return true;
    }else{
      return true;
    }
  }

  ///
  Future<void> _enviarTarjetaDigital() async {

    SmsMessage message = new SmsMessage(this._telefono, 'ZonaMotora Informa :: Tu Tarjeta Digital esta lista en: ${globals.uriCpanel}/cpanel/pdfs/${this._idPagina}/download/');
    _sendMsg(message);
  }

  ///
  Future<void> _enviarLinkPaginaWeb() async {
    String slug = altaUserSngt.createDataSitioWeb['slug'];
    String portal = (altaUserSngt.rolesFromPagWeb[0] == 'ROLE_SOCIO') ? globals.uriAPZPortal : globals.uriZMPortal;
    SmsMessage message = new SmsMessage(this._telefono, 'ZonaMotora informa:: Tu Sitio Web esta listo en: $portal/$slug/');
    _sendMsg(message);
  }

  ///
  Future<void> _sendMsg(SmsMessage message) async {

     this._setStateDialog(() {
      this._txtMsgSend = 'Enviando...';
      this._showMsgSend = true;
    });
    SmsSender sender = new SmsSender();
    message.onStateChanged.listen((state) {

      if (state == SmsMessageState.Sent) {
        this._txtMsgSend = 'Mensaje Enviado OK';
        this._showBtnClose = true;
      } else if (state == SmsMessageState.Delivered) {
        this._txtMsgSend = 'No se ha enviado el Mensaje ERROR';
        this._showBtnClose = true;
      }
      if(this._showBtnClose){
        this._showMsgSend = false;
      }

      this._setStateDialog(() {});
    });
    sender.sendSms(message);
  }
}