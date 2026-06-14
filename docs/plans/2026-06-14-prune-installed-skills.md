# Prune Installed Skills Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Prune the 1,500 installed skills from `antigravity-awesome-skills` to remove unneeded clutter and retain only the necessary ones.

**Architecture:** Group all 1,500 skills into 12 distinct categories. Walk the user through each category via an interactive interview to decide whether to keep, remove, or selectively review the skills. Then, run a script to delete rejected skills and update the manifest.

**Tech Stack:** Bash, Node.js/Javascript, JSON

---

### Task 1: Create the Categorization Script

**Files:**
- Create: `gemini-cli/.gemini/tools/categorize-skills.cjs`

**Step 1: Write the failing test**

Since this is a custom admin script, we will write a script validator check. We'll write a test script that validates the category mapping logic.

Create `gemini-cli/.gemini/tools/tests/categorize-skills.test.js`:
```javascript
const assert = require('assert');
const { getCategory } = require('../categorize-skills.cjs');

try {
  assert.strictEqual(getCategory('aws-cost-cleanup'), 'AWS & DevOps');
  assert.strictEqual(getCategory('django-perf-review'), 'Backend & Databases');
  assert.strictEqual(getCategory('unity-developer'), 'Game Development');
  console.log('Test PASS');
} catch (e) {
  console.error('Test FAIL:', e.message);
  process.exit(1);
}
```

**Step 2: Run test to verify it fails**

Run: `node gemini-cli/.gemini/tools/tests/categorize-skills.test.js`
Expected: FAIL (Cannot find module '../categorize-skills.cjs')

**Step 3: Write minimal implementation**

Create `gemini-cli/.gemini/tools/categorize-skills.cjs`:
```javascript
function getCategory(skillName) {
  if (skillName.startsWith('aws-') || skillName.startsWith('terraform-') || skillName.startsWith('kubernetes-') || skillName.startsWith('docker-')) {
    return 'AWS & DevOps';
  }
  if (skillName.startsWith('django-') || skillName.startsWith('fastapi-') || skillName.startsWith('python-') || skillName.startsWith('golang-') || skillName.startsWith('rust-')) {
    return 'Backend & Databases';
  }
  if (skillName.includes('unity') || skillName.includes('game') || skillName.startsWith('godot-') || skillName.startsWith('unreal-')) {
    return 'Game Development';
  }
  return 'Other';
}

module.exports = { getCategory };
```

**Step 4: Run test to verify it passes**

Run: `node gemini-cli/.gemini/tools/tests/categorize-skills.test.js`
Expected: PASS

**Step 5: Commit**

```bash
git add gemini-cli/.gemini/tools/categorize-skills.cjs gemini-cli/.gemini/tools/tests/categorize-skills.test.js
git commit -m "feat: add basic skill categorization script"
```

---

### Task 2: Implement Complete Classification Logic

**Files:**
- Modify: `gemini-cli/.gemini/tools/categorize-skills.cjs`
- Modify: `gemini-cli/.gemini/tools/tests/categorize-skills.test.js`

**Step 1: Write the failing test**

Modify `gemini-cli/.gemini/tools/tests/categorize-skills.test.js` to add tests for all 12 categories:
```javascript
const assert = require('assert');
const { getCategory } = require('../categorize-skills.cjs');

const tests = [
  ['azure-ai-ml-py', 'Azure & Cloud Management'],
  ['aws-cost-cleanup', 'AWS & DevOps'],
  ['react-patterns', 'Frontend & Mobile Development'],
  ['django-perf-review', 'Backend & Databases'],
  ['unity-developer', 'Game Development'],
  ['hugging-face-cli', 'AI & Machine Learning'],
  ['active-directory-attacks', 'Security & Pentesting'],
  ['seo-audit', 'SEO & Marketing'],
  ['google-docs-automation', 'Office & Productivity Automation'],
  ['figma-automation', 'Design & UI'],
  ['odoo-accounting-setup', 'Specialized Frameworks'],
  ['using-superpowers', 'Agentic Workflows & CLI Core']
];

let failed = false;
for (const [skill, expected] of tests) {
  const actual = getCategory(skill);
  if (actual !== expected) {
    console.error(`FAIL: ${skill} -> expected ${expected}, got ${actual}`);
    failed = true;
  }
}

if (failed) {
  process.exit(1);
} else {
  console.log('All 12 category tests PASS');
}
```

**Step 2: Run test to verify it fails**

Run: `node gemini-cli/.gemini/tools/tests/categorize-skills.test.js`
Expected: FAIL (with mismatched categories)

**Step 3: Write minimal implementation**

Update `gemini-cli/.gemini/tools/categorize-skills.cjs` with the full category classifier function:
```javascript
function getCategory(name) {
  if (name.startsWith('azure-') || name.startsWith('m365-')) return 'Azure & Cloud Management';
  if (name.startsWith('aws-') || name.startsWith('terraform-') || name.startsWith('kubernetes-') || name.startsWith('docker-') || name.startsWith('cicd-') || name.startsWith('gitlab-')) return 'AWS & DevOps';
  if (name.startsWith('react-') || name.startsWith('angular-') || name.startsWith('vue-') || name.startsWith('nextjs-') || name.startsWith('sveltekit') || name.startsWith('expo-') || name.startsWith('react-native-') || name.startsWith('flutter-') || name.startsWith('ionic-')) return 'Frontend & Mobile Development';
  if (name.startsWith('django-') || name.startsWith('fastapi-') || name.startsWith('laravel-') || name.startsWith('nestjs-') || name.startsWith('python-') || name.startsWith('golang-') || name.startsWith('rust-') || name.startsWith('database-') || name.startsWith('postgres-') || name.startsWith('mongodb-')) return 'Backend & Databases';
  if (name.includes('game-development') || name.startsWith('unity-') || name.startsWith('unreal-') || name.startsWith('bevy-') || name.startsWith('godot-') || name.startsWith('minecraft-')) return 'Game Development';
  if (name.startsWith('hugging-face-') || name.startsWith('transformers-js') || name.startsWith('langchain-') || name.startsWith('langfuse') || name.startsWith('langgraph') || name.startsWith('gemini-api-') || name.startsWith('yann-lecun-')) return 'AI & Machine Learning';
  if (name.startsWith('security/') || name.startsWith('pentest-') || name.startsWith('active-directory-') || name.startsWith('wireshark-') || name.startsWith('vulnerability-') || name.startsWith('scan-') || name.startsWith('accesslint-') || name.startsWith('ethical-hacking-') || name.startsWith('red-team-')) return 'Security & Pentesting';
  if (name.startsWith('seo-') || name.startsWith('marketing-') || name.startsWith('copywriting-') || name.startsWith('analytics-') || name.includes('psychologist') || name.includes('cro') || name.includes('designer')) return 'SEO & Marketing';
  if (name.startsWith('google-') || name.startsWith('libreoffice/') || name.startsWith('slack-') || name.startsWith('telegram-') || name.startsWith('trello-') || name.startsWith('asana-') || name.startsWith('notion-') || name.startsWith('outlook-')) return 'Office & Productivity Automation';
  if (name.startsWith('figma-') || name.startsWith('canvas-') || name.startsWith('threejs-') || name.startsWith('hig-') || name.startsWith('tailwind-') || name.startsWith('shadcn') || name.startsWith('iconsax-') || name.startsWith('brand-')) return 'Design & UI';
  if (name.startsWith('odoo-') || name.startsWith('shopify-') || name.startsWith('wordpress-') || name.startsWith('makepad-')) return 'Specialized Frameworks';
  return 'Agentic Workflows & CLI Core'; // default for core skills
}

module.exports = { getCategory };
```

**Step 4: Run test to verify it passes**

Run: `node gemini-cli/.gemini/tools/tests/categorize-skills.test.js`
Expected: PASS

**Step 5: Commit**

```bash
git add gemini-cli/.gemini/tools/categorize-skills.cjs gemini-cli/.gemini/tools/tests/categorize-skills.test.js
git commit -m "feat: complete skill categorization rules and tests"
```

---

### Task 3: Interactive Interview Setup & Skill Deletion Script

**Files:**
- Create: `gemini-cli/.gemini/tools/prune-skills.cjs`

**Step 2: Run test to verify it fails**

Run: `node gemini-cli/.gemini/tools/tests/prune-skills.test.js`
Expected: FAIL (Cannot find module '../prune-skills.cjs')

**Step 3: Write minimal implementation**

Create `gemini-cli/.gemini/tools/prune-skills.cjs`:
```javascript
const { getCategory } = require('./categorize-skills.cjs');

function filterManifest(manifest, categoriesToRemove) {
  const filteredEntries = manifest.entries.filter(entry => {
    const category = getCategory(entry);
    return !categoriesToRemove.includes(category);
  });
  return { ...manifest, entries: filteredEntries };
}

module.exports = { filterManifest };
```

**Step 4: Run test to verify it passes**

Run: `node gemini-cli/.gemini/tools/tests/prune-skills.test.js`
Expected: PASS

**Step 5: Commit**

```bash
git add gemini-cli/.gemini/tools/prune-skills.cjs gemini-cli/.gemini/tools/tests/prune-skills.test.js
git commit -m "feat: implement mock manifest filter logic"
```

---

### Task 4: Execute Pruning Operation

**Files:**
- Modify: `gemini-cli/.gemini/tools/prune-skills.cjs`
- Modify: `/home/lalitmee/.gemini/skills/.antigravity-install-manifest.json`

**Step 1: Write the script to perform actual filesystem deletion**

Enhance `prune-skills.cjs` to run filesystem deletions and save the updated manifest:
```javascript
const fs = require('fs');
const path = require('path');
const { getCategory } = require('./categorize-skills.cjs');
const { filterManifest } = require('./prune-skills.cjs');

function prune(categoriesToRemove) {
  const manifestPath = '/home/lalitmee/.gemini/skills/.antigravity-install-manifest.json';
  const skillsDir = '/home/lalitmee/.gemini/skills';

  if (!fs.existsSync(manifestPath)) {
    console.error('Manifest file not found.');
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
```

**Step 2: Run a dry-run check**

Create a dry-run log to verify folders that will be targeted.

**Step 3: Run the pruning command**

Run: `node gemini-cli/.gemini/tools/prune-skills.cjs "Azure & Cloud Management" "Game Development" "Specialized Frameworks" "SEO & Marketing" "Office & Productivity Automation"` (example categories based on user feedback)

**Step 4: Verify remaining skills**

Run: `ls -ld /home/lalitmee/.gemini/skills/using-superpowers`
Expected: exists
Run: `ls -d /home/lalitmee/.gemini/skills/azure-*`
Expected: No matches (deleted)

**Step 5: Commit**

```bash
git add gemini-cli/.gemini/tools/prune-skills.cjs
git commit -m "feat: complete skills deletion and manifest updater script"
```
