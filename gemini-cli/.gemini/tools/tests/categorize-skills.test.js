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
    console.error(`FAIL: ${skill} -> expected "${expected}", got "${actual}"`);
    failed = true;
  }
}

if (failed) {
  process.exit(1);
} else {
  console.log('All 12 category tests PASS');
}

