const fs = require('fs');
const path = require('path');

// --- Configuration ---
const SOURCE_DIRECTORY = 'C:/source/repos/Tc3_Event/Tc3_Event/Tc3_Event';
const OUTPUT_DIRECTORY = 'C:/source/repos/Tc3_Event/doc'; // Output folder for docs
const OVERVIEW_FILE = 'ProjectOverview.md';
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
 */
function generateMarkdownOverview(files) {
  if (!files || files.length === 0) {
    return "> No TwinCAT objects (.TcPOU, .TcIO, .TcDUT) were found.";
  }

  // Categorize files
  const categories = {};
  for (const { name, ext } of files) {
    const category = objectTypeMap[ext];
    if (!categories[category]) categories[category] = [];
    const safeLink = encodeURI(name + '.md');
    categories[category].push(`* [${name}](${safeLink})`);
  }

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

/**
 * Generate a separate Markdown file for each object
 */
function generateObjectMarkdown(file) {
  const category = objectTypeMap[file.ext] || 'Unknown';
  const content = `# ${file.name}\n\n` +
                  `**Type:** ${category}\n\n` +
                  `**Source File:** ${file.path}\n\n` +
                  `> Add details about methods, properties, or interfaces here.\n`;

  const outputPath = path.join(OUTPUT_DIRECTORY, file.name + '.md');
  fs.writeFileSync(outputPath, content, 'utf8');
  console.log(`Created ${outputPath}`);
}

// --- Main ---
function main() {
  try {
    const files = findFilesRecursive(SOURCE_DIRECTORY);

    // Generate overview
    const overviewMarkdown = generateMarkdownOverview(files);
    const overviewPath = path.join(OUTPUT_DIRECTORY, OVERVIEW_FILE);
    fs.writeFileSync(overviewPath, overviewMarkdown, 'utf8');
    console.log(`\nOverview saved to ${overviewPath}`);

    // Generate individual files
    for (const file of files) {
      generateObjectMarkdown(file);
    }

    console.log(`\n✅ All individual object files created in ${OUTPUT_DIRECTORY}`);
  } catch (err) {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
}

main();
