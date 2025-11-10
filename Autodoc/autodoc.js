const fs = require('fs');
const path = require('path');
const { Parser } = require('xml2js');

// --- Configuration ---
const SOURCE_DIRECTORY = 'C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event';
const OUTPUT_DIRECTORY = 'C:/source/repos/Tc3_Event/doc'; // Output folder for docs
const OVERVIEW_FILE = 'ProjectOverview.md';
// --- End Configuration ---

// Map TwinCAT file extensions to categories
const objectTypeMap = {
  '.TcPou': 'Program Organization Units (POUs)',
  '.TcIO': 'Interfaces (TcIO)',
  '.TcDUT': 'Data Unit Types (TcDUT)'
};

const xmlParser = new Parser({ explicitArray: false });

// Ensure the output folder exists
if (!fs.existsSync(OUTPUT_DIRECTORY)) {
  fs.mkdirSync(OUTPUT_DIRECTORY, { recursive: true });
}

/**
 * Recursively find TwinCAT files in a folder
 */
function findFilesRecursive(dir, rootDir) {
  let results = [];
  const entries = fs.readdirSync(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      results = results.concat(findFilesRecursive(fullPath, rootDir));
    } else {
      const ext = path.extname(entry.name);
      if (objectTypeMap[ext]) {
        const relativePath = path.relative(rootDir, fullPath).replace(/\\/g, '/');
        results.push({
          path: fullPath,
          relativePath: relativePath,
          ext,
          name: path.basename(entry.name, ext)
        });
      }
    }
  }
  return results;
}

/**
 * Generate Markdown tree overview with correct links
 */
function generateMarkdownOverview(files) {
  if (!files || files.length === 0) return "> No TwinCAT objects (.TcPOU, .TcIO, .TcDUT) were found.";

  let markdown = "# Project Documentation\n\n";
  markdown += "## 📖 Overview\n";
  markdown += "This document provides an overview of the TwinCAT project components.\n\n";
  markdown += "### 📂 Project File Structure\n";

  const fileTree = {};

  // Build tree
  for (const file of files) {
    const parts = file.relativePath.split('/');
    let current = fileTree;
    for (let i = 0; i < parts.length; i++) {
      const part = parts[i];
      if (i === parts.length - 1) {
        current[part] = file; // File
      } else {
        if (!current[part]) current[part] = {};
        current = current[part];
      }
    }
  }

  function renderTree(tree, indent = 0) {
    let output = "";
    const indentStr = '  '.repeat(indent) + '* ';

    const keys = Object.keys(tree).sort((a, b) => {
      const aFolder = typeof tree[a] === 'object' && tree[a].path === undefined;
      const bFolder = typeof tree[b] === 'object' && tree[b].path === undefined;
      if (aFolder && !bFolder) return -1;
      if (!aFolder && bFolder) return 1;
      return a.localeCompare(b);
    });

    for (const key of keys) {
      const node = tree[key];
      const isFolder = typeof node === 'object' && node.path === undefined;
      if (isFolder) {
        output += `${indentStr}\`${key}/\`\n`;
        output += renderTree(node, indent + 1);
      } else {
        const safeLink = encodeURI(node.relativePath.replace(/\.[^/.]+$/, '.md'));
        const type = (objectTypeMap[node.ext] || 'Unknown').match(/\(([^)]+)\)/)[1];
        output += `${indentStr}[${node.name}](${safeLink}) - *(${type})*\n`;
      }
    }
    return output;
  }

  markdown += renderTree(fileTree);
  return markdown.trim();
}

/**
 * Format XML CDATA to ST code block
 */
function formatDeclaration(decl) {
  if (!decl) return "N/A";
  let clean = typeof decl === 'object' && decl._ ? decl._ : decl;
  if (typeof clean === 'string') clean = clean.replace('<![CDATA[', '').replace(']]>', '');
  clean = clean.trim();
  if (!clean) return "*None*";
  return "```st\n" + clean + "\n```";
}

/**
 * Parse POU object to Markdown
 */
function parsePou(xml) {
  const pou = xml.TcPlcObject.POU;
  if (!pou) return "*None*";

  let md = `**Declaration**\n${formatDeclaration(pou.Declaration)}\n\n`;

  if (pou.Property) {
    md += "### Properties\n\n";
    const props = Array.isArray(pou.Property) ? pou.Property : [pou.Property];
    for (const prop of props) {
      md += `#### ${prop.$.Name}\n${formatDeclaration(prop.Declaration)}\n`;
      if (prop.Get) md += `**Get**\n${formatDeclaration(prop.Get.Declaration)}\n`;
      if (prop.Set) md += `**Set**\n${formatDeclaration(prop.Set.Declaration)}\n`;
      md += "---\n";
    }
  }

  if (pou.Method) {
    md += "### Methods\n\n";
    const methods = Array.isArray(pou.Method) ? pou.Method : [pou.Method];
    for (const method of methods) {
      md += `#### ${method.$.Name}\n${formatDeclaration(method.Declaration)}\n---\n`;
    }
  }

  return md;
}

/**
 * Parse Interface object to Markdown
 */
function parseItf(xml) {
  const itf = xml.TcPlcObject.Itf;
  if (!itf) return "*None*";
  let md = `**Declaration**\n${formatDeclaration(itf.Declaration)}\n\n`;

  if (itf.Property) {
    md += "### Properties\n\n";
    const props = Array.isArray(itf.Property) ? itf.Property : [itf.Property];
    for (const prop of props) {
      md += `#### ${prop.$.Name}\n${formatDeclaration(prop.Declaration)}\n`;
      if (prop.Get) md += `**Get**\n${formatDeclaration(prop.Get.Declaration)}\n`;
      if (prop.Set) md += `**Set**\n${formatDeclaration(prop.Set.Declaration)}\n`;
      md += "---\n";
    }
  }

  if (itf.Method) {
    md += "### Methods\n\n";
    const methods = Array.isArray(itf.Method) ? itf.Method : [itf.Method];
    for (const method of methods) {
      md += `#### ${method.$.Name}\n${formatDeclaration(method.Declaration)}\n---\n`;
    }
  }

  return md;
}

/**
 * Parse DUT object to Markdown
 */
function parseDut(xml) {
  const dut = xml.TcPlcObject.DUT;
  return `**Declaration**\n${formatDeclaration(dut.Declaration)}\n`;
}

/**
 * Generate individual Markdown for each object
 */
async function generateObjectMarkdown(file) {
  const category = objectTypeMap[file.ext] || 'Unknown';
  let details = "> Failed to parse XML content.\n";

  try {
    const xmlContent = fs.readFileSync(file.path, 'utf8');
    const xml = await xmlParser.parseStringPromise(xmlContent);

    if (file.ext === '.TcPou') details = parsePou(xml);
    else if (file.ext === '.TcIO') details = parseItf(xml);
    else if (file.ext === '.TcDUT') details = parseDut(xml);
  } catch (err) {
    details = `> **Error parsing XML:** ${err.message}\n`;
  }

  // Replicate folder structure in OUTPUT_DIRECTORY
  const outputSubfolder = path.join(OUTPUT_DIRECTORY, path.dirname(file.relativePath));
  if (!fs.existsSync(outputSubfolder)) fs.mkdirSync(outputSubfolder, { recursive: true });

  const outputPath = path.join(outputSubfolder, file.name + '.md');
  const content = `# ${file.name}\n\n**Type:** ${category}\n**Source File:** \`${file.relativePath}\`\n\n## Details\n${details}\n`;

  fs.writeFileSync(outputPath, content, 'utf8');
  console.log(`Created ${outputPath}`);
}

// --- Main ---
async function main() {
  try {
    const files = findFilesRecursive(SOURCE_DIRECTORY, SOURCE_DIRECTORY);

    // Overview
    const overviewMarkdown = generateMarkdownOverview(files);
    const overviewPath = path.join(OUTPUT_DIRECTORY, OVERVIEW_FILE);
    fs.writeFileSync(overviewPath, overviewMarkdown, 'utf8');
    console.log(`\nOverview saved to ${overviewPath}`);

    // Generate individual Markdown files
    await Promise.all(files.map(file => generateObjectMarkdown(file)));

    console.log(`\n✅ All individual object files created in ${OUTPUT_DIRECTORY}`);
  } catch (err) {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
}

main();
