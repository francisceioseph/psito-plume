// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Psito Plume';

  @override
  String get untitled => 'Sem título';

  @override
  String get newImage => 'Novo desenho';

  @override
  String get open => 'Abrir';

  @override
  String get save => 'Salvar';

  @override
  String get saveAs => 'Salvar como';

  @override
  String get undo => 'Desfazer';

  @override
  String get redo => 'Refazer';

  @override
  String get zoomIn => 'Aproximar';

  @override
  String get zoomOut => 'Afastar';

  @override
  String get actualSize => 'Tamanho real';

  @override
  String get moreOptions => 'Mais opções';

  @override
  String get howToUse => 'Como usar';

  @override
  String get about => 'Sobre';

  @override
  String get close => 'Fechar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get create => 'Criar';

  @override
  String get choose => 'Escolher';

  @override
  String get discard => 'Descartar';

  @override
  String get width => 'Largura';

  @override
  String get height => 'Altura';

  @override
  String get images => 'Imagens';

  @override
  String get pngImage => 'Imagem PNG';

  @override
  String get discardTitle => 'Descartar o desenho?';

  @override
  String get discardBody => 'As mudanças que não foram salvas serão perdidas.';

  @override
  String saved(String name) {
    return 'Salvo como $name';
  }

  @override
  String openFailed(String name) {
    return 'Não foi possível abrir $name.';
  }

  @override
  String saveFailed(String name) {
    return 'Não foi possível salvar $name.';
  }

  @override
  String get toolPencil => 'Lápis';

  @override
  String get toolBrush => 'Pincel';

  @override
  String get toolEraser => 'Borracha';

  @override
  String get toolFill => 'Balde de tinta';

  @override
  String get toolPicker => 'Conta-gotas';

  @override
  String get toolLine => 'Linha';

  @override
  String get toolRectangle => 'Retângulo';

  @override
  String get toolEllipse => 'Elipse';

  @override
  String get toolStamp => 'Carimbo de calopsita';

  @override
  String sizeOption(int pixels) {
    return 'Tamanho $pixels px';
  }

  @override
  String get outline => 'Só o contorno';

  @override
  String get filled => 'Preenchido';

  @override
  String get moreColors => 'Mais cores';

  @override
  String colorSwatch(String code) {
    return 'Cor $code';
  }

  @override
  String get colorCode => 'Código da cor';

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
    return 'Folha de desenho, $width por $height pixels';
  }

  @override
  String get howToUseBody =>
      'Escolha uma ferramenta à esquerda e uma cor embaixo, e desenhe na folha. O quadrado no canto de baixo abre mais cores, com um campo para o código da cor.\n\nLápis, pincel e borracha desenham enquanto você arrasta. Linha, retângulo e elipse vão de onde você aperta até onde solta; com o Shift apertado saem ângulos retos, quadrados e círculos. O balde de tinta preenche uma área, o conta-gotas pega uma cor do desenho e o carimbo põe uma das calopsitas do Psito Nest onde você clicar.\n\nTeclas: P lápis, B pincel, E borracha, F balde, I conta-gotas, L linha, R retângulo, O elipse, S carimbo.\n\nCtrl+Z desfaz e Ctrl+Y refaz. Ctrl+N começa um desenho novo, Ctrl+O abre uma imagem e Ctrl+S salva em PNG. Ctrl com a roda do mouse, ou Ctrl+mais e Ctrl+menos, mudam o zoom; Ctrl+0 volta ao tamanho real.';

  @override
  String get aboutBody =>
      'Um pequeno programa de desenho com calopsitas. Sem anúncios, sem telemetria e sem conta.';

  @override
  String get aboutLegal => 'Código sob a licença Apache 2.0. Arte sob CC0.';

  @override
  String get bird1 => 'Ovo';

  @override
  String get bird2 => 'Ovo trincando';

  @override
  String get bird3 => 'Recém-nascido';

  @override
  String get bird4 => 'Filhote';

  @override
  String get bird5 => 'Jovem';

  @override
  String get bird6 => 'Cinza';

  @override
  String get bird7 => 'Pérola';

  @override
  String get bird8 => 'Canela';

  @override
  String get bird9 => 'Lutino';

  @override
  String get bird10 => 'Arlequim';

  @override
  String get bird11 => 'Rainha dourada';

  @override
  String closeTitle(String name) {
    return 'Salvar as mudanças em $name?';
  }

  @override
  String get closeBody => 'Se você não salvar, as mudanças serão perdidas.';

  @override
  String get dontSave => 'Não salvar';

  @override
  String get toolSelect => 'Seleção';

  @override
  String get copy => 'Copiar';

  @override
  String get cut => 'Recortar';

  @override
  String get paste => 'Colar';

  @override
  String get selectAll => 'Selecionar tudo';

  @override
  String get nothingToPaste => 'Não há imagem para colar.';

  @override
  String get helpSelection =>
      'A seleção (M) marca um retângulo. Arraste de dentro dele para mover o que ele tem; ele fica solto até você clicar fora, apertar Esc ou trocar de ferramenta, e o Ctrl+Z devolve tudo ao lugar. Ctrl+C copia, Ctrl+X recorta, Ctrl+V cola uma imagem copiada aqui ou em outro programa, Ctrl+A seleciona tudo e Delete apaga a seleção.';

  @override
  String get toolText => 'Texto';

  @override
  String get fontSans => 'Fonte sem serifa';

  @override
  String get fontSerif => 'Fonte com serifa';

  @override
  String get typeHere => 'Digite aqui';

  @override
  String get helpText =>
      'O texto (T) escreve onde você clicar, na cor e no tamanho escolhidos, com ou sem serifa. Enter põe o texto no desenho, Shift+Enter começa uma nova linha e Esc desiste; clicar em outro lugar também termina o texto.';

  @override
  String get imageMenu => 'Imagem';

  @override
  String get resize => 'Redimensionar';

  @override
  String get sheetSize => 'Tamanho da folha';

  @override
  String get rotateRight => 'Girar para a direita';

  @override
  String get rotateLeft => 'Girar para a esquerda';

  @override
  String get rotateHalf => 'Girar 180°';

  @override
  String get flipHorizontal => 'Espelhar na horizontal';

  @override
  String get flipVertical => 'Espelhar na vertical';

  @override
  String get crop => 'Recortar pela seleção';

  @override
  String get keepRatio => 'Manter a proporção';

  @override
  String get apply => 'Aplicar';

  @override
  String get helpImage =>
      'O menu Imagem, na barra, redimensiona, gira e espelha a seleção, ou o desenho inteiro quando nada está selecionado. Tamanho da folha acrescenta papel ou corta as bordas sem esticar, e Recortar deixa só o que está selecionado. Ctrl+W redimensiona, Ctrl+E muda a folha, Ctrl+R e Ctrl+Shift+R giram e Ctrl+Shift+X recorta.';

  @override
  String primaryColor(String code) {
    return 'Cor principal, botão esquerdo, $code';
  }

  @override
  String secondaryColor(String code) {
    return 'Cor secundária, botão direito, $code';
  }

  @override
  String get swapColors => 'Trocar as cores';

  @override
  String get helpColors =>
      'São duas cores: a principal, do botão esquerdo, e a secundária, que começa branca, do botão direito. Na paleta, o botão esquerdo escolhe a principal e o direito a secundária; o X troca as duas. A borracha com o botão direito apaga só a cor principal e deixa o resto.';

  @override
  String get dropHint => 'Solte a imagem para abri-la';

  @override
  String get helpOpen =>
      'As imagens também abrem arrastando-as para a janela, ou pelo Abrir com Psito Plume do gerenciador de arquivos.';
}
