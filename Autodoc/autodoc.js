import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import xml2js from 'xml2js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const SRC_DIR = path.resolve('C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event'); // adjust if needed
const OUT_DIR = path.resolve('C:/source/repos/Tc3_Event/docs');

const parser = new xml2js.Parser();

/**
 * Recursively get all XML/POU/DUT files
 */
async function getAllFiles(dir, exts = ['.TcPOU', '.TcDUT', '.TcIO']) {
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
 * Parse XML content
 */
async function parseXmlFile(file) {
  const data = await fs.readFile(file, 'utf8');
  return parser.parseStringPromise(data);
}

/**
 * Extract main content from POU XML
 */
function extractPouContent(xmlObj) {
  const pou = xmlObj.TcPlcObject?.POU?.[0];
  if (!pou) return null;

  // Full declaration
  const decl = pou.Declaration?.[0]?._;
  // Full implementation (ST code)
  const impl = pou.Implementation?.[0]?.ST?.[0]?._ || '';

  // Methods
  const methods = (pou.Method || []).map(m => {
    const name = m.$.Name;
    const declCode = m.Declaration?.[0]?._ || '';
    const implCode = m.Implementation?.[0]?.ST?.[0]?._ || '';
    return { name, declCode, implCode };
  });

  // Properties
  const props = (pou.Property || []).map(p => {
    const name = p.$.Name;
    const declCode = p.Declaration?.[0]?._ || '';
    const getCode = p.Get?.[0]?.Implementation?.[0]?.ST?.[0]?._ || '';
    const setCode = p.Set?.[0]?.Implementation?.[0]?.ST?.[0]?._ || '';
    return { name, declCode, getCode, setCode };
  });

  // Determine type
  let type = 'Unknown';
  if (decl?.includes('FUNCTION_BLOCK')) type = 'Function Block';
  else if (decl?.includes('FUNCTION')) type = 'Function';

  return {
    name: pou.$.Name,
    type,
    declaration: decl,
    implementation: impl,
    methods,
    properties: props
  };
}

/**
 * Generate Markdown file
 */
async function writeMd(info) {
  const mdDir = path.join(OUT_DIR, info.type.replace(' ', '_'));
  await fs.mkdir(mdDir, { recursive: true });

  const mdFile = path.join(mdDir, `${info.name}.md`);
  const lines = [`# ${info.name}`, '', '```iecst', info.declaration || '', info.implementation || '', '```', ''];

  // Methods
  for (const m of info.methods) {
    lines.push(`## Method ${m.name}`, '', '```iecst', m.declCode, m.implCode, '```', '');
  }

  // Properties
  for (const p of info.properties) {
    lines.push(`## Property ${p.name}`, '', '```iecst', p.declCode, p.getCode, p.setCode, '```', '');
  }

  await fs.writeFile(mdFile, lines.join('\n'), 'utf8');
  return mdFile;
}

/**
 * Build index README.md
 */
async function buildIndex(mdFiles) {
  const sections = {};

  for (const f of mdFiles) {
    const type = path.basename(path.dirname(f));
    if (!sections[type]) sections[type] = [];
    const name = path.basename(f, '.md');
    const rel = path.relative(OUT_DIR, f).replace(/\\/g, '/').split(' ').join('%20'); // escape spaces
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
      const info = extractPouContent(xmlObj);
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
