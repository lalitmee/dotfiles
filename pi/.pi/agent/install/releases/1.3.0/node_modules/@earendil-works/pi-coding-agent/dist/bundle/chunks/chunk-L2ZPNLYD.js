import { createRequire as __piCreateRequire } from "node:module"; const require = __piCreateRequire(import.meta.url);
function sanitizeSurrogates(text){return text.replace(/[\uD800-\uDBFF](?![\uDC00-\uDFFF])|(?<![\uD800-\uDBFF])[\uDC00-\uDFFF]/g,"")}export{sanitizeSurrogates};
