import 'dart:math';

class ChatbotLogic {

  static String getResponse(String message) {
    message = message.toLowerCase();

    // SALUDO


    // PROGRAMAS EDUCATIVOS
    if (RegExp(r".*(programas|carreras|oferta educativa).*",
  caseSensitive: false,).hasMatch(message)) {

      return "Programas educativos ofertados:\n\n"
      "• Ingeniería Ambiental\n"
      "• Ingeniería Biomédica\n"
      "• Ingeniería Bioquímica\n"
      "• Ingeniería Civil\n"
      "• Ingeniería Eléctrica\n"
      "• Ingeniería Electrónica\n"
      "• Ingeniería en Ciberseguridad\n"
      "• Ingeniería en Gestión Empresarial\n"
      "• Ingeniería en Semiconductores\n"
      "• Ingeniería en Sistemas Computacionales\n"
      "• Ingeniería Industrial\n"
      "• Ingeniería Mecánica\n"
      "• Ingeniería Química\n"
      "• Licenciatura en Administración";
    }

    // PROCESO DE INSCRIPCION
    if (RegExp(r".*(inscrib|inscripcion|admi(s|c)ion).*",
  caseSensitive: false,).hasMatch(message)) {

      return "Proceso de inscripción:\n\n"

      "1️⃣ Registro en el Sistema de Integración Escolar (SIE) y captura de datos generales\n"
      "📅 Del 5 de febrero al 21 de mayo de 2026\n\n"

      "2️⃣ Obtener preficha\n"
      "📅 5 al 19 de febrero de 2026\n"
      "📅 2 al 19 de marzo de 2026\n"
      "📅 13 al 23 de abril de 2026\n"
      "📅 4 al 21 de mayo de 2026\n\n"

      "3️⃣ Realizar el pago por derecho a examen de admisión\n"
      "📅 5 al 20 de febrero de 2026\n"
      "📅 2 al 20 de marzo de 2026\n"
      "📅 13 al 24 de abril de 2026\n"
      "📅 4 al 22 de mayo de 2026\n\n"

      "4️⃣ Generación de ficha de aspirante\n"
      "📅 Fecha límite: 29 de mayo de 2026\n\n"

      "5️⃣ Publicación del horario del examen\n"
      "📅 8 de junio de 2026\n\n"

      "6️⃣ Aplicación del examen de admisión (en línea desde casa)\n"
      "📅 13 y 14 de junio de 2026\n\n"

      "7️⃣ Publicación de resultados\n"
      "📅 19 de junio de 2026\n\n"

      "Para consultar los pasos completos visita:\n"
      "https://www.merida.tecnm.mx/wp-content/uploads/2026/02/convocatoria-nuevo-ingreso-2026_2.pdf";
    }


    if (RegExp(r".*(informacion.*(importante|adicional)|consideraciones.*importantes|que.*debo.*saber|requisitos.*especiales|aclaraciones.*proceso).*",
  caseSensitive: false,)
    .hasMatch(message)) {

      return "Información importante:\n\n"
      "• Para las personas que cuentan con el grado de licenciatura es necesario tener el título que acredite estos estudios y enviar un correo electrónico a dep_merida@tecnm.mx para validar tu procedimiento de admisión.\n\n"
      "• Esta convocatoria es solamente para aspirantes a nuevo ingreso.\n\n"
      "• Los exámenes realizados en otra institución de nivel superior no tienen validez en el Instituto Tecnológico de Mérida.";
    }

    if (RegExp(r".*(mas informacion|obtener.*informacion|donde.*preguntar|resolver.*dudas|correo.*admision|dudas.*proceso).*",
  caseSensitive: false,)
    .hasMatch(message)) {

      return "Si tienes dudas o preguntas sobre el proceso de admisión puedes contactar a:\n\n"
      "📧 admision.itmerida@merida.tecnm.mx\n\n"
      "También puedes consultar la convocatoria completa en:\n"
      "https://www.merida.tecnm.mx/wp-content/uploads/2026/02/convocatoria-nuevo-ingreso-2026_2.pdf";
    }

    if (RegExp(r".*(perfil.*(ingreso|aspirante)|que.*(debo.*saber|conocimientos.*(necesito|debo.*tener))|requisitos.*academicos|preparacion.*necesaria).*|perfil",
  caseSensitive: false,)
    .hasMatch(message)) {

      return "Perfil de ingreso:\n\n"
      "• Conocimientos fundamentales en ciencias básicas: matemáticas, física y química.\n\n"
      "• Comprensión lectora para analizar información de forma individual y discutirla en grupos de trabajo colaborativo.\n\n"
      "• Responsabilidad en su formación académica y aprendizaje continuo.\n\n"
      "Para consultar el perfil completo visita:\n"
      "https://www.merida.tecnm.mx/wp-content/uploads/2026/02/convocatoria-nuevo-ingreso-2026_2.pdf";
    }

    if (RegExp(r".*((registro|registrar|registrarme).*sie|(usar|como).*sie|sistema.*integracion.*escolar).*" ,
  caseSensitive: false,)
    .hasMatch(message)) {

      return "Registro en el sistema de integración escolar (sie):\n\n"
      "• ingresa al sitio sie (sistema de integración escolar).\n"
      "• registra tu curp (sin clave de acceso o contraseña).\n"
      "• haz clic en \"aceptar\".\n"
      "• ingresa nuevamente al sie con tu curp (siempre ingresarás sin contraseña).\n"
      "• selecciona \"datos generales\" en el menú principal.\n"
      "• haz clic en \"modificar datos\" para llenar los espacios con tu información y al finalizar haz clic en \"guardar\".";
    }

  if (RegExp(
  r"(requisitos de ingreso|que necesito para ingresar|requisitos para entrar|que se necesita para entrar|requisitos|que debo cumplir para ingresar|condiciones para ingresar)",
  caseSensitive: false,
).hasMatch(message)) {

      return "Requisitos de ingreso:\n\n"
      "Necesitas haber concluido tus estudios de nivel bachillerato, "
      "haber aplicado el examen de admisión y obtener la aprobación de este.";
    }

    if (RegExp(
  r"(resultados de examen|cuando salen los resultados|fecha de resultados|cuando publican los resultados|resultados del examen de admision|cuando salen los resultados del examen)",
  caseSensitive: false,
).hasMatch(message)) {

      return "Los resultados del examen de admisión se publican el:\n\n"
      "📅 19 de junio de 2026.";
    }

    if (RegExp(
  r"(fechas importantes|fechas del proceso|calendario de admision|fechas de admision|calendario de inscripcion|fechas del examen|fechas)",
  caseSensitive: false,
).hasMatch(message)) {

      return "IMAGE:assets/images/fechas.png";
    }

    //bruhhhhhhhhhhhh

    if (RegExp(r"(maxwell)",caseSensitive: false,).hasMatch(message)) {

      return "IMAGE:assets/images/cot.gif";
    }
    if (RegExp(r"(fish)",caseSensitive: false,).hasMatch(message)) {

      return "IMAGE:assets/images/fish.gif";
    }
    if (RegExp(r"(neko)",caseSensitive: false,).hasMatch(message)) {

      return "IMAGE:assets/images/neko.gif";
    }
    if (RegExp(r"(freddy)",caseSensitive: false,).hasMatch(message)) {

      return "VIDEO:assets/videos/freddy.mp4";
    }
    if (RegExp(r"(wolf)",caseSensitive: false,).hasMatch(message)) {

      return "AUDIO:assets/sounds/wolf.mp3";
    }



    //Sugerencias de palabras incompletas

    if (RegExp(r"(fech|calend)", caseSensitive: false).hasMatch(message)) {
      return "¿Te refieres a:\n"
            "• Fechas importantes\n"
            "• Fechas del proceso\n"
            "• Calendario de admisión?";
    }

    if (RegExp(r"(inscrip|registr)", caseSensitive: false).hasMatch(message)) {
      return "¿Quieres saber sobre:\n"
            "• Proceso de inscripción\n"
            "• Registro en el SIE?";
    }

    if (RegExp(r"(result)", caseSensitive: false).hasMatch(message)) {
      return "¿Quieres saber:\n"
            "• Resultados del examen de admisión?";
    }


    //generales


    if (RegExp(
      r"(preguntas|puedo preguntar|preguntar|questions|opciones)",
      caseSensitive: false,
    ).hasMatch(message)) {

      final respuestas = [
        "Algunas dudas frecuentes son:\n",
        "Puedes preguntarme cosas como:\n",
        "Estas son algunas preguntas que puedo responder:\n",
        "Aquí tienes algunas opciones:\n",
      ];

      final random = Random();
      final frase = respuestas[random.nextInt(respuestas.length)];

      return frase +
            "• Fechas importantes\n"
            "• Requisitos\n"
            "• Información importante\n"
            "• Proceso de inscripción\n"
            "• Mas información\n";
    }

    return "Lo siento, no entendí tu pregunta. Puedes preguntar sobre:\n"
           "• Carreras\n"
           "• Proceso de inscripción";
  }

}