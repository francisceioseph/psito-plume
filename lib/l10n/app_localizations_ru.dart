// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Psito Plume';

  @override
  String get untitled => 'Без названия';

  @override
  String get newImage => 'Новый рисунок';

  @override
  String get open => 'Открыть';

  @override
  String get save => 'Сохранить';

  @override
  String get saveAs => 'Сохранить как';

  @override
  String get undo => 'Отменить';

  @override
  String get redo => 'Повторить';

  @override
  String get zoomIn => 'Увеличить';

  @override
  String get zoomOut => 'Уменьшить';

  @override
  String get actualSize => 'Реальный размер';

  @override
  String get moreOptions => 'Ещё';

  @override
  String get howToUse => 'Как пользоваться';

  @override
  String get about => 'О программе';

  @override
  String get close => 'Закрыть';

  @override
  String get cancel => 'Отмена';

  @override
  String get create => 'Создать';

  @override
  String get choose => 'Выбрать';

  @override
  String get discard => 'Не сохранять';

  @override
  String get width => 'Ширина';

  @override
  String get height => 'Высота';

  @override
  String get images => 'Изображения';

  @override
  String get pngImage => 'Изображение PNG';

  @override
  String get discardTitle => 'Отказаться от рисунка?';

  @override
  String get discardBody => 'Несохранённые изменения будут потеряны.';

  @override
  String saved(String name) {
    return 'Сохранено как $name';
  }

  @override
  String openFailed(String name) {
    return 'Не удалось открыть $name.';
  }

  @override
  String saveFailed(String name) {
    return 'Не удалось сохранить $name.';
  }

  @override
  String get toolPencil => 'Карандаш';

  @override
  String get toolBrush => 'Кисть';

  @override
  String get toolEraser => 'Ластик';

  @override
  String get toolFill => 'Заливка';

  @override
  String get toolPicker => 'Пипетка';

  @override
  String get toolLine => 'Линия';

  @override
  String get toolRectangle => 'Прямоугольник';

  @override
  String get toolEllipse => 'Эллипс';

  @override
  String get toolStamp => 'Штамп с кореллой';

  @override
  String sizeOption(int pixels) {
    return 'Размер $pixels px';
  }

  @override
  String get outline => 'Только контур';

  @override
  String get filled => 'С заливкой';

  @override
  String get moreColors => 'Другие цвета';

  @override
  String colorSwatch(String code) {
    return 'Цвет $code';
  }

  @override
  String get colorCode => 'Код цвета';

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
    return 'Лист для рисования, $width на $height пикселей';
  }

  @override
  String get howToUseBody =>
      'Выберите инструмент слева и цвет внизу и рисуйте на листе. Квадрат внизу слева открывает другие цвета, с полем для кода цвета.\n\nКарандаш, кисть и ластик рисуют, пока вы ведёте мышь. Линия, прямоугольник и эллипс идут от места нажатия до места, где вы отпустили кнопку; с Shift получаются прямые углы, квадраты и круги. Заливка закрашивает область, пипетка берёт цвет из рисунка, а штамп ставит одного из корелл Psito Nest туда, где вы щёлкнули.\n\nКлавиши: P карандаш, B кисть, E ластик, F заливка, I пипетка, L линия, R прямоугольник, O эллипс, S штамп.\n\nCtrl+Z отменяет, Ctrl+Y повторяет. Ctrl+N начинает новый рисунок, Ctrl+O открывает изображение, Ctrl+S сохраняет его в PNG. Ctrl с колёсиком мыши или Ctrl+плюс и Ctrl+минус меняют масштаб; Ctrl+0 возвращает реальный размер.';

  @override
  String get aboutBody =>
      'Маленькая программа для рисования с кореллами. Без рекламы, без телеметрии и без учётной записи.';

  @override
  String get aboutLegal => 'Код под лицензией Apache 2.0. Рисунки под CC0.';

  @override
  String get bird1 => 'Яйцо';

  @override
  String get bird2 => 'Яйцо проклёвывается';

  @override
  String get bird3 => 'Новорождённый';

  @override
  String get bird4 => 'Птенец';

  @override
  String get bird5 => 'Подросток';

  @override
  String get bird6 => 'Серый';

  @override
  String get bird7 => 'Жемчужный';

  @override
  String get bird8 => 'Коричный';

  @override
  String get bird9 => 'Лютино';

  @override
  String get bird10 => 'Пегий';

  @override
  String get bird11 => 'Золотая королева';

  @override
  String closeTitle(String name) {
    return 'Сохранить изменения в $name?';
  }

  @override
  String get closeBody => 'Если не сохранить, изменения будут потеряны.';

  @override
  String get dontSave => 'Не сохранять';

  @override
  String get toolSelect => 'Выделение';

  @override
  String get copy => 'Копировать';

  @override
  String get cut => 'Вырезать';

  @override
  String get paste => 'Вставить';

  @override
  String get selectAll => 'Выделить всё';

  @override
  String get nothingToPaste => 'Нет изображения для вставки.';

  @override
  String get helpSelection =>
      'Выделение (M) отмечает прямоугольник. Потяните изнутри, чтобы переместить его содержимое; оно остаётся свободным, пока вы не щёлкнете снаружи, не нажмёте Esc или не выберете другой инструмент, а Ctrl+Z вернёт всё на место. Ctrl+C копирует, Ctrl+X вырезает, Ctrl+V вставляет изображение, скопированное здесь или в другой программе, Ctrl+A выделяет всё, а Delete стирает выделенное.';

  @override
  String get toolText => 'Текст';

  @override
  String get fontSans => 'Шрифт без засечек';

  @override
  String get fontSerif => 'Шрифт с засечками';

  @override
  String get typeHere => 'Введите текст';

  @override
  String get helpText =>
      'Текст (T) пишет там, где вы щёлкнули, выбранным цветом и размером, с засечками или без. Enter переносит текст в рисунок, Shift+Enter начинает новую строку, а Esc отменяет; щелчок в другом месте тоже завершает текст.';

  @override
  String get imageMenu => 'Изображение';

  @override
  String get resize => 'Изменить размер';

  @override
  String get sheetSize => 'Размер листа';

  @override
  String get rotateRight => 'Повернуть вправо';

  @override
  String get rotateLeft => 'Повернуть влево';

  @override
  String get rotateHalf => 'Повернуть на 180°';

  @override
  String get flipHorizontal => 'Отразить по горизонтали';

  @override
  String get flipVertical => 'Отразить по вертикали';

  @override
  String get crop => 'Обрезать по выделению';

  @override
  String get keepRatio => 'Сохранять пропорции';

  @override
  String get apply => 'Применить';

  @override
  String get helpImage =>
      'Меню «Изображение» на панели меняет размер, поворачивает и отражает выделение или весь рисунок, если ничего не выделено. «Размер листа» добавляет бумагу или обрезает края без растягивания, а «Обрезать» оставляет только выделенное. Ctrl+W меняет размер, Ctrl+E меняет лист, Ctrl+R и Ctrl+Shift+R поворачивают, а Ctrl+Shift+X обрезает.';

  @override
  String primaryColor(String code) {
    return 'Основной цвет, левая кнопка, $code';
  }

  @override
  String secondaryColor(String code) {
    return 'Дополнительный цвет, правая кнопка, $code';
  }

  @override
  String get swapColors => 'Поменять цвета местами';

  @override
  String get helpColors =>
      'Цветов два: основной для левой кнопки и дополнительный, сначала белый, для правой. На палитре левая кнопка выбирает основной цвет, а правая — дополнительный; X меняет их местами. Ластик с правой кнопкой стирает только основной цвет и оставляет остальное.';

  @override
  String get dropHint => 'Отпустите изображение, чтобы открыть его';

  @override
  String get helpOpen =>
      'Изображения также открываются, если перетащить их в окно или выбрать «Открыть с помощью Psito Plume» в файловом менеджере.';

  @override
  String get toolSpray => 'Распылитель';

  @override
  String get toolCurve => 'Кривая';

  @override
  String get toolArrow => 'Стрелка';

  @override
  String get toolRoundedRectangle => 'Скруглённый прямоугольник';

  @override
  String get toolPolygon => 'Многоугольник';

  @override
  String get helpShapes =>
      'Другие фигуры: кривая (C) рисуется как линия и изгибается вторым перетаскиванием; многоугольник (G) получает угол с каждым щелчком и замыкается на первом угле, повторным щелчком на последнем или клавишей Enter; Esc отменяет любую из них. Есть также стрелка (W), скруглённый прямоугольник (U) и распылитель (A).';
}
