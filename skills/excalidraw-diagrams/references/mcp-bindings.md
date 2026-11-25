# MCP adapters and persistent arrow attachment

## Capability discovery

Read tool descriptions and the active server's format guide once. Server variants have incompatible APIs. Do not copy calls from another server's README. Record which interface was actually available.

The `read_me` / `create_view` interface accepts a JSON array string with simplified elements and supports `cameraUpdate`. These pseudo-elements are not native `.excalidraw` scene elements. A returned view is not proof of a saved native file, a library import, or a successful edit of an existing user scene.

## Binding contract

For every relationship arrow:

1. A stable source and target shape ID exist, each resolving to a live bindable element.
2. The arrow's `startBinding.elementId` is the source and `endBinding.elementId` is the target.
3. Native source and target shapes each include `{ "id": "edge-id", "type": "arrow" }` in `boundElements`.
4. Route endpoints reach the intended shape ports, allowing the editor's normal small binding gap. Coordinates alone do not establish attachment.
5. Bound node labels have `containerId`; the container reciprocally references each bound text ID. Standalone annotations remain independent.

Do not use groups as a substitute: grouping everything makes the whole diagram move, while the requirement is independent node movement with attached edges.

## Shorthand example

The active guide advertises raw binding shorthand, but the locally inspected 0.18 conversion path drops raw `startBinding`/`endBinding` on new arrows. Browser testing confirmed that skeleton `start`/`end` object references generate actual endpoint bindings. For this adapter, provide the following references as well as the raw/native fields, then inspect the converted result. This is an observed adapter requirement, not a universal MCP schema:

```json
{
  "type": "arrow", "id": "submit-review",
  "x": 240, "y": 120, "width": 96, "height": 0,
  "points": [[0, 0], [96, 0]], "endArrowhead": "arrow",
  "start": { "id": "submit" },
  "end": { "id": "review" },
  "startBinding": { "elementId": "submit", "focus": 0, "gap": 1 },
  "endBinding": { "elementId": "review", "focus": 0, "gap": 1 }
}
```

Include referenced shapes in the same scene. The converter computes focus/gap from geometry and maintains reciprocal references through its skeleton binding path. Check both IDs and resulting geometry; do not assume supplied raw fields survived. Where the active schema supports fixed ports, normalized coordinates are top `[0.5,0]`, right `[1,0.5]`, bottom `[0.5,1]`, left `[0,0.5]`. A diamond's usable border differs from its bounding rectangle.

## Native file representation

Native files contain full elements, `appState`, `files`, a scene `type`, and `version`. Use the installed Excalidraw version's schema or conversion/restore utilities. In the inspected 0.18 schema, regular-arrow bindings use `elementId`, `focus`, and `gap`; elbow bindings additionally carry `fixedPoint`, and elbow arrows need their own routing fields. A `fixedPoint`-only shorthand object is not a complete native binding.

Maintain reciprocal `boundElements` on both endpoints yourself when generating native files. Do not assume a converter repairs them: inspect its result and validate. When library instances are cloned, remap ALL IDs and references (arrow endpoints, bound text, container, groups, and frames) together.

For external regular-arrow connections in this tested version, use a positive gap (the pilots use `1`). `gap: 0` with `focus: 0` repositions an endpoint to the shape center during movement. For multipoint arrows, keep the adjacent route point outside the connected shape with enough clearance for resizing; an adjacent point swallowed by a resized box can also pull the endpoint inside. Test the post-resize geometry, not merely retained IDs. Ordinary polylines may become diagonal after movement; use native elbow arrows with their full schema when orthogonal rerouting is required.

## Repairing detached arrows

Read the original file. Determine the intended endpoints from existing references and labels; geometry is supporting evidence. Preserve arrow IDs where practical. Restore both endpoint bindings and reciprocal references; normalize with the target editor if supported. For ambiguous endpoints, retain the edge and flag it for clarification rather than attaching it to the nearest box by guess.

## Verification levels

| Level | Evidence | Allowed claim |
| --- | --- | --- |
| Payload | Input parses, IDs and reference structure valid | Binding structure checked |
| Saved result | Exported native scene has valid endpoints and reciprocal references | Saved bindings checked |
| Editor behavior | Independently drag source and target; resize; save/reopen and move again | Attachment behavior verified in the tested editor/version |

If a check is unavailable, mark it pending. A screenshot proves appearance only. If conversion drops bindings, stop claiming success and provide the native scene or a supported adapter; changing the MCP server itself requires task scope to include that work.
