const assert = require('assert');
const { filterManifest } = require('../prune-skills.cjs');

const mockManifest = {
  entries: [
    'aws-cost-cleanup',          // AWS & DevOps
    'django-perf-review',        // Backend & Databases
    'unity-developer',           // Game Development
    'using-superpowers'          // Agentic Workflows & CLI Core
  ]
};

try {
  const result = filterManifest(mockManifest, ['AWS & DevOps', 'Game Development']);
  assert.deepStrictEqual(result, {
    entries: [
      'django-perf-review',
      'using-superpowers'
    ]
  });
  console.log('filterManifest tests PASS');
} catch (e) {
  console.error('filterManifest tests FAIL:', e.message);
  process.exit(1);
}
