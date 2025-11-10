import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import xml2js from 'xml2js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const SRC_DIR = path.resolve('C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event');
const OUT_DIR = path.resolve('C:/source/repos/Tc3_Event/docs');

const parser = new xml2js.Parser();

/**
 * Recursively get all XML/POU/DUT files
 */
async function getAllFiles(dir, exts = ['.TcPOU', '.TcDUT', '.TcPOU.xml', '.TcDUT.xml']) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  const files = [];
  for (const e of entries) {
    const res = path.join(dir, e.name);
    if (e.isDirectory()) {
      files.push(...await getAllFiles(res, exts));
    } else if (exts.some(ext => e.name.endsWith(ext))) {
      files.push(res);
    }
  }
  return files;
}

/**
 * Parse XML content and return object
 */
async function parseXmlFile(file) {
  const data = await fs.readFile(file, 'utf8');
  return parser.parseStringPromise(data);
}

/**
 * Extract FB/FUNCTION/INTERFACE info from parsed XML
 */
function extractPouInfo(xmlObj) {
  const pou = xmlObj.TcPlcObject?.POU?.[0];
  if (!pou) return null;

  const name = pou.$.Name;
  const methods = (pou.Method || []).map(m => m.$.Name);
  const implementsIntf = pou.$.Implements || (pou.$.SpecialFunc || null);

  return {
    name,
    type: name.startsWith('FB_') ? 'Function Block' : name.startsWith('F_') ? 'Function' : 'Unknown',
    implements: implementsIntf,
    methods
  };
}

/**
 * Write individual Markdown file
 */
async function writeMd(info) {
  const mdDir = path.join(OUT_DIR, info.type.replace(' ', '_'));
  await fs.mkdir(mdDir, { recursive: true });
  const mdFile = path.join(mdDir, `${info.name}.md`);

  const code = `\`\`\`iecst
FUNCTION_BLOCK ${info.name}${info.implements ? ' IMPLEMENTS ' + info.implements : ''}
\`\`\``;

  const md = [`# ${info.name}`, '', code, ''].join('\n');
  await fs.writeFile(mdFile, md, 'utf8');
  return mdFile;
}

/**
 * Build README index
 */
async function buildIndex(mdFiles) {
  const sections = {};

  for (const f of mdFiles) {
    const type = path.basename(path.dirname(f));
    if (!sections[type]) sections[type] = [];
    const name = path.basename(f, '.md');
    const rel = path.relative(OUT_DIR, f).replace(/\\/g, '/').split(' ').join('%20');
    sections[type].push(`- [${name}](${rel})`);
  }

  const md = ['# Overview', ''].concat(Object.keys(sections).sort().map(type => {
    return [`## ${type.replace('_',' ')}`, sections[type].sort().join('\n') || '_none_', ''].join('\n');
  })).join('\n');

  await fs.writeFile(path.join(OUT_DIR, 'README.md'), md, 'utf8');
}

/**
 * Main
 */
async function main() {
  const files = await getAllFiles(SRC_DIR);
  const mdFiles = [];

  for (const file of files) {
    try {
      const xmlObj = await parseXmlFile(file);
      const info = extractPouInfo(xmlObj);
      if (!info) continue;
      const mdFile = await writeMd(info);
      mdFiles.push(mdFile);
    } catch (err) {
      console.warn('Failed parsing', file, err.message);
    }
  }

  await buildIndex(mdFiles);
  console.log('✅ Documentation generated in', OUT_DIR);
}

main().catch(console.error);
