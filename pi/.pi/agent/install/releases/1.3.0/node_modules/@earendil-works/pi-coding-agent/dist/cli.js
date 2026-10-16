#!/usr/bin/env node
import { setupCli } from "./cli/setup.js";
import { main } from "./main.js";
setupCli();
main(process.argv.slice(2));
//# sourceMappingURL=cli.js.map