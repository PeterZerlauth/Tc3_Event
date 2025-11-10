const fs = require('fs');
const path = require('path');

// --- Configuration ---
const SOURCE_DIRECTORY = 'C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event';
const OUTPUT_DIRECTORY = 'C:/source/repos/Tc3_Event/doc';
// --- End Configuration ---

// Map extensions to general object type
const objectTypeMap = {
  '.TcPOU': 'POU',   // FUNCTION vs FUNCTION BLOCK determined later
  '.TcDUT': 'DUT',   // STRUCT vs ENUM determined later
  '.TcIO': 'INTERFACE',
  '.TcGVL': 'GVL'
};

// ------------------- Helper Functions -------------------

// Recursively find TwinCAT files
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
          name: path.basename(entry.name, ext),
          ext,
          path: fullPath,
          relativePath
        });
      }
    }
  }

  return results;
}

// Determine type of each file
function determineFileType(file) {
  try {
    const content = fs.readFileSync(file.path, 'utf8');

    if (file.ext === '.TcPOU') {
      if (/FUNCTION\s+BLOCK/i.test(content)) return 'FUNCTION BLOCK';
      return 'FUNCTION';
    }

    if (file.ext === '.TcDUT') {
      if (/STRUCT/i.test(content)) return 'STRUCT';
      if (/ENUM/i.test(content)) return 'ENUM';
      return 'DUT';
    }

    if (file.ext === '.TcIO') return 'INTERFACE';
    if (file.ext === '.TcGVL') return 'GVL';

    return 'UNKNOWN';
  } catch (err) {
    console.error(`Failed to read ${file.path}: ${err.message}`);
    return 'UNKNOWN';
  }
}

// Group files by type
function mapFiles(files) {
  const grouped = {};
  for (const file of files) {
    const type = determineFileType(file);
    if (!grouped[type]) grouped[type] = [];
    grouped[type].push(file);
  }
  return grouped;
}

// Clear output folder
function clearOutputFolder() {
  if (fs.existsSync(OUTPUT_DIRECTORY)) {
    fs.rmSync(OUTPUT_DIRECTORY, { recursive: true, force: true });
  }
  fs.mkdirSync(OUTPUT_DIRECTORY, { recursive: true });
}

// Generate individual Markdown files preserving folder structure
async function generateObjectMarkdown(file) {
  const category = determineFileType(file);

  const content = `# ${file.name}\n\n` +
    `**Type:** ${category}\n\n` +
    `**Source File:** \`${file.relativePath}\`\n\n` +
    `> Details go here...\n`;

  const outputPath = path.join(OUTPUT_DIRECTORY, file.relativePath + '.md');
  const outputDir = path.dirname(outputPath);
  fs.mkdirSync(outputDir, { recursive: true });
  fs.writeFileSync(outputPath, content, 'utf8');

  console.log(`Created ${outputPath}`);
}

// Generate project overview
function generateOverview(groupedFiles) {
  let md = "# Project Documentation\n\n## 📖 Overview\nThis document provides an overview of the TwinCAT project components.\n\n";

  for (const type of Object.keys(groupedFiles).sort()) {
    md += `### ${type} (${groupedFiles[type].length})\n`;
    groupedFiles[type].forEach(file => {
      const linkPath = encodeURI(file.relativePath + '.md'); // preserve folder structure
      md += `* [${file.name}](${linkPath}) — \`${file.relativePath}\`\n`;
    });
    md += '\n';
  }

  const overviewPath = path.join(OUTPUT_DIRECTORY, 'ProjectOverview.md');
  fs.writeFileSync(overviewPath, md, 'utf8');
  console.log(`Overview generated: ${overviewPath}`);
}

// Generate all docs
async function generateDocs(groupedFiles) {
  const promises = [];
  for (const type in groupedFiles) {
    for (const file of groupedFiles[type]) {
      promises.push(generateObjectMarkdown(file));
    }
  }
  await Promise.all(promises);
}

// ------------------- Main -------------------
async function main() {
  clearOutputFolder();

  const files = findFilesRecursive(SOURCE_DIRECTORY, SOURCE_DIRECTORY);
  const groupedFiles = mapFiles(files);

  console.log('=== TwinCAT Project Files Grouped by Type ===\n');
  for (const type of Object.keys(groupedFiles).sort()) {
    console.log(`### ${type} (${groupedFiles[type].length})`);
    groupedFiles[type].forEach(file => console.log(`- ${file.name} (${file.relativePath})`));
    console.log('');
  }

  await generateDocs(groupedFiles);
  generateOverview(groupedFiles);

  console.log('\n✅ All Markdown docs generated.');
}

main();
