import 'package:flutter/material.dart';

import 'package:zmcpanel/pages/altas/alta_index_menu_page.dart';
import 'package:zmcpanel/pages/altas/alta_mksmds_page.dart';
import 'package:zmcpanel/pages/altas/alta_pagina_web_build_page.dart';
import 'package:zmcpanel/pages/altas/alta_pagina_web_busk_user_page.dart';
import 'package:zmcpanel/pages/altas/alta_pagina_web_carrucel_page.dart';
import 'package:zmcpanel/pages/altas/alta_pagina_web_despeq_page.dart';
import 'package:zmcpanel/pages/altas/alta_pagina_web_logo_page.dart';
import 'package:zmcpanel/pages/altas/alta_perfil_contac_page.dart';
import 'package:zmcpanel/pages/altas/alta_perfil_otros_page.dart';
import 'package:zmcpanel/pages/altas/alta_perfil_pwrs_page.dart';
import 'package:zmcpanel/pages/altas/alta_save_resum_page.dart';
import 'package:zmcpanel/pages/altas/alta_sistema_page.dart';
import 'package:zmcpanel/pages/altas/alta_sistema_palclas_page.dart';
import 'package:zmcpanel/pages/altas/lista_users_page.dart';

import 'package:zmcpanel/pages/init_config/init_config_page.dart';
import 'package:zmcpanel/pages/login/login_asesor_page.dart';
import 'package:zmcpanel/pages/login/registro_user_page.dart';

class Rutas {

  Map<String, Widget Function(BuildContext)> getRutas(BuildContext context) {

    return {
      'init_config_page'       : (context) => InitConfigPage(),
      'login_asesor_page'      : (context) => LoginAsesorPage(),
      'reg_user_page'          : (context) => RegistroUserPage(),
      'alta_index_menu_page'   : (context) => AltaIndexMenuPage(),
      'alta_lst_users_page'    : (context) => ListaUsersPage(),
      'alta_sistema_page'      : (context) => AltaSistemaPage(),
      'alta_sistema_pc_page'   : (context) => AltaSistemaPalClasPage(),
      'alta_mksmds_page'       : (context) => AltaMksMdsPage(),
      'alta_perfil_contac_page': (context) => AltaPerfilContacPage(),
      'alta_perfil_pwrs_page'  : (context) => AltaPerfilPWRSPage(),
      'alta_perfil_otros_page' : (context) => AltaPerfilOtrosPage(),
      'alta_save_resum_page'   : (context) => AltaSaveResumPage(),
      'alta_pagina_web_bsk_page': (context) => AltaPaginaWebBuskUserPage(),
      'alta_pagina_web_despeq_page':(context) => AltaPaginaWebDesPeqPage(),
      'alta_pagina_web_carrucel_page':(context) => AltaPaginaWebCarrucelPage(),
      'alta_pagina_web_build_page':(context) => AltaPaginaWebBuildPage(),
      'alta_pagina_web_logo_page':(context) => AltaPaginaWebLogoPage(),
    };
  }
}