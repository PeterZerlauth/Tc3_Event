const fs = require('fs');
const path = require('path');

// --- Configuration ---
const SOURCE_DIRECTORY = 'C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event';
const OUTPUT_DIRECTORY = 'C:/source/repos/Tc3_Event/doc'; // Output folder for docs
const OUTPUT_FILE = 'ProjectOverview.md';
// --- End Configuration ---

// Map TwinCAT file extensions to categories
const objectTypeMap = {
  '.TcPOU': 'Program Organization Units (POUs)',
  '.TcIO': 'Interfaces (TcIO)',
  '.TcDUT': 'Data Unit Types (TcDUT)'
};

// Ensure the output folder exists
if (!fs.existsSync(OUTPUT_DIRECTORY)) {
  fs.mkdirSync(OUTPUT_DIRECTORY, { recursive: true });
}

/**
 * Recursively find TwinCAT files in a folder
 * @param {string} dir
 * @returns {Array<{path:string, ext:string, name:string}>}
 */
function findFilesRecursive(dir) {
  let results = [];
  const entries = fs.readdirSync(dir, { withFileTypes: true });

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);

    if (entry.isDirectory()) {
      results = results.concat(findFilesRecursive(fullPath));
    } else {
      const ext = path.extname(entry.name);
      if (objectTypeMap[ext]) {
        results.push({
          path: fullPath,
          ext,
          name: path.basename(entry.name, ext)
        });
      }
    }
  }

  return results;
}

/**
 * Generate a Markdown overview from files
 * @param {Array<{path:string, ext:string, name:string}>} files
 * @returns {string}
 */
function generateMarkdown(files) {
  if (!files || files.length === 0) {
    return "> No TwinCAT objects (.TcPOU, .TcIO, .TcDUT) were found.";
  }

  // Categorize files
  const categories = {};
  for (const { name, ext } of files) {
    const category = objectTypeMap[ext];
    if (!categories[category]) categories[category] = [];
    const safeLink = encodeURI(name + '.md'); // handles spaces
    categories[category].push(`* [${name}](${safeLink})`);
  }

  // Sort categories and links
  const categoryOrder = ['Interfaces (TcIO)', 'Data Unit Types (TcDUT)', 'Program Organization Units (POUs)'];
  let markdown = "# Project Documentation\n\n";
  markdown += "## 📖 Overview\n";
  markdown += "This document provides an overview of the TwinCAT project components.\n\n";

  for (const category of categoryOrder) {
    if (categories[category]) {
      markdown += `### ${category}\n`;
      categories[category].sort();
      markdown += categories[category].join('\n') + '\n\n';
    }
  }

  return markdown.trim();
}

// --- Main ---
function main() {
  try {
    const files = findFilesRecursive(SOURCE_DIRECTORY);
    const markdown = generateMarkdown(files);

    // Print to console
    console.log(markdown);

    // Write to output folder
    if (OUTPUT_FILE) {
      const outputPath = path.join(OUTPUT_DIRECTORY, OUTPUT_FILE);
      fs.writeFileSync(outputPath, markdown, 'utf8');
      console.log(`\nOverview saved to ${outputPath}`);
    }
  } catch (err) {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
}

main();
