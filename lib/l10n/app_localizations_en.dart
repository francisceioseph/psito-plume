// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Psito Plume';

  @override
  String get untitled => 'Untitled';

  @override
  String get newImage => 'New drawing';

  @override
  String get open => 'Open';

  @override
  String get save => 'Save';

  @override
  String get saveAs => 'Save as';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get zoomIn => 'Zoom in';

  @override
  String get zoomOut => 'Zoom out';

  @override
  String get actualSize => 'Actual size';

  @override
  String get moreOptions => 'More options';

  @override
  String get howToUse => 'How to use';

  @override
  String get about => 'About';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get create => 'Create';

  @override
  String get choose => 'Choose';

  @override
  String get discard => 'Discard';

  @override
  String get width => 'Width';

  @override
  String get height => 'Height';

  @override
  String get images => 'Images';

  @override
  String get pngImage => 'PNG image';

  @override
  String get discardTitle => 'Discard the drawing?';

  @override
  String get discardBody => 'The changes that were not saved will be lost.';

  @override
  String saved(String name) {
    return 'Saved as $name';
  }

  @override
  String openFailed(String name) {
    return '$name could not be opened.';
  }

  @override
  String saveFailed(String name) {
    return '$name could not be saved.';
  }

  @override
  String get toolPencil => 'Pencil';

  @override
  String get toolBrush => 'Brush';

  @override
  String get toolEraser => 'Eraser';

  @override
  String get toolFill => 'Paint bucket';

  @override
  String get toolPicker => 'Colour picker';

  @override
  String get toolLine => 'Line';

  @override
  String get toolRectangle => 'Rectangle';

  @override
  String get toolEllipse => 'Ellipse';

  @override
  String get toolStamp => 'Cockatiel stamp';

  @override
  String sizeOption(int pixels) {
    return 'Size $pixels px';
  }

  @override
  String get outline => 'Outline only';

  @override
  String get filled => 'Filled';

  @override
  String get moreColors => 'More colours';

  @override
  String currentColor(String code) {
    return 'Colour in use, $code';
  }

  @override
  String colorSwatch(String code) {
    return 'Colour $code';
  }

  @override
  String get colorCode => 'Colour code';

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
    return 'Drawing sheet, $width by $height pixels';
  }

  @override
  String get howToUseBody =>
      'Pick a tool on the left and a colour at the bottom, then draw on the sheet. The square on the bottom left opens more colours, with a field for a colour code.\n\nPencil, brush and eraser draw while you drag. Line, rectangle and ellipse are drawn from where you press to where you let go; holding Shift makes straight angles, squares and circles. The paint bucket fills an area, the colour picker takes a colour from the drawing, and the stamp puts one of the Psito Nest cockatiels where you click.\n\nKeys: P pencil, B brush, E eraser, F bucket, I picker, L line, R rectangle, O ellipse, S stamp.\n\nCtrl+Z undoes and Ctrl+Y redoes. Ctrl+N starts a new drawing, Ctrl+O opens a picture and Ctrl+S saves it as PNG. Ctrl and the mouse wheel, or Ctrl+plus and Ctrl+minus, zoom; Ctrl+0 goes back to the actual size.';

  @override
  String get aboutBody =>
      'A little paint program with cockatiels. No ads, no telemetry and no account.';

  @override
  String get aboutLegal => 'Code under the Apache 2.0 license. Art under CC0.';

  @override
  String get bird1 => 'Egg';

  @override
  String get bird2 => 'Hatching egg';

  @override
  String get bird3 => 'Newborn';

  @override
  String get bird4 => 'Chick';

  @override
  String get bird5 => 'Fledgling';

  @override
  String get bird6 => 'Grey';

  @override
  String get bird7 => 'Pearl';

  @override
  String get bird8 => 'Cinnamon';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Pied';

  @override
  String get bird11 => 'Golden queen';
}
