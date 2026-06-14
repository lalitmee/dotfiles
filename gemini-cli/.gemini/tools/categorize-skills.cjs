const os = require('os');

function getCategory(name) {
  if (typeof name !== 'string') return 'Agentic Workflows & CLI Core';

  // Azure & Cloud
  if (name.startsWith('azure-') || name.startsWith('m365-')) return 'Azure & Cloud Management';

  // AWS & DevOps
  if (name.startsWith('aws-') || name.startsWith('terraform-') || name.startsWith('kubernetes-') || name.startsWith('docker-') || name.startsWith('cicd-') || name.startsWith('gitlab-')) return 'AWS & DevOps';

  // Frontend & Mobile
  if (
    name.startsWith('react-') || name.startsWith('angular-') || name.startsWith('vue-') || name.startsWith('nextjs-') ||
    name.startsWith('sveltekit') || name.startsWith('expo-') || name.startsWith('react-native-') || name.startsWith('flutter-') ||
    name.startsWith('ionic-') || name.startsWith('ios-') || name.startsWith('android-') || name.startsWith('android_')
  ) {
    return 'Frontend & Mobile Development';
  }

  // Backend & Databases
  if (
    name.startsWith('django-') || name.startsWith('fastapi-') || name.startsWith('laravel-') || name.startsWith('nestjs-') ||
    name.includes('python') || name.includes('golang') || name.includes('rust') || name.startsWith('database-') ||
    name.startsWith('postgres-') || name.startsWith('mongodb-') || name.startsWith('neon-') || name.startsWith('sql')
  ) {
    return 'Backend & Databases';
  }

  // Game Development
  if (name.includes('game-development') || name.startsWith('unity-') || name.startsWith('unreal-') || name.startsWith('bevy-') || name.startsWith('godot-') || name.startsWith('minecraft-')) return 'Game Development';

  // AI & Machine Learning
  if (name.startsWith('hugging-face-') || name.startsWith('transformers-js') || name.startsWith('langchain-') || name.startsWith('langfuse') || name.startsWith('langgraph') || name.startsWith('gemini-api-') || name.startsWith('yann-lecun-')) return 'AI & Machine Learning';

  // Security & Pentesting
  if (name.startsWith('security/') || name.startsWith('pentest-') || name.startsWith('active-directory-') || name.startsWith('wireshark-') || name.startsWith('vulnerability-') || name.startsWith('scan-') || name.startsWith('accesslint-') || name.startsWith('ethical-hacking-') || name.startsWith('red-team-') || name.includes('pentesting')) return 'Security & Pentesting';

  // SEO & Marketing
  if (name.startsWith('seo-') || name.startsWith('marketing-') || name.startsWith('copywriting-') || name.startsWith('analytics-') || name.includes('psychologist') || name.includes('cro') || name.includes('designer')) return 'SEO & Marketing';

  // Office & Productivity
  if (name.startsWith('google-') || name.startsWith('libreoffice/') || name.startsWith('slack-') || name.startsWith('telegram-') || name.startsWith('trello-') || name.startsWith('asana-') || name.startsWith('notion-') || name.startsWith('outlook-')) return 'Office & Productivity Automation';

  // Design & UI
  if (name.startsWith('figma-') || name.startsWith('canvas-') || name.startsWith('threejs-') || name.startsWith('hig-') || name.startsWith('tailwind-') || name.startsWith('shadcn') || name.startsWith('iconsax-') || name.startsWith('brand-')) return 'Design & UI';

  // Specialized Frameworks
  if (name.startsWith('odoo-') || name.startsWith('shopify-') || name.startsWith('wordpress-') || name.startsWith('makepad-')) return 'Specialized Frameworks';

  return 'Agentic Workflows & CLI Core';
}

module.exports = { getCategory };
