// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Psito Plume';

  @override
  String get untitled => 'Sans titre';

  @override
  String get newImage => 'Nouveau dessin';

  @override
  String get open => 'Ouvrir';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveAs => 'Enregistrer sous';

  @override
  String get undo => 'Annuler';

  @override
  String get redo => 'Rétablir';

  @override
  String get zoomIn => 'Zoom avant';

  @override
  String get zoomOut => 'Zoom arrière';

  @override
  String get actualSize => 'Taille réelle';

  @override
  String get moreOptions => 'Plus d’options';

  @override
  String get howToUse => 'Mode d’emploi';

  @override
  String get about => 'À propos';

  @override
  String get close => 'Fermer';

  @override
  String get cancel => 'Annuler';

  @override
  String get create => 'Créer';

  @override
  String get choose => 'Choisir';

  @override
  String get discard => 'Abandonner';

  @override
  String get width => 'Largeur';

  @override
  String get height => 'Hauteur';

  @override
  String get images => 'Images';

  @override
  String get pngImage => 'Image PNG';

  @override
  String get discardTitle => 'Abandonner le dessin ?';

  @override
  String get discardBody =>
      'Les modifications non enregistrées seront perdues.';

  @override
  String saved(String name) {
    return 'Enregistré sous $name';
  }

  @override
  String openFailed(String name) {
    return 'Impossible d’ouvrir $name.';
  }

  @override
  String saveFailed(String name) {
    return 'Impossible d’enregistrer $name.';
  }

  @override
  String get toolPencil => 'Crayon';

  @override
  String get toolBrush => 'Pinceau';

  @override
  String get toolEraser => 'Gomme';

  @override
  String get toolFill => 'Pot de peinture';

  @override
  String get toolPicker => 'Pipette';

  @override
  String get toolLine => 'Ligne';

  @override
  String get toolRectangle => 'Rectangle';

  @override
  String get toolEllipse => 'Ellipse';

  @override
  String get toolStamp => 'Tampon calopsitte';

  @override
  String sizeOption(int pixels) {
    return 'Taille $pixels px';
  }

  @override
  String get outline => 'Contour seulement';

  @override
  String get filled => 'Rempli';

  @override
  String get moreColors => 'Plus de couleurs';

  @override
  String currentColor(String code) {
    return 'Couleur utilisée, $code';
  }

  @override
  String colorSwatch(String code) {
    return 'Couleur $code';
  }

  @override
  String get colorCode => 'Code de la couleur';

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
    return 'Feuille de dessin, $width sur $height pixels';
  }

  @override
  String get howToUseBody =>
      'Choisissez un outil à gauche et une couleur en bas, puis dessinez sur la feuille. Le carré en bas à gauche ouvre plus de couleurs, avec un champ pour le code de la couleur.\n\nLe crayon, le pinceau et la gomme dessinent pendant que vous glissez. La ligne, le rectangle et l’ellipse vont de l’endroit où vous appuyez à celui où vous relâchez ; avec Maj, on obtient des angles droits, des carrés et des cercles. Le pot de peinture remplit une zone, la pipette prend une couleur du dessin et le tampon pose l’une des calopsittes de Psito Nest là où vous cliquez.\n\nTouches : P crayon, B pinceau, E gomme, F pot, I pipette, L ligne, R rectangle, O ellipse, S tampon.\n\nCtrl+Z annule et Ctrl+Y rétablit. Ctrl+N commence un nouveau dessin, Ctrl+O ouvre une image et Ctrl+S l’enregistre en PNG. Ctrl et la molette, ou Ctrl+plus et Ctrl+moins, changent le zoom ; Ctrl+0 revient à la taille réelle.';

  @override
  String get aboutBody =>
      'Un petit programme de dessin avec des calopsittes. Sans publicité, sans télémétrie et sans compte.';

  @override
  String get aboutLegal =>
      'Code sous licence Apache 2.0. Illustrations sous CC0.';

  @override
  String get bird1 => 'Œuf';

  @override
  String get bird2 => 'Œuf qui éclot';

  @override
  String get bird3 => 'Nouveau-né';

  @override
  String get bird4 => 'Poussin';

  @override
  String get bird5 => 'Jeune';

  @override
  String get bird6 => 'Gris';

  @override
  String get bird7 => 'Perle';

  @override
  String get bird8 => 'Cannelle';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Panaché';

  @override
  String get bird11 => 'Reine dorée';
}
