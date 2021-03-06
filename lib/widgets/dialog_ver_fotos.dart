import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import 'package:zmcpanel/singletons/solicitud_sngt.dart';
import 'package:zmcpanel/globals.dart' as globals;

class DialogVerFotosWidget extends StatelessWidget {

  final SolicitudSngt solicitudSgtn = SolicitudSngt();
  
  final List<dynamic> fotos;
  final String typeFoto;
  final String subForder;
  final BuildContext contextSend;

  DialogVerFotosWidget({this.contextSend, this.fotos, this.typeFoto, this.subForder});

  final Map<String, dynamic> _prefixFoto = {
    'solicitudes': '${globals.uriImgSolicitudes}',
    'inventario' : '${globals.uriImageInvent}',
    'publicacion': '${globals.uriImagePublica}'
  };

  @override
  Widget build(BuildContext context) {

    return  AlertDialog(
      insetPadding: EdgeInsets.all(2),
      contentPadding: EdgeInsets.all(2),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8, //solicitudSgtn.thubFachadaX.toDouble(),
        color: Colors.black,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: fotos.length,
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes,
              ),
            ),
          ),
          builder: (BuildContext context, int index) {

            ImageProvider imagen;
            String pathFoto;
            if(this.subForder != null){
              pathFoto = '${this._prefixFoto[this.typeFoto]}/${this.subForder}/${fotos[index]}';
            }else{
              pathFoto = '${this._prefixFoto[this.typeFoto]}/${fotos[index]}';
            }
            if(fotos[index].runtimeType == String) {
              imagen = NetworkImage(pathFoto);
            }else{

              if(fotos[index].containsKey('identifier')) {
                imagen = AssetThumbImageProvider(
                  Asset(fotos[index]['identifier'], fotos[index]['nombre'], fotos[index]['width'], fotos[index]['height']),
                  width: fotos[index]['width'],
                  height: fotos[index]['height']
                );
              }
            }

            
            return PhotoViewGalleryPageOptions(
              imageProvider: imagen,
              initialScale: PhotoViewComputedScale.contained,
            );
          },
        )
      ),
    );
  }

  ///
  // ImageProvider _determinarElTipoDeWidgetParaLaImagen(dynamic foto) {

  //   dynamic variable = foto;
  //   dynamic tipoVar = variable.runtimeType;

  //   ImageProvider imagen;
  //   final foto = (fotos[index].contains('.')) ? fotos[index] : fotos[index]['nombre'];

  //   ImageProvider imagen = (!solicitudSgtn.onlyRead)
  //           ?
  //           AssetThumbImageProvider(
  //             Asset(foto['identifier'], foto['nombre'], foto['width'], foto['height']),
  //             width: foto['width'],
  //             height: foto['height']
  //           )
  //           :
  //           NetworkImage('${this._prefixFoto[this.typeFoto]}/$foto');
  //   return imagen;
  // }
}
