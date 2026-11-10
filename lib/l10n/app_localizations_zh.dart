// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Psito Plume';

  @override
  String get untitled => '未命名';

  @override
  String get newImage => '新建画作';

  @override
  String get open => '打开';

  @override
  String get save => '保存';

  @override
  String get saveAs => '另存为';

  @override
  String get undo => '撤销';

  @override
  String get redo => '重做';

  @override
  String get zoomIn => '放大';

  @override
  String get zoomOut => '缩小';

  @override
  String get actualSize => '实际大小';

  @override
  String get moreOptions => '更多选项';

  @override
  String get howToUse => '使用方法';

  @override
  String get about => '关于';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get create => '创建';

  @override
  String get choose => '选择';

  @override
  String get discard => '放弃';

  @override
  String get width => '宽度';

  @override
  String get height => '高度';

  @override
  String get images => '图片';

  @override
  String get pngImage => 'PNG 图片';

  @override
  String get discardTitle => '放弃这幅画？';

  @override
  String get discardBody => '未保存的修改将会丢失。';

  @override
  String saved(String name) {
    return '已保存为 $name';
  }

  @override
  String openFailed(String name) {
    return '无法打开 $name。';
  }

  @override
  String saveFailed(String name) {
    return '无法保存 $name。';
  }

  @override
  String get toolPencil => '铅笔';

  @override
  String get toolBrush => '画笔';

  @override
  String get toolEraser => '橡皮';

  @override
  String get toolFill => '油漆桶';

  @override
  String get toolPicker => '取色器';

  @override
  String get toolLine => '直线';

  @override
  String get toolRectangle => '矩形';

  @override
  String get toolEllipse => '椭圆';

  @override
  String get toolStamp => '玄凤鹦鹉印章';

  @override
  String sizeOption(int pixels) {
    return '大小 $pixels px';
  }

  @override
  String get outline => '仅轮廓';

  @override
  String get filled => '填充';

  @override
  String get moreColors => '更多颜色';

  @override
  String colorSwatch(String code) {
    return '颜色 $code';
  }

  @override
  String get colorCode => '颜色代码';

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
    return '画纸，$width × $height 像素';
  }

  @override
  String get howToUseBody =>
      '在左边选一个工具，在下面选一种颜色，然后在画纸上作画。左下角的方块可以打开更多颜色，并能输入颜色代码。\n\n铅笔、画笔和橡皮在拖动时作画。直线、矩形和椭圆从按下的位置画到松开的位置；按住 Shift 可以画出直角、正方形和圆形。油漆桶填充一个区域，取色器从画中取色，印章会把 Psito Nest 里的一只玄凤鹦鹉放在你点击的地方。\n\n按键：P 铅笔，B 画笔，E 橡皮，F 油漆桶，I 取色器，L 直线，R 矩形，O 椭圆，S 印章。\n\nCtrl+Z 撤销，Ctrl+Y 重做。Ctrl+N 新建画作，Ctrl+O 打开图片，Ctrl+S 保存为 PNG。按住 Ctrl 滚动鼠标滚轮，或按 Ctrl+加号和 Ctrl+减号可以缩放；Ctrl+0 回到实际大小。';

  @override
  String get aboutBody => '一个带玄凤鹦鹉的小画图程序。没有广告、没有遥测，也不需要账号。';

  @override
  String get aboutLegal => '代码采用 Apache 2.0 许可证。美术作品采用 CC0。';

  @override
  String get bird1 => '蛋';

  @override
  String get bird2 => '正在孵化的蛋';

  @override
  String get bird3 => '刚出生的雏鸟';

  @override
  String get bird4 => '雏鸟';

  @override
  String get bird5 => '幼鸟';

  @override
  String get bird6 => '灰色';

  @override
  String get bird7 => '珍珠';

  @override
  String get bird8 => '肉桂';

  @override
  String get bird9 => '黄化';

  @override
  String get bird10 => '花斑';

  @override
  String get bird11 => '金色女王';

  @override
  String closeTitle(String name) {
    return '保存对 $name 的修改吗？';
  }

  @override
  String get closeBody => '如果不保存，修改将会丢失。';

  @override
  String get dontSave => '不保存';

  @override
  String get toolSelect => '选择';

  @override
  String get copy => '复制';

  @override
  String get cut => '剪切';

  @override
  String get paste => '粘贴';

  @override
  String get selectAll => '全选';

  @override
  String get nothingToPaste => '没有可以粘贴的图片。';

  @override
  String get helpSelection =>
      '选择工具（M）可以框出一个矩形。从框内拖动可以移动其中的内容；在你点击框外、按 Esc 或换用其他工具之前，它都可以自由移动，按 Ctrl+Z 会把它放回原处。Ctrl+C 复制，Ctrl+X 剪切，Ctrl+V 粘贴在这里或其他程序中复制的图片，Ctrl+A 全选，Delete 清除所选内容。';

  @override
  String get toolText => '文字';

  @override
  String get fontSans => '无衬线字体';

  @override
  String get fontSerif => '衬线字体';

  @override
  String get typeHere => '在此输入';

  @override
  String get helpText =>
      '文字工具（T）会在你点击的地方写字，使用选定的颜色和大小，可以选有衬线或无衬线字体。按 Enter 把文字放进画里，Shift+Enter 换行，Esc 放弃；在别处点击也会完成输入。';

  @override
  String get imageMenu => '图像';

  @override
  String get resize => '调整大小';

  @override
  String get sheetSize => '画纸大小';

  @override
  String get rotateRight => '向右旋转';

  @override
  String get rotateLeft => '向左旋转';

  @override
  String get rotateHalf => '旋转 180°';

  @override
  String get flipHorizontal => '水平翻转';

  @override
  String get flipVertical => '垂直翻转';

  @override
  String get crop => '裁剪到选区';

  @override
  String get keepRatio => '保持比例';

  @override
  String get apply => '应用';

  @override
  String get helpImage =>
      '工具栏上的“图像”菜单可以调整选区的大小、旋转和翻转选区；没有选区时作用于整幅画。“画纸大小”会添加纸张或裁掉边缘而不拉伸，“裁剪”只保留选中的部分。Ctrl+W 调整大小，Ctrl+E 修改画纸，Ctrl+R 和 Ctrl+Shift+R 旋转，Ctrl+Shift+X 裁剪。';

  @override
  String primaryColor(String code) {
    return '主颜色，左键，$code';
  }

  @override
  String secondaryColor(String code) {
    return '次颜色，右键，$code';
  }

  @override
  String get swapColors => '交换颜色';

  @override
  String get helpColors =>
      '有两种颜色：主颜色用于左键，次颜色（初始为白色）用于右键。在调色板上，左键选择主颜色，右键选择次颜色；按 X 交换两者。用右键使用橡皮时，只擦除主颜色，其余部分保留。';
}
