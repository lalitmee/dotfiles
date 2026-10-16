import { Stack, type StackChild, type StackOptions } from "./stack.ts";
export declare class VStack extends Stack {
    protected readonly layoutType: "vstack";
    constructor(children?: StackChild[], options?: StackOptions);
    render(width: number): string[];
}
export type { StackChild, StackEntry, StackEntryOptions, StackOptions } from "./stack.ts";
//# sourceMappingURL=v-stack.d.ts.map