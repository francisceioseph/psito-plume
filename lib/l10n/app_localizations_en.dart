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

  @override
  String closeTitle(String name) {
    return 'Save the changes to $name?';
  }

  @override
  String get closeBody => 'If you do not save, the changes will be lost.';

  @override
  String get dontSave => 'Don\'t save';

  @override
  String get toolSelect => 'Selection';

  @override
  String get copy => 'Copy';

  @override
  String get cut => 'Cut';

  @override
  String get paste => 'Paste';

  @override
  String get selectAll => 'Select all';

  @override
  String get nothingToPaste => 'There is no picture to paste.';

  @override
  String get helpSelection =>
      'The selection (M) marks a rectangle. Drag from inside it to move what it holds; it stays loose until you click outside, press Escape or pick another tool, and Ctrl+Z puts it back. Ctrl+C copies, Ctrl+X cuts, Ctrl+V pastes a picture copied here or in another program, Ctrl+A selects everything and Delete clears the selection.';

  @override
  String get toolText => 'Text';

  @override
  String get fontSans => 'Sans serif font';

  @override
  String get fontSerif => 'Serif font';

  @override
  String get typeHere => 'Type here';

  @override
  String get helpText =>
      'The text tool (T) writes where you click, in the colour and size chosen, with or without serifs. Enter puts the text in the drawing, Shift+Enter starts a new line and Escape gives up; clicking elsewhere also finishes it.';

  @override
  String get imageMenu => 'Image';

  @override
  String get resize => 'Resize';

  @override
  String get sheetSize => 'Sheet size';

  @override
  String get rotateRight => 'Rotate right';

  @override
  String get rotateLeft => 'Rotate left';

  @override
  String get rotateHalf => 'Rotate 180°';

  @override
  String get flipHorizontal => 'Flip horizontally';

  @override
  String get flipVertical => 'Flip vertically';

  @override
  String get crop => 'Crop to the selection';

  @override
  String get keepRatio => 'Keep the proportion';

  @override
  String get apply => 'Apply';

  @override
  String get helpImage =>
      'The image menu in the bar resizes, rotates and flips the selection, or the whole drawing when nothing is selected. Sheet size adds paper or cuts the edges without stretching, and Crop keeps only what is selected. Ctrl+W resizes, Ctrl+E changes the sheet, Ctrl+R and Ctrl+Shift+R rotate and Ctrl+Shift+X crops.';

  @override
  String primaryColor(String code) {
    return 'Main colour, left button, $code';
  }

  @override
  String secondaryColor(String code) {
    return 'Second colour, right button, $code';
  }

  @override
  String get swapColors => 'Swap the colours';

  @override
  String get helpColors =>
      'There are two colours: the main one for the left button and the second one, white at first, for the right button. On the palette, the left button picks the main colour and the right button the second; X swaps them. The eraser with the right button only takes away the main colour and keeps the rest.';

  @override
  String get dropHint => 'Drop the picture to open it';

  @override
  String get helpOpen =>
      'Pictures also open by dragging them onto the window, or with Open with Psito Plume in the file manager.';

  @override
  String get toolSpray => 'Spray';

  @override
  String get toolCurve => 'Curve';

  @override
  String get toolArrow => 'Arrow';

  @override
  String get toolRoundedRectangle => 'Rounded rectangle';

  @override
  String get toolPolygon => 'Polygon';

  @override
  String get helpShapes =>
      'More shapes: the curve (C) is drawn as a line and bent with a second drag; the polygon (G) gets a corner per click and closes on the first corner, on a second click on the last one or with Enter; Escape gives up either. There are also the arrow (W), the rounded rectangle (U) and the spray (A).';

  @override
  String get toolFeather => 'Feather brush';

  @override
  String get helpFeather =>
      'The feather brush (Q) lays cockatiel feathers along the stroke, in the colour chosen, leaning to one side and the other as it goes.';
}
