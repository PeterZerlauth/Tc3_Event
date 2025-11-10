const fs = require('fs');
const path = require('path');

// --- Configuration ---
const SOURCE_DIRECTORY = 'C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event';
const OUTPUT_DIRECTORY = 'C:/source/repos/Tc3_Event/doc'; // Output folder
const OVERVIEW_FILE = 'ProjectOverview.md';
// --- End Configuration ---

// Map file extensions to general categories
const objectTypeMap = {
  '.TcPOU': 'POU',   // FUNCTION / FUNCTION BLOCK will be determined later
  '.TcDUT': 'DUT',   // STRUCT / ENUM will be determined later
  '.TcIO': 'INTERFACE',
  '.TcGVL': 'GVL'
};

// --- Step 1: Recursively find TwinCAT files ---
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

// --- Step 2: Determine actual type ---
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

// --- Step 3: Group files by type ---
function mapFiles(files) {
  const grouped = {};
  for (const file of files) {
    const type = determineFileType(file);
    if (!grouped[type]) grouped[type] = [];
    grouped[type].push(file);
  }
  return grouped;
}

// --- Step 4: Generate individual Markdown files ---
function generateDocs(groupedFiles) {
  if (!fs.existsSync(OUTPUT_DIRECTORY)) fs.mkdirSync(OUTPUT_DIRECTORY, { recursive: true });

  for (const [type, files] of Object.entries(groupedFiles)) {
    for (const file of files) {
      const mdPath = path.join(OUTPUT_DIRECTORY, `${file.name}.md`);
      const content = `# ${file.name}

**Type:** ${type}  
**Source file:** \`${file.relativePath}\`  

## Details

> You can add declaration, properties, and methods here later.
`;
      fs.writeFileSync(mdPath, content, 'utf8');
      console.log(`Created ${mdPath}`);
    }
  }
}

// --- Step 5: Generate overview Markdown ---
function generateOverview(groupedFiles) {
  let markdown = "# Project Documentation\n\n";
  markdown += "## 📖 Overview\nThis document provides an overview of the TwinCAT project components.\n\n";

  for (const type of Object.keys(groupedFiles).sort()) {
    markdown += `### ${type} (${groupedFiles[type].length})\n`;
    groupedFiles[type].forEach(file => {
      const safeLink = encodeURI(file.name + '.md');
      markdown += `* [${file.name}](${safeLink}) — \`${file.relativePath}\`\n`;
    });
    markdown += '\n';
  }

  const overviewPath = path.join(OUTPUT_DIRECTORY, OVERVIEW_FILE);
  fs.writeFileSync(overviewPath, markdown, 'utf8');
  console.log(`\nOverview saved to ${overviewPath}`);
}

// --- Main ---
function main() {
  const files = findFilesRecursive(SOURCE_DIRECTORY, SOURCE_DIRECTORY);
  const groupedFiles = mapFiles(files);

  console.log('=== TwinCAT Project Files Grouped by Type ===\n');
  for (const type of Object.keys(groupedFiles).sort()) {
    console.log(`### ${type} (${groupedFiles[type].length})`);
    groupedFiles[type].forEach(file => console.log(`- ${file.name} (${file.relativePath})`));
    console.log('');
  }

  generateDocs(groupedFiles);
  generateOverview(groupedFiles);

  console.log('\n✅ All Markdown docs generated.');
}

main();
