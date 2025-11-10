// autodoc.js
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

/* CONFIGURE THESE PATHS */
const SRC_DIR = path.resolve('C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event'); // source root
const OUT_DIR = path.resolve('C:/source/repos/Tc3_Event/docs'); // markdown root
const INDEX_FILE = path.join(OUT_DIR, 'README.md');

/* UTILITIES */
async function getAllFiles(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  const files = await Promise.all(
    entries.map(entry => {
      const res = path.resolve(dir, entry.name);
      return entry.isDirectory() ? getAllFiles(res) : res;
    })
  );
  return Array.prototype.concat(...files);
}

function classifyFile(filename) {
  const base = path.basename(filename, path.extname(filename));
  if (base.startsWith('FB_')) return 'Function Blocks';
  if (base.startsWith('F_')) return 'Functions';
  if (base.startsWith('I_')) return 'Interfaces';
  if (base.startsWith('E_') || base.startsWith('ST_') || base.startsWith('TYPE_')) return 'Datatypes';
  return null;
}

function toMarkdownLink(baseDir, filePath) {
  const relPath = path.relative(baseDir, filePath).replace(/\\/g, '/');
  const name = path.basename(filePath, path.extname(filePath));
  const safeRelPath = relPath.split(' ').join('%20');
  return `- [${name}](${safeRelPath})`;
}

/* MAIN BUILD FUNCTION */
async function buildIndex() {
  const files = (await getAllFiles(OUT_DIR))
    .filter(f => f.endsWith('.md') && !f.endsWith('README.md'));

  const sections = {
    'Functions': [],
    'Function Blocks': [],
    'Interfaces': [],
    'Datatypes': []
  };

  for (const file of files) {
    const category = classifyFile(file);
    if (category) sections[category].push(toMarkdownLink(OUT_DIR, file));
  }

  const md = [
    '# Overview',
    '',
    '## Functions',
    sections['Functions'].sort().join('\n') || '_none_',
    '',
    '## Function Blocks',
    sections['Function Blocks'].sort().join('\n') || '_none_',
    '',
    '## Interfaces',
    sections['Interfaces'].sort().join('\n') || '_none_',
    '',
    '## Datatypes',
    sections['Datatypes'].sort().join('\n') || '_none_',
    ''
  ].join('\n');

  await fs.mkdir(OUT_DIR, { recursive: true });
  await fs.writeFile(INDEX_FILE, md, 'utf8');
  console.log(`✅ Documentation index generated: ${INDEX_FILE}`);
}

buildIndex().catch(err => {
  console.error('❌ Error:', err);
  process.exit(1);
});
