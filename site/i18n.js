// A página está em inglês no HTML, e sem JavaScript fica assim. O português mora aqui:
// cada [data-t] recebe o texto da chave, e [data-t-alt] o da descrição da imagem.
const LATEST = 'https://github.com/francisceioseph/psito-plume/releases/latest';
const SOURCE = 'https://github.com/francisceioseph/psito-plume#install';

const STRINGS = {
  en: { copied: 'Copied' },
  pt: {
    heroTitle: 'Um paint pequeno, com calopsitas.',
    heroLead: 'Um pequeno programa de desenho para Windows e Linux, com carimbos de calopsita. Sem anúncios, sem telemetria e sem conta: só desenho e felicidade.',
    install: 'Instalar',
    sourceCode: 'Código-fonte',
    lookInside: 'Por dentro',
    shotTable: 'Um desenho na folha, com as ferramentas à esquerda e a paleta embaixo',
    shotNote: 'O programa segue o idioma do sistema, em português ou inglês.',
    whatItDoes: 'O que ele faz',
    feature1: 'Lápis, pincel, borracha, balde de tinta, conta-gotas, linha, retângulo e elipse',
    feature2: 'Carimbos com as onze calopsitas do Psito Nest',
    feature3: 'Uma paleta de vinte cores, e qualquer outra pelo código',
    feature4: 'Desfazer e refazer à vontade, e zoom até 800%',
    feature5: 'Uma calopsita curiosa que espia a folha quando você para para pensar',
    feature6: 'Funciona sem internet. Não envia nada para lugar nenhum',
    windowsIntro: 'No Windows 10 (1809 ou mais novo) ou no Windows 11, em x64. Não pede administrador.',
    windowsDownload: 'Baixar o instalador',
    windowsNote: 'O SmartScreen pode avisar que o editor é desconhecido, porque o instalador não tem um certificado pago. Escolha Mais informações e depois Executar assim mesmo.',
    debIntro: 'No Debian 13, Ubuntu 24.04, Mint 22 ou mais novos, em amd64. Ele atualiza junto com o sistema.',
    fedoraIntro: 'Em x86_64. Ele atualiza junto com o sistema. A primeira instalação pede para aceitar a chave de assinatura.',
    removeIntro: 'Para remover o programa e o repositório',
    copy: 'Copiar',
    copied: 'Copiado',
    otherNote: `Outro sistema? Você pode <a href="${LATEST}">baixar o pacote</a> ou <a href="${SOURCE}">compilar do código-fonte</a>.`,
    links: 'Links',
    issues: 'Issues',
    issuesNote: 'Relatar um problema',
    releases: 'Versões',
    releasesNote: 'O que mudou em cada versão',
    githubNote: 'O código-fonte',
    footer: 'Código sob a licença Apache 2.0, arte sob CC0. Desenvolvido com o auxílio do Claude Code. Calopsitas ilustradas com o Google Gemini.',
  },
};

const KEY = 'psito-plume-lang';
const texts = new Map();
const alts = new Map();
for (const el of document.querySelectorAll('[data-t]')) texts.set(el, el.innerHTML);
for (const el of document.querySelectorAll('[data-t-alt]')) alts.set(el, el.alt);

function saved() {
  try { return localStorage.getItem(KEY); } catch { return null; }
}

function setLang(lang, remember) {
  const strings = STRINGS[lang];
  document.documentElement.lang = lang;
  document.getElementById('lang').value = lang;
  for (const [el, english] of texts) el.innerHTML = strings[el.dataset.t] ?? english;
  for (const [el, english] of alts) el.alt = strings[el.dataset.tAlt] ?? english;
  if (remember) {
    try { localStorage.setItem(KEY, lang); } catch {}
  }
}

const system = navigator.language.slice(0, 2).toLowerCase();
const start = saved() ?? system;
setLang(start in STRINGS ? start : 'en', false);
document.getElementById('lang').addEventListener('change', (event) => setLang(event.target.value, true));

for (const button of document.querySelectorAll('[data-copy]')) {
  button.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(document.getElementById(button.dataset.copy).textContent);
      button.textContent = STRINGS[document.documentElement.lang].copied;
      setTimeout(() => {
        const strings = STRINGS[document.documentElement.lang];
        button.innerHTML = strings.copy ?? texts.get(button);
      }, 1500);
    } catch {
      // Sem acesso à área de transferência, o texto continua selecionável
    }
  });
}
