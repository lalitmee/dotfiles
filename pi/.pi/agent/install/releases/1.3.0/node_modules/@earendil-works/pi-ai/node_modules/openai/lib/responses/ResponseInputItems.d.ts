import type { ResponseInputItem, ResponseOutputItem } from "../../resources/responses/responses.js";
/** A stored response input or output item that may be normalized for a later request. */
export type ResponseInputItemLike = ResponseInputItem | ResponseOutputItem;
/**
 * Normalizes a mixed array of stored response history items into clean
 * `ResponseInputItem`s that can be sent back to `responses.create()`. Known items
 * that cannot be replayed without changing their meaning are omitted. SDK-only
 * parsed values are removed without changing the stored items.
 *
 * @throws {TypeError} If an item type is not supported by the installed SDK.
 */
export declare function toResponseInputItems(items: Iterable<ResponseInputItemLike>): ResponseInputItem[];
/**
 * Normalizes a stored response history item into a clean `ResponseInputItem`, or
 * returns `null` when a known item cannot be replayed without changing its
 * meaning. SDK-only parsed values are removed without changing the stored item.
 *
 * @throws {TypeError} If the item type is not supported by the installed SDK.
 */
export declare function toResponseInputItem(item: ResponseInputItemLike): ResponseInputItem | null;
//# sourceMappingURL=ResponseInputItems.d.ts.map