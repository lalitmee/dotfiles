import { type Component, type Focusable, type TuiMouseEvent, type TuiMouseEventResult } from "../tui.ts";
export interface InputOptions {
    prompt?: string;
    placeholder?: string;
    placeholderStyle?: (text: string) => string;
}
/**
 * Input component - single-line text input with horizontal scrolling
 */
export declare class Input implements Component, Focusable {
    private value;
    private cursor;
    private readonly prompt;
    private readonly placeholder;
    private readonly placeholderStyle;
    private renderedStartColumn;
    onSubmit?: (value: string) => void;
    onEscape?: () => void;
    /** Focusable interface - set by TUI when focus changes */
    focused: boolean;
    private pasteBuffer;
    private isInPaste;
    private killRing;
    private lastAction;
    private undoStack;
    constructor(options?: InputOptions);
    getValue(): string;
    setValue(value: string): void;
    handleInput(data: string): void;
    handleMouse(event: TuiMouseEvent): TuiMouseEventResult | undefined;
    private insertCharacter;
    private handleBackspace;
    private handleForwardDelete;
    private deleteToLineStart;
    private deleteToLineEnd;
    private deleteWordBackwards;
    private deleteWordForward;
    private yank;
    private yankPop;
    private pushUndo;
    private undo;
    private moveWordBackwards;
    private moveWordForwards;
    private handlePaste;
    invalidate(): void;
    render(width: number): string[];
}
//# sourceMappingURL=input.d.ts.map