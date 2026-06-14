const fs = require('fs');
const path = require('path');
const os = require('os');
const { getCategory } = require('./categorize-skills.cjs');

function filterManifest(manifest, categoriesToRemove) {
  const filteredEntries = manifest.entries.filter(entry => {
    const category = getCategory(entry);
    return !categoriesToRemove.includes(category);
  });
  return { ...manifest, entries: filteredEntries };
}

function prune(categoriesToRemove, customHomedir = os.homedir()) {
  const manifestPath = path.join(customHomedir, '.gemini/skills/.antigravity-install-manifest.json');
  const skillsDir = path.join(customHomedir, '.gemini/skills');

  if (!fs.existsSync(manifestPath)) {
    console.error(`Manifest file not found at: ${manifestPath}`);
    return;
  }

  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  const originalCount = manifest.entries.length;

  const toDelete = manifest.entries.filter(entry => {
    const category = getCategory(entry);
    return categoriesToRemove.includes(category);
  });

  console.log(`Deleting ${toDelete.length} skills from categories: ${categoriesToRemove.join(', ')}...`);

  toDelete.forEach(entry => {
    const folderPath = path.join(skillsDir, entry);
    if (fs.existsSync(folderPath)) {
      fs.rmSync(folderPath, { recursive: true, force: true });
    }
  });

  const updatedManifest = filterManifest(manifest, categoriesToRemove);
  fs.writeFileSync(manifestPath, JSON.stringify(updatedManifest, null, 2), 'utf8');
  console.log(`Pruning done. Skills remaining: ${updatedManifest.entries.length} (deleted ${originalCount - updatedManifest.entries.length}).`);
}

if (require.main === module) {
  const categories = process.argv.slice(2);
  prune(categories);
}

module.exports = { filterManifest, prune };
