// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Psito Plume';

  @override
  String get untitled => 'Unbenannt';

  @override
  String get newImage => 'Neue Zeichnung';

  @override
  String get open => 'Öffnen';

  @override
  String get save => 'Speichern';

  @override
  String get saveAs => 'Speichern unter';

  @override
  String get undo => 'Rückgängig';

  @override
  String get redo => 'Wiederholen';

  @override
  String get zoomIn => 'Vergrößern';

  @override
  String get zoomOut => 'Verkleinern';

  @override
  String get actualSize => 'Originalgröße';

  @override
  String get moreOptions => 'Weitere Optionen';

  @override
  String get howToUse => 'Bedienung';

  @override
  String get about => 'Über';

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get create => 'Erstellen';

  @override
  String get choose => 'Auswählen';

  @override
  String get discard => 'Verwerfen';

  @override
  String get width => 'Breite';

  @override
  String get height => 'Höhe';

  @override
  String get images => 'Bilder';

  @override
  String get pngImage => 'PNG-Bild';

  @override
  String get discardTitle => 'Zeichnung verwerfen?';

  @override
  String get discardBody => 'Nicht gespeicherte Änderungen gehen verloren.';

  @override
  String saved(String name) {
    return 'Gespeichert als $name';
  }

  @override
  String openFailed(String name) {
    return '$name konnte nicht geöffnet werden.';
  }

  @override
  String saveFailed(String name) {
    return '$name konnte nicht gespeichert werden.';
  }

  @override
  String get toolPencil => 'Bleistift';

  @override
  String get toolBrush => 'Pinsel';

  @override
  String get toolEraser => 'Radierer';

  @override
  String get toolFill => 'Farbeimer';

  @override
  String get toolPicker => 'Pipette';

  @override
  String get toolLine => 'Linie';

  @override
  String get toolRectangle => 'Rechteck';

  @override
  String get toolEllipse => 'Ellipse';

  @override
  String get toolStamp => 'Nymphensittich-Stempel';

  @override
  String sizeOption(int pixels) {
    return 'Größe $pixels px';
  }

  @override
  String get outline => 'Nur Umriss';

  @override
  String get filled => 'Gefüllt';

  @override
  String get moreColors => 'Weitere Farben';

  @override
  String currentColor(String code) {
    return 'Aktuelle Farbe, $code';
  }

  @override
  String colorSwatch(String code) {
    return 'Farbe $code';
  }

  @override
  String get colorCode => 'Farbcode';

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
    return 'Zeichenblatt, $width mal $height Pixel';
  }

  @override
  String get howToUseBody =>
      'Wähle links ein Werkzeug und unten eine Farbe und zeichne auf dem Blatt. Das Quadrat unten links öffnet weitere Farben, mit einem Feld für den Farbcode.\n\nBleistift, Pinsel und Radierer zeichnen, während du ziehst. Linie, Rechteck und Ellipse gehen von dort, wo du drückst, bis dort, wo du loslässt; mit gedrückter Umschalttaste entstehen rechte Winkel, Quadrate und Kreise. Der Farbeimer füllt eine Fläche, die Pipette nimmt eine Farbe aus der Zeichnung und der Stempel setzt einen der Nymphensittiche aus Psito Nest an die angeklickte Stelle.\n\nTasten: P Bleistift, B Pinsel, E Radierer, F Eimer, I Pipette, L Linie, R Rechteck, O Ellipse, S Stempel.\n\nStrg+Z macht rückgängig und Strg+Y wiederholt. Strg+N beginnt eine neue Zeichnung, Strg+O öffnet ein Bild und Strg+S speichert es als PNG. Strg mit dem Mausrad oder Strg+Plus und Strg+Minus zoomen; Strg+0 kehrt zur Originalgröße zurück.';

  @override
  String get aboutBody =>
      'Ein kleines Malprogramm mit Nymphensittichen. Ohne Werbung, ohne Telemetrie und ohne Konto.';

  @override
  String get aboutLegal =>
      'Code unter der Apache-2.0-Lizenz. Grafiken unter CC0.';

  @override
  String get bird1 => 'Ei';

  @override
  String get bird2 => 'Schlüpfendes Ei';

  @override
  String get bird3 => 'Neugeborenes';

  @override
  String get bird4 => 'Küken';

  @override
  String get bird5 => 'Jungvogel';

  @override
  String get bird6 => 'Grau';

  @override
  String get bird7 => 'Perl';

  @override
  String get bird8 => 'Zimt';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Schecke';

  @override
  String get bird11 => 'Goldene Königin';

  @override
  String closeTitle(String name) {
    return 'Änderungen an $name speichern?';
  }

  @override
  String get closeBody =>
      'Wenn du nicht speicherst, gehen die Änderungen verloren.';

  @override
  String get dontSave => 'Nicht speichern';

  @override
  String get toolSelect => 'Auswahl';

  @override
  String get copy => 'Kopieren';

  @override
  String get cut => 'Ausschneiden';

  @override
  String get paste => 'Einfügen';

  @override
  String get selectAll => 'Alles auswählen';

  @override
  String get nothingToPaste => 'Es gibt kein Bild zum Einfügen.';

  @override
  String get helpSelection =>
      'Die Auswahl (M) markiert ein Rechteck. Ziehe von innen, um den Inhalt zu verschieben; er bleibt lose, bis du außerhalb klickst, Esc drückst oder ein anderes Werkzeug wählst, und Strg+Z legt ihn zurück. Strg+C kopiert, Strg+X schneidet aus, Strg+V fügt ein hier oder in einem anderen Programm kopiertes Bild ein, Strg+A wählt alles aus und Entf löscht die Auswahl.';
}
