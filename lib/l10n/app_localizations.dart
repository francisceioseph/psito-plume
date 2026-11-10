import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Psito Plume'**
  String get appTitle;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @newImage.
  ///
  /// In en, this message translates to:
  /// **'New drawing'**
  String get newImage;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveAs.
  ///
  /// In en, this message translates to:
  /// **'Save as'**
  String get saveAs;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @zoomIn.
  ///
  /// In en, this message translates to:
  /// **'Zoom in'**
  String get zoomIn;

  /// No description provided for @zoomOut.
  ///
  /// In en, this message translates to:
  /// **'Zoom out'**
  String get zoomOut;

  /// No description provided for @actualSize.
  ///
  /// In en, this message translates to:
  /// **'Actual size'**
  String get actualSize;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @howToUse.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get howToUse;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @width.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get width;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @pngImage.
  ///
  /// In en, this message translates to:
  /// **'PNG image'**
  String get pngImage;

  /// No description provided for @discardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard the drawing?'**
  String get discardTitle;

  /// No description provided for @discardBody.
  ///
  /// In en, this message translates to:
  /// **'The changes that were not saved will be lost.'**
  String get discardBody;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved as {name}'**
  String saved(String name);

  /// No description provided for @openFailed.
  ///
  /// In en, this message translates to:
  /// **'{name} could not be opened.'**
  String openFailed(String name);

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'{name} could not be saved.'**
  String saveFailed(String name);

  /// No description provided for @toolPencil.
  ///
  /// In en, this message translates to:
  /// **'Pencil'**
  String get toolPencil;

  /// No description provided for @toolBrush.
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get toolBrush;

  /// No description provided for @toolEraser.
  ///
  /// In en, this message translates to:
  /// **'Eraser'**
  String get toolEraser;

  /// No description provided for @toolFill.
  ///
  /// In en, this message translates to:
  /// **'Paint bucket'**
  String get toolFill;

  /// No description provided for @toolPicker.
  ///
  /// In en, this message translates to:
  /// **'Colour picker'**
  String get toolPicker;

  /// No description provided for @toolLine.
  ///
  /// In en, this message translates to:
  /// **'Line'**
  String get toolLine;

  /// No description provided for @toolRectangle.
  ///
  /// In en, this message translates to:
  /// **'Rectangle'**
  String get toolRectangle;

  /// No description provided for @toolEllipse.
  ///
  /// In en, this message translates to:
  /// **'Ellipse'**
  String get toolEllipse;

  /// No description provided for @toolStamp.
  ///
  /// In en, this message translates to:
  /// **'Cockatiel stamp'**
  String get toolStamp;

  /// No description provided for @sizeOption.
  ///
  /// In en, this message translates to:
  /// **'Size {pixels} px'**
  String sizeOption(int pixels);

  /// No description provided for @outline.
  ///
  /// In en, this message translates to:
  /// **'Outline only'**
  String get outline;

  /// No description provided for @filled.
  ///
  /// In en, this message translates to:
  /// **'Filled'**
  String get filled;

  /// No description provided for @moreColors.
  ///
  /// In en, this message translates to:
  /// **'More colours'**
  String get moreColors;

  /// No description provided for @currentColor.
  ///
  /// In en, this message translates to:
  /// **'Colour in use, {code}'**
  String currentColor(String code);

  /// No description provided for @colorSwatch.
  ///
  /// In en, this message translates to:
  /// **'Colour {code}'**
  String colorSwatch(String code);

  /// No description provided for @colorCode.
  ///
  /// In en, this message translates to:
  /// **'Colour code'**
  String get colorCode;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'{x}, {y} px'**
  String position(int x, int y);

  /// No description provided for @imageSize.
  ///
  /// In en, this message translates to:
  /// **'{width} × {height} px'**
  String imageSize(int width, int height);

  /// No description provided for @canvasLabel.
  ///
  /// In en, this message translates to:
  /// **'Drawing sheet, {width} by {height} pixels'**
  String canvasLabel(int width, int height);

  /// No description provided for @howToUseBody.
  ///
  /// In en, this message translates to:
  /// **'Pick a tool on the left and a colour at the bottom, then draw on the sheet. The square on the bottom left opens more colours, with a field for a colour code.\n\nPencil, brush and eraser draw while you drag. Line, rectangle and ellipse are drawn from where you press to where you let go; holding Shift makes straight angles, squares and circles. The paint bucket fills an area, the colour picker takes a colour from the drawing, and the stamp puts one of the Psito Nest cockatiels where you click.\n\nKeys: P pencil, B brush, E eraser, F bucket, I picker, L line, R rectangle, O ellipse, S stamp.\n\nCtrl+Z undoes and Ctrl+Y redoes. Ctrl+N starts a new drawing, Ctrl+O opens a picture and Ctrl+S saves it as PNG. Ctrl and the mouse wheel, or Ctrl+plus and Ctrl+minus, zoom; Ctrl+0 goes back to the actual size.'**
  String get howToUseBody;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'A little paint program with cockatiels. No ads, no telemetry and no account.'**
  String get aboutBody;

  /// No description provided for @aboutLegal.
  ///
  /// In en, this message translates to:
  /// **'Code under the Apache 2.0 license. Art under CC0.'**
  String get aboutLegal;

  /// No description provided for @bird1.
  ///
  /// In en, this message translates to:
  /// **'Egg'**
  String get bird1;

  /// No description provided for @bird2.
  ///
  /// In en, this message translates to:
  /// **'Hatching egg'**
  String get bird2;

  /// No description provided for @bird3.
  ///
  /// In en, this message translates to:
  /// **'Newborn'**
  String get bird3;

  /// No description provided for @bird4.
  ///
  /// In en, this message translates to:
  /// **'Chick'**
  String get bird4;

  /// No description provided for @bird5.
  ///
  /// In en, this message translates to:
  /// **'Fledgling'**
  String get bird5;

  /// No description provided for @bird6.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get bird6;

  /// No description provided for @bird7.
  ///
  /// In en, this message translates to:
  /// **'Pearl'**
  String get bird7;

  /// No description provided for @bird8.
  ///
  /// In en, this message translates to:
  /// **'Cinnamon'**
  String get bird8;

  /// No description provided for @bird9.
  ///
  /// In en, this message translates to:
  /// **'Lutino'**
  String get bird9;

  /// No description provided for @bird10.
  ///
  /// In en, this message translates to:
  /// **'Pied'**
  String get bird10;

  /// No description provided for @bird11.
  ///
  /// In en, this message translates to:
  /// **'Golden queen'**
  String get bird11;

  /// No description provided for @closeTitle.
  ///
  /// In en, this message translates to:
  /// **'Save the changes to {name}?'**
  String closeTitle(String name);

  /// No description provided for @closeBody.
  ///
  /// In en, this message translates to:
  /// **'If you do not save, the changes will be lost.'**
  String get closeBody;

  /// No description provided for @dontSave.
  ///
  /// In en, this message translates to:
  /// **'Don\'t save'**
  String get dontSave;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
