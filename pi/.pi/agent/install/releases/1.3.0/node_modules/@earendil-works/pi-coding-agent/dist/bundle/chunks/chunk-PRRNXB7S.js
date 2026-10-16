import { createRequire as __piCreateRequire } from "node:module"; const require = __piCreateRequire(import.meta.url);
function clampOpenAIPromptCacheKey(key){if(key===void 0)return;let chars=Array.from(key);return chars.length<=64?key:chars.slice(0,64).join("")}export{clampOpenAIPromptCacheKey};
