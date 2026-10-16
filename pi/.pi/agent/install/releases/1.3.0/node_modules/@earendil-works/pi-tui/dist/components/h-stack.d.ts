import { Stack, type StackChild, type StackOptions } from "./stack.ts";
export declare class HStack extends Stack {
    protected readonly layoutType: "hstack";
    constructor(children?: StackChild[], options?: StackOptions);
    render(width: number): string[];
}
//# sourceMappingURL=h-stack.d.ts.map