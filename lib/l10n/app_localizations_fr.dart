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

  @override
  String closeTitle(String name) {
    return 'Enregistrer les modifications de $name ?';
  }

  @override
  String get closeBody =>
      'Si vous n’enregistrez pas, les modifications seront perdues.';

  @override
  String get dontSave => 'Ne pas enregistrer';

  @override
  String get toolSelect => 'Sélection';

  @override
  String get copy => 'Copier';

  @override
  String get cut => 'Couper';

  @override
  String get paste => 'Coller';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get nothingToPaste => 'Il n’y a pas d’image à coller.';

  @override
  String get helpSelection =>
      'La sélection (M) trace un rectangle. Glissez depuis l’intérieur pour déplacer son contenu ; il reste libre jusqu’à ce que vous cliquiez à l’extérieur, appuyiez sur Échap ou changiez d’outil, et Ctrl+Z le remet en place. Ctrl+C copie, Ctrl+X coupe, Ctrl+V colle une image copiée ici ou dans un autre programme, Ctrl+A sélectionne tout et Suppr efface la sélection.';

  @override
  String get toolText => 'Texte';

  @override
  String get fontSans => 'Police sans empattement';

  @override
  String get fontSerif => 'Police à empattement';

  @override
  String get typeHere => 'Tapez ici';

  @override
  String get helpText =>
      'Le texte (T) écrit là où vous cliquez, dans la couleur et la taille choisies, avec ou sans empattements. Entrée place le texte dans le dessin, Maj+Entrée commence une nouvelle ligne et Échap l’abandonne ; cliquer ailleurs le termine aussi.';
}
