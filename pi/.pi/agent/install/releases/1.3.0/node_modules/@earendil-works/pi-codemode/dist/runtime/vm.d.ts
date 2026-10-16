import type { CodemodeWasmModule } from "../wasm.ts";
import type { HostToWorkerMessage, VmStartData, WorkerToHostMessage } from "./protocol.ts";
export interface VmSession {
    deliver(message: HostToWorkerMessage): void;
    /** Releases the VM's wasm instance. The session must not be used afterwards. */
    dispose(): void;
}
export interface StartVmOptions {
    data: VmStartData;
    wasm: CodemodeWasmModule;
    /**
     * QuickJS's guard on its own stack, which turns deep recursion into a catchable `RangeError`.
     * The wasm frames also use the host thread's native stack, so the guard must trip before that
     * stack runs out: a host overflow fails the whole execution instead. Default: `MAX_STACK_SIZE`
     * (512 KiB), which fits the 4 MB stack of a Node worker thread but not a 1 MB main thread.
     */
    maxStackSize?: number;
    /** Interrupt polls this VM may use, if the launcher counts them; part of the fingerprint. */
    interruptBudget?: number;
    post(message: WorkerToHostMessage): void;
    shouldInterrupt(): boolean;
}
export declare function startVm(options: StartVmOptions): Promise<VmSession>;
//# sourceMappingURL=vm.d.ts.map