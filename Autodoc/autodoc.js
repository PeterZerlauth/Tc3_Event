#!/usr/bin/env node

/**
 * autodoc.js
 * Generate Markdown documentation from TwinCAT .TcPOU and .TcDUT XML files.
 *
 * Requirements:
 *   npm i xml2js
 *
 * Usage:
 *   node autodoc.js
 *
 * Output:
 *   ./docs/Source/...    (POU docs)
 *   ./docs/Types/...     (DUT docs)
 *   ./docs/00_Overview.md
 */

import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { parseStringPromise } from 'xml2js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

// CONFIG
const SRC_DIR = path.resolve('C:\\source\\repos\\Tc3_Event\\Tc3_Event\\Tc3_Event');
const OUT_DIR = path.resolve('C:\\source\\repos\\Tc3_Event\\docs');
const OUT_TYPES = path.join(OUT_DIR, 'Types');
const OUT_SOURCE = path.join(OUT_DIR, 'Source');

const xmlParserOptions = { explicitArray: false, preserveChildrenOrder: true, trim: false };

/* Helpers */
async function exists(p) {
  try { await fs.access(p); return true; } catch { return false; }
}

async function mkdirp(p) {
  await fs.mkdir(p, { recursive: true });
}

function toForward(p) {
  return p.replace(/\\/g, '/');
}

function relLink(fromFull, toFull) {
  const rel = path.relative(path.dirname(fromFull), toFull) || path.basename(toFull);
  return toForward(rel);
}

/* File collection */
async function collectFiles(dir) {
  const results = [];
  async function walk(d) {
    let list;
    try { list = await fs.readdir(d, { withFileTypes: true }); }
    catch (e) { return; }
    for (const ent of list) {
      const full = path.join(d, ent.name);
      if (ent.isDirectory()) {
        await walk(full);
      } else {
        const ext = path.extname(ent.name).toLowerCase();
        if (ext === '.tcpou' || ext === '.tcdut' || ext === '.xml') results.push(full);
      }
    }
  }
  await walk(dir);
  return results;
}

/* Basic declaration parsing — extracts VAR blocks and simple DUT enums/structs */
function extractVarBlocks(declarationText) {
  // returns { inputs: [], outputs: [], vars: [] } each entry {name,type,default,comment}
  if (!declarationText) return { inputs: [], outputs: [], vars: [] };

  const lines = declarationText.split(/\r?\n/);
  const sectionStack = [];
  let current = 'NONE';
  let pendingComment = '';
  const inputs = [], outputs = [], vars = [];

  // regex similar to PowerShell version but permissive
  const varRegex = /^\s*(?<Name>[A-Za-z_]\w*)\s*:\s*(?<Type>[\w\.\<\>\[\]\(\)]+)(?:\s*[:=]\s*(?<Default>[^;\/]*))?\s*;?\s*(?:\/\/\s*(?<Comment>.*))?/;
  const singleLineComment = /^\s*\/\/\s*(.*)$/;
  const blockComment = /^\s*\(\*\s*(.*?)\s*\*\)\s*$/;

  for (let raw of lines) {
    const line = raw.trim();
    if (!line) { pendingComment = pendingComment ? pendingComment + ' ' : pendingComment; continue; }

    // comments
    let m;
    if ((m = line.match(singleLineComment))) {
      pendingComment = pendingComment ? (pendingComment + ' ' + m[1].trim()) : m[1].trim();
      continue;
    }
    if ((m = line.match(blockComment))) {
      pendingComment = pendingComment ? (pendingComment + ' ' + m[1].trim()) : m[1].trim();
      continue;
    }

    const up = line.toUpperCase();
    if (up.startsWith('VAR_INPUT')) { current = 'INPUT'; continue; }
    if (up.startsWith('VAR_OUTPUT')) { current = 'OUTPUT'; continue; }
    if (up.startsWith('VAR ') || up === 'VAR') { current = 'VAR'; continue; }
    if (up.startsWith('END_VAR')) { current = 'NONE'; pendingComment = ''; continue; }

    const vr = line.match(varRegex);
    if (vr) {
      const name = vr.groups.Name;
      const type = vr.groups.Type;
      const def = (vr.groups.Default || '').trim();
      const comment = vr.groups.Comment ? vr.groups.Comment.trim() : pendingComment || '';
      pendingComment = '';

      const item = { name, type, default: def, comment };
      if (current === 'INPUT') inputs.push(item);
      else if (current === 'OUTPUT') outputs.push(item);
      else if (current === 'VAR') vars.push(item);
      else {
        // top-level var? push to vars
        vars.push(item);
      }
    } else {
      // not a var line; clear pending comment unless it's likely attached
      // keep pendingComment in case next line is var
    }
  }

  return { inputs, outputs, vars };
}

function parseDutDeclarationToTable(declarationText) {
  // Detect if enum or struct
  if (!declarationText) return { kind: 'unknown', rows: [] };
  const t = declarationText;
  const isStruct = /\bSTRUCT\b/i.test(t);
  const isEnum = /\b\(|\b:=\b/.test(t) && !isStruct; // naive
  const rows = [];

  const lines = t.split(/\r?\n/);
  let pendingComment = '';
  const enumRegex = /^\s*(?<Name>[A-Za-z_]\w*)(?:\s*(?:[:=]\s*(?<Value>[-]?\d+))?)\s*[,;]?(\s*\/\/\s*(?<Comment>.*))?/;
  const varRegex = /^\s*(?<Name>[A-Za-z_]\w*)\s*:\s*(?<Type>[\w\.\<\>\[\]\(\)]+)\s*;?\s*(?:\/\/\s*(?<Comment>.*))?/;

  for (let raw of lines) {
    const line = raw.trim();
    if (!line) { pendingComment = pendingComment ? pendingComment + ' ' : pendingComment; continue; }

    let m;
    if ((m = line.match(/^\s*\/\/\s*(.*)$/))) {
      pendingComment = pendingComment ? (pendingComment + ' ' + m[1].trim()) : m[1].trim();
      continue;
    }
    if ((m = line.match(/^\s*\(\*\s*(.*?)\s*\*\)\s*$/))) {
      pendingComment = pendingComment ? (pendingComment + ' ' + m[1].trim()) : m[1].trim();
      continue;
    }

    if (isStruct && (m = line.match(varRegex))) {
      const name = m.groups.Name;
      const type = m.groups.Type;
      const comment = (m.groups.Comment || pendingComment || '').trim();
      rows.push({ name, type, comment });
      pendingComment = '';
    } else if (isEnum && (m = line.match(enumRegex))) {
      const name = m.groups.Name;
      const value = (m.groups.Value || '...').trim();
      const comment = (m.groups.Comment || pendingComment || '').trim();
      rows.push({ name, value, comment });
      pendingComment = '';
    } else {
      // skip TYPE/END_TYPE/STRUCT/END_STRUCT lines
    }
  }

  return { kind: isStruct ? 'struct' : (isEnum ? 'enum' : 'unknown'), rows };
}

/* Parse xml file and extract doc model */
async function parseTcFile(fileFullPath) {
  const xmlText = await fs.readFile(fileFullPath, 'utf8');
  let parsed;
  try {
    parsed = await parseStringPromise(xmlText, xmlParserOptions);
  } catch (err) {
    console.warn(`XML parse error ${fileFullPath}: ${err.message}`);
    return null;
  }
  if (!parsed || !parsed.TcPlcObject) return null;

  const tc = parsed.TcPlcObject;

  if (tc.POU) {
    // Support if POU is array or single
    const pouNode = Array.isArray(tc.POU) ? tc.POU[0] : tc.POU;
    const name = pouNode.$?.Name || pouNode.Name || path.basename(fileFullPath);
    const implementsIface = pouNode.$?.SpecialFunc || '';
    const declaration = (pouNode.Declaration && (pouNode.Declaration._ || pouNode.Declaration['#cdata-section'] || pouNode.Declaration)) || '';
    const declText = typeof declaration === 'string' ? declaration : (declaration['#cdata-section'] || '') ;
    const methodsRaw = pouNode.Method ? (Array.isArray(pouNode.Method) ? pouNode.Method : [pouNode.Method]) : [];
    const propsRaw = pouNode.Property ? (Array.isArray(pouNode.Property) ? pouNode.Property : [pouNode.Property]) : [];

    const methods = methodsRaw.map(m => {
      const decl = m.Declaration && (m.Declaration._ || m.Declaration['#cdata-section'] || m.Declaration) || '';
      const impl = m.Implementation && (m.Implementation.ST || m.Implementation._) || '';
      return {
        name: m.$?.Name || m.Name,
        declaration: typeof decl === 'string' ? decl : (decl['#cdata-section'] || ''),
        implementation: typeof impl === 'string' ? impl : ''
      };
    });

    const properties = propsRaw.map(p => {
      const decl = p.Declaration && (p.Declaration._ || p.Declaration['#cdata-section'] || p.Declaration) || '';
      return { name: p.$?.Name || p.Name, declaration: typeof decl === 'string' ? decl : (decl['#cdata-section'] || '') };
    });

    return {
      kind: 'POU',
      name,
      file: fileFullPath,
      declaration: declText,
      methods,
      properties
    };
  }

  if (tc.DUT) {
    const dut = Array.isArray(tc.DUT) ? tc.DUT[0] : tc.DUT;
    const name = dut.$?.Name || path.basename(fileFullPath);
    const declaration = (dut.Declaration && (dut.Declaration._ || dut.Declaration['#cdata-section'] || dut.Declaration)) || '';
    const declText = typeof declaration === 'string' ? declaration : (declaration['#cdata-section'] || '');
    return {
      kind: 'DUT',
      name,
      file: fileFullPath,
      declaration: declText
    };
  }

  // Not POU/DUT we care about
  return null;
}

/* Build maps */
async function buildMaps(tcFiles) {
  const TypesMap = {}; // name -> output full path
  const POUMap = {};   // name -> output full path

  // First pass: identify names and decide output path (mirror source subfolders)
  for (const f of tcFiles) {
    const parsed = await parseTcFile(f);
    if (!parsed) continue;

    // compute mirror relative location under src root
    const rel = path.relative(SRC_DIR, path.dirname(f)); // relative folder inside Tc3_Event/Tc3_Event
    const safeRel = rel === '' ? '' : rel;

    if (parsed.kind === 'DUT') {
      const outFolder = safeRel ? path.join(OUT_TYPES, safeRel) : OUT_TYPES;
      const outPath = path.join(outFolder, `${parsed.name}.md`);
      if (!TypesMap[parsed.name]) TypesMap[parsed.name] = path.resolve(outPath);
    } else if (parsed.kind === 'POU') {
      const outFolder = safeRel ? path.join(OUT_SOURCE, safeRel) : OUT_SOURCE;
      const outPath = path.join(outFolder, `${parsed.name}.md`);
      if (!POUMap[parsed.name]) POUMap[parsed.name] = path.resolve(outPath);
    }
  }

  return { TypesMap, POUMap };
}

/* Render helpers */
function mdEscapePipe(s='') {
  return (s || '').replace(/\|/g, '\\|');
}

function linkifyType(typeString, fromFullPath, TypesMap, POUMap) {
  if (!typeString) return '';
  // strip array/size qualifiers crudely, keep core token
  // we look for tokens like IDENT or IDENT[...] or IDENT.<something>; pick first token
  const tokenMatch = typeString.match(/([A-Za-z_]\w*)(?:[^\w].*)?$/) || typeString.match(/^([A-Za-z_]\w*)/);
  const token = tokenMatch ? tokenMatch[1] : null;
  if (!token) return `\`${typeString}\``;

  if (TypesMap[token]) {
    const rel = relLink(fromFullPath, TypesMap[token]);
    return `[${token}](${rel})`;
  }
  if (POUMap[token]) {
    const rel = relLink(fromFullPath, POUMap[token]);
    return `[${token}](${rel})`;
  }
  // no link found
  return `\`${typeString}\``;
}

/* Generate Markdown for DUT */
async function generateDUTDoc(dutModel, TypesMap, POUMap) {
  const srcFile = dutModel.file;
  const rel = path.relative(SRC_DIR, path.dirname(srcFile));
  const outFolder = rel ? path.join(OUT_TYPES, rel) : OUT_TYPES;
  await mkdirp(outFolder);
  const outFull = path.join(outFolder, `${dutModel.name}.md`);

  const parsed = parseDutDeclarationToTable(dutModel.declaration);
  let md = `# ${dutModel.name}\n\n`;
  md += "```iecst\n";
  md += dutModel.declaration.trim() + "\n";
  md += "```\n\n";

  if (parsed.kind === 'struct' && parsed.rows.length) {
    md += "## Fields\n\n";
    md += "| Name | Type | Comment |\n| :--- | :--- | :--- |\n";
    for (const r of parsed.rows) {
      const t = linkifyType(r.type || '', outFull, TypesMap, POUMap);
      md += `| \`${r.name}\` | ${t} | ${mdEscapePipe(r.comment || '')} |\n`;
    }
    md += "\n";
  } else if (parsed.kind === 'enum' && parsed.rows.length) {
    md += "## Members\n\n";
    md += "| Name | Value | Comment |\n| :--- | :--- | :--- |\n";
    for (const r of parsed.rows) {
      md += `| \`${r.name}\` | \`${r.value}\` | ${mdEscapePipe(r.comment || '')} |\n`;
    }
    md += "\n";
  } else {
    md += "_No structured fields detected. Showing raw declaration above._\n\n";
  }

  await fs.writeFile(outFull, md, 'utf8');
  return outFull;
}

/* Generate Markdown for POU */
async function generatePOUDoc(pouModel, TypesMap, POUMap) {
  const srcFile = pouModel.file;
  const rel = path.relative(SRC_DIR, path.dirname(srcFile));
  const outFolder = rel ? path.join(OUT_SOURCE, rel) : OUT_SOURCE;
  await mkdirp(outFolder);
  const outFull = path.join(outFolder, `${pouModel.name}.md`);

  let md = `# ${pouModel.name}\n\n`;
  md += "```iecst\n";
  md += (pouModel.declaration || '').trim() + "\n";
  md += "```\n\n";

  // extract var blocks
  const blocks = extractVarBlocks(pouModel.declaration || '');
  if (blocks.inputs.length) {
    md += "### VAR_INPUT\n\n";
    // detect presence of defaults
    const hasDefaults = blocks.inputs.some(i => i.default && i.default.length);
    if (hasDefaults) {
      md += "| Name | Type | Default | Description |\n| :--- | :--- | :--- | :--- |\n";
      for (const v of blocks.inputs) {
        const t = linkifyType(v.type, outFull, TypesMap, POUMap);
        md += `| \`${v.name}\` | ${t} | \`${mdEscapePipe(v.default)}\` | ${mdEscapePipe(v.comment)} |\n`;
      }
    } else {
      md += "| Name | Type | Description |\n| :--- | :--- | :--- |\n";
      for (const v of blocks.inputs) {
        const t = linkifyType(v.type, outFull, TypesMap, POUMap);
        md += `| \`${v.name}\` | ${t} | ${mdEscapePipe(v.comment)} |\n`;
      }
    }
    md += "\n";
  }

  if (blocks.outputs.length) {
    md += "### VAR_OUTPUT\n\n";
    md += "| Name | Type | Description |\n| :--- | :--- | :--- |\n";
    for (const v of blocks.outputs) {
      const t = linkifyType(v.type, outFull, TypesMap, POUMap);
      md += `| \`${v.name}\` | ${t} | ${mdEscapePipe(v.comment)} |\n`;
    }
    md += "\n";
  }

  if (blocks.vars.length) {
    md += "### VAR\n\n";
    md += "| Name | Type | Description |\n| :--- | :--- | :--- |\n";
    for (const v of blocks.vars) {
      const t = linkifyType(v.type, outFull, TypesMap, POUMap);
      md += `| \`${v.name}\` | ${t} | ${mdEscapePipe(v.comment)} |\n`;
    }
    md += "\n";
  }

  // Properties
  if (pouModel.properties && pouModel.properties.length) {
    md += "## Properties\n\n";
    md += "| Name | Declaration |\n| :--- | :--- |\n";
    for (const p of pouModel.properties) {
      md += `| \`${p.name}\` | \`\`\`iecst\n${p.declaration.trim()}\n\`\`\` |\n`;
    }
    md += "\n";
  }

  // Methods
  if (pouModel.methods && pouModel.methods.length) {
    md += "## Methods\n\n";
    for (const m of pouModel.methods) {
      md += `### ${m.name}\n\n`;
      const decl = (m.declaration || '').trim();
      if (decl) {
        // try to extract return type
        let ret = '';
        const retMatch = decl.match(/METHOD\s+[A-Za-z_]\w*\s*:\s*([\w\.\(\)]+)/i);
        if (retMatch) ret = retMatch[1];
        md += "```iecst\n" + decl + "\n```\n\n";
        if (ret) md += `**Returns:** \`${ret}\`\n\n`;
      } else {
        md += "_(no declaration)_\n\n";
      }
      // Optional: add implementation snippet collapsed (we'll show it raw)
      if (m.implementation && m.implementation.trim()) {
        md += "<details>\n<summary>Implementation</summary>\n\n```iecst\n" + m.implementation.trim() + "\n```\n\n</details>\n\n";
      }
    }
  }

  await fs.writeFile(outFull, md, 'utf8');
  return outFull;
}

/* Main generator */
async function run() {
  console.log(`Source: ${SRC_DIR}`);
  console.log(`Output: ${OUT_DIR}`);

  if (!await exists(SRC_DIR)) {
    console.error(`Source folder not found: ${SRC_DIR}`);
    process.exit(1);
  }

  const files = await collectFiles(SRC_DIR);
  if (!files.length) {
    console.error('No .TcPOU/.TcDUT/.xml files found under', SRC_DIR);
    process.exit(1);
  }

  await mkdirp(OUT_TYPES);
  await mkdirp(OUT_SOURCE);

  // Build maps
  const parsedList = [];
  for (const f of files) {
    try {
      const p = await parseTcFile(f);
      if (p) parsedList.push(p);
    } catch (e) {
      console.warn('Skipping', f, e.message);
    }
  }

  const { TypesMap, POUMap } = await buildMaps(files);

  // Generate docs
  const generated = { types: [], pous: [] };

  for (const mdl of parsedList) {
    if (mdl.kind === 'DUT') {
      try {
        const out = await generateDUTDoc(mdl, TypesMap, POUMap);
        generated.types.push({ name: mdl.name, out });
        console.log('Wrote DUT:', out);
      } catch (e) {
        console.error('Error writing DUT', mdl.name, e);
      }
    } else if (mdl.kind === 'POU') {
      try {
        const out = await generatePOUDoc(mdl, TypesMap, POUMap);
        generated.pous.push({ name: mdl.name, out });
        console.log('Wrote POU:', out);
      } catch (e) {
        console.error('Error writing POU', mdl.name, e);
      }
    }
  }

  // Overview
  let ov = "# Overview\n\n";
  if (generated.pous.length) {
    ov += "## Function Blocks & Functions\n\n";
    const sortedP = generated.pous.sort((a,b) => a.name.localeCompare(b.name));
    for (const p of sortedP) {
      const rel = path.relative(OUT_DIR, p.out);
      ov += `- [${p.name}](${toForward(rel)})\n`;
    }
    ov += "\n";
  }

  if (generated.types.length) {
    ov += "## Datatypes\n\n";
    const sortedT = generated.types.sort((a,b) => a.name.localeCompare(b.name));
    for (const t of sortedT) {
      const rel = path.relative(OUT_DIR, t.out);
      ov += `- [${t.name}](${toForward(rel)})\n`;
    }
    ov += "\n";
  }

  const overviewPath = path.join(OUT_DIR, '00_Overview.md');
  await fs.writeFile(overviewPath, ov, 'utf8');
  console.log('Wrote Overview:', overviewPath);

  console.log('Done.');
}

run().catch(err => {
  console.error('Fatal:', err);
  process.exit(2);
});
