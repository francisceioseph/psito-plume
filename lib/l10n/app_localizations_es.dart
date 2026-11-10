// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Psito Plume';

  @override
  String get untitled => 'Sin título';

  @override
  String get newImage => 'Dibujo nuevo';

  @override
  String get open => 'Abrir';

  @override
  String get save => 'Guardar';

  @override
  String get saveAs => 'Guardar como';

  @override
  String get undo => 'Deshacer';

  @override
  String get redo => 'Rehacer';

  @override
  String get zoomIn => 'Acercar';

  @override
  String get zoomOut => 'Alejar';

  @override
  String get actualSize => 'Tamaño real';

  @override
  String get moreOptions => 'Más opciones';

  @override
  String get howToUse => 'Cómo usar';

  @override
  String get about => 'Acerca de';

  @override
  String get close => 'Cerrar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Crear';

  @override
  String get choose => 'Elegir';

  @override
  String get discard => 'Descartar';

  @override
  String get width => 'Ancho';

  @override
  String get height => 'Alto';

  @override
  String get images => 'Imágenes';

  @override
  String get pngImage => 'Imagen PNG';

  @override
  String get discardTitle => '¿Descartar el dibujo?';

  @override
  String get discardBody => 'Se perderán los cambios que no se guardaron.';

  @override
  String saved(String name) {
    return 'Guardado como $name';
  }

  @override
  String openFailed(String name) {
    return 'No se pudo abrir $name.';
  }

  @override
  String saveFailed(String name) {
    return 'No se pudo guardar $name.';
  }

  @override
  String get toolPencil => 'Lápiz';

  @override
  String get toolBrush => 'Pincel';

  @override
  String get toolEraser => 'Goma';

  @override
  String get toolFill => 'Bote de pintura';

  @override
  String get toolPicker => 'Cuentagotas';

  @override
  String get toolLine => 'Línea';

  @override
  String get toolRectangle => 'Rectángulo';

  @override
  String get toolEllipse => 'Elipse';

  @override
  String get toolStamp => 'Sello de cacatúa';

  @override
  String sizeOption(int pixels) {
    return 'Tamaño $pixels px';
  }

  @override
  String get outline => 'Solo el contorno';

  @override
  String get filled => 'Relleno';

  @override
  String get moreColors => 'Más colores';

  @override
  String currentColor(String code) {
    return 'Color en uso, $code';
  }

  @override
  String colorSwatch(String code) {
    return 'Color $code';
  }

  @override
  String get colorCode => 'Código del color';

  @override
  String position(int x, int y) {
    return '$x, $y px';
  }

  @override
  String imageSize(int width, int height) {
    return '$width × $height px';
  }

  @override
  String canvasLabel(int width, int height) {
    return 'Hoja de dibujo, $width por $height píxeles';
  }

  @override
  String get howToUseBody =>
      'Elige una herramienta a la izquierda y un color abajo, y dibuja en la hoja. El cuadrado de abajo a la izquierda abre más colores, con un campo para el código del color.\n\nEl lápiz, el pincel y la goma dibujan mientras arrastras. La línea, el rectángulo y la elipse van desde donde aprietas hasta donde sueltas; con Shift salen ángulos rectos, cuadrados y círculos. El bote de pintura rellena un área, el cuentagotas toma un color del dibujo y el sello pone una de las cacatúas de Psito Nest donde hagas clic.\n\nTeclas: P lápiz, B pincel, E goma, F bote, I cuentagotas, L línea, R rectángulo, O elipse, S sello.\n\nCtrl+Z deshace y Ctrl+Y rehace. Ctrl+N empieza un dibujo nuevo, Ctrl+O abre una imagen y Ctrl+S la guarda en PNG. Ctrl con la rueda del ratón, o Ctrl+más y Ctrl+menos, cambian el zoom; Ctrl+0 vuelve al tamaño real.';

  @override
  String get aboutBody =>
      'Un pequeño programa de dibujo con cacatúas. Sin anuncios, sin telemetría y sin cuenta.';

  @override
  String get aboutLegal => 'Código bajo la licencia Apache 2.0. Arte bajo CC0.';

  @override
  String get bird1 => 'Huevo';

  @override
  String get bird2 => 'Huevo eclosionando';

  @override
  String get bird3 => 'Recién nacido';

  @override
  String get bird4 => 'Polluelo';

  @override
  String get bird5 => 'Joven';

  @override
  String get bird6 => 'Gris';

  @override
  String get bird7 => 'Perla';

  @override
  String get bird8 => 'Canela';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Arlequín';

  @override
  String get bird11 => 'Reina dorada';

  @override
  String closeTitle(String name) {
    return '¿Guardar los cambios en $name?';
  }

  @override
  String get closeBody => 'Si no guardas, los cambios se perderán.';

  @override
  String get dontSave => 'No guardar';

  @override
  String get toolSelect => 'Selección';

  @override
  String get copy => 'Copiar';

  @override
  String get cut => 'Cortar';

  @override
  String get paste => 'Pegar';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get nothingToPaste => 'No hay ninguna imagen para pegar.';

  @override
  String get helpSelection =>
      'La selección (M) marca un rectángulo. Arrastra desde dentro para mover lo que contiene; queda suelto hasta que haces clic fuera, pulsas Esc o eliges otra herramienta, y Ctrl+Z lo devuelve a su lugar. Ctrl+C copia, Ctrl+X corta, Ctrl+V pega una imagen copiada aquí o en otro programa, Ctrl+A selecciona todo y Supr borra la selección.';
}
