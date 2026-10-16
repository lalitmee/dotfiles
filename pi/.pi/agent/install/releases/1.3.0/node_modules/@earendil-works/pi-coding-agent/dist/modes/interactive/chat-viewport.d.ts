import { type Component, ScrollView, type ScrollViewScrollbar } from "@earendil-works/pi-tui";
export interface ChatViewportOptions {
    readonly document: Component;
    readonly pendingMessages: Component;
    readonly status: Component;
    readonly editor: Component;
    readonly footer: Component;
    readonly widgetsAbove?: Component;
    readonly widgetsBelow?: Component;
    readonly scrollbar?: ScrollViewScrollbar;
    readonly scrollbarTrackStyle?: (text: string) => string;
    readonly scrollbarThumbStyle?: (text: string) => string;
}
export interface ChatViewport {
    readonly root: Component;
    readonly transcript: ScrollView;
}
/** Shared fullscreen transcript and fixed input-dock layout. */
export declare function createChatViewport(options: ChatViewportOptions): ChatViewport;
//# sourceMappingURL=chat-viewport.d.ts.map