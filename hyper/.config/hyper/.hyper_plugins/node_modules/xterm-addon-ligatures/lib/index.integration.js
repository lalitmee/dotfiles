"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const cp = require("child_process");
const path = require("path");
const os = require("os");
const chai_1 = require("chai");
describe('typings', () => {
    it('compiles successfully', function () {
        this.timeout(10000);
        const command = os.platform() === 'win32' ? 'tsc.cmd' : 'tsc';
        const result = cp.spawnSync(command, { cwd: path.resolve('./fixtures/typings-test') });
        chai_1.assert.equal(result.status, 0, `build did not succeed:\nstdout: ${String(result.stdout)}\nstderr: ${String(result.stderr)}\n`);
    });
});
//# sourceMappingURL=index.integration.js.map