/**
 * JavaScript evaluated inside the QuickJS VM before the script runs.
 *
 * The VM is its own wasm instance, so nothing here guards a realm boundary.
 * The prelude keeps the host bridge in a closure so the script cannot call it
 * directly, and builds `tools`, `ALL_TOOLS`, the output helpers (`text`, `image`,
 * `exit`, `console`), and globals on top of it. Tool arguments and results cross
 * as JSON strings and are parsed on this side.
 *
 * Output helpers: `text(value)` appends a text item (non-strings are
 * JSON-stringified), `image(urlOrItem)` appends an image from a base64 `data:` URL, an
 * `{ image_url }` object, or an image block `{ type: "image", data, mimeType }`, and `exit()` ends the script
 * successfully. `console.*` appends text items marked as console output.
 *
 * `store(key, value)` and `load(key)` are synchronous: they work on a snapshot of
 * JSON text passed in as `storeJson`, and the keys the script wrote are reported
 * with a successful "done".
 *
 * Evaluates to a function `(bridge, toolsJson, globalsJson, storeJson) => { settle, run, stalled }`.
 * `settle(id, ok, payload, propertiesJson)` settles call `id`; a rejection's `Error` gets the own properties of the
 * `propertiesJson` object, except `name`, `message`, and `stack`.
 * `toolsJson` lists `{ name, jsName, description }`: `tools[jsName]` and `tools[name]` call the
 * tool, and `ALL_TOOLS` lists `{ name: jsName, description }`.
 * `stalled()` reports a script that has not finished while no host call is pending: with no timers
 * or I/O in the VM, nothing can ever resume it.
 * `globalsJson` lists `{ name, spread }`; `a.b` names are grouped into a frozen `a` object.
 * `bridge(kind, a, b, c)` with kind "call" or "global" (id, name, argsJson),
 * "output" ("text" or "console", text) or ("image", data, mimeType), or "done" (ok, valueJsonOrErrorJson, writesJson).
 *
 * Before anything else the prelude freezes the built-ins and makes the built-in globals read-only.
 * The prelude shares them with the script, so a script that patched one (for example
 * `Array.prototype.toJSON`) could otherwise corrupt what the prelude reports to the host.
 */
export declare const MAX_STORE_VALUE_CHARS: number;
export declare const MAX_STORE_TOTAL_CHARS: number;
/**
 * Output one script may produce with `text()`, `image()`, and `console.*`: characters of text and
 * base64 image data, and items. The host keeps all output until the script ends, so without a
 * limit a script that prints in a loop grows the host's memory until it crashes. The item limit
 * covers loops that print empty strings.
 */
export declare const MAX_OUTPUT_CHARS: number;
export declare const MAX_OUTPUT_ITEMS = 100000;
export declare const PRELUDE_SOURCE: string;
//# sourceMappingURL=prelude-source.d.ts.map