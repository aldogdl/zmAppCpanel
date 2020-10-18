library zonamotora.globals;

const String env = 'prod';

const int devClvTmp = 1;
const String version = '1.0.0';

const String protocolo         = (env == 'dev') ? 'http://' : 'https://';
const String ip                = (env == 'dev') ? '192.168.100.123' : 'dbzm.info';
const String uriCpanel         = (env == 'dev') ? ip : '$protocolo'+'buscomex.com';
const String uriZMPortal       = '$protocolo'+'zonamotora.com';
const String uriAPZPortal      = '$protocolo'+'autoparteszone.com';
const String dominio           = '$protocolo$ip';
const String uripublicZmdb     = (env == 'dev') ? '$dominio/dbzm/public_html/' : '$dominio/';
const String uriBase           = (env == 'dev') ? '$uripublicZmdb'+'index.php' : '$dominio';
const String uriImgSolicitudes = '$uripublicZmdb' + 'solicitudes_nuevas/images';
const String uriImageInvent    = '$uripublicZmdb' + 'images/refacciones';
const String uriImagePublica   = '$uripublicZmdb' + 'images/publicaciones';

const String uriImgsAldo       = 'https://s3-us-west-2.amazonaws.com/aldoautopartesproductos';

const int tamMaxFotoPzas = 768;
const double iva = 16;