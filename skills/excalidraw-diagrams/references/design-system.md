# Shared design system

Version 1. These are project-neutral defaults for all diagram families. A user-requested theme is an explicit override: document its token mapping and keep meanings consistent across the collection.

## Tokens

| Token | Value | Meaning |
| --- | --- | --- |
| Canvas | `#ffffff` | White |
| Ink | `#1e1e1e` | Text, outlines, relationship arrows |
| Ordinary | `#a5d8ff` | Ordinary state, action, or application node |
| Decision | `#fff3bf` | Branching predicate or choice |
| Success | `#b2f2bb` | Successful outcome |
| Failure | `#ffc9c9` | Failed or rejected outcome |
| Structural | `#f1f3f5` | External actors, queues, stores, boundaries, notes |
| Font | `fontFamily: 5` | Excalifont; use the same font across a collection |
| Type sizes | 32 / 20 / 16 | Title / node and group heading / edge label and annotation |
| Stroke | 2 | Same width for outlines and arrows |
| Roughness | 1 | Restrained consistent hand-drawn appearance |
| Fill | solid, opacity100 | Avoid hatch fills behind text |
| Grid | 8 | Align positions and dimensions |
| Node target | 192 × 80 | Grow to fit; never shrink text to fit |
| Node gap | 64 minimum | Increase for labels and parallel routes |
| Inner / outer padding | 24 / 48 | Keep group headings separate from contents |

Color never supplies the only meaning. Label success/failure explicitly. Component types use text such as `[Service]`, `[Queue]`, `[Data store]`; keep green reserved for success rather than an infrastructure tier. Ordinary lifecycle states are blue unless their outcome meaning calls for another token. Legends explain the actual notation used.

## Composition

- Use left-to-right for simple flows and architecture. Use top-to-bottom when it makes branches clearer. State-machine cycles may return around the perimeter. Sequence time flows downward.
- Give each diagram a type/scope title. Keep overview/detail views separate; retain meaningful cycles and converging edges.
- Equal roles use equal sizes. Wrap labels into short lines and grow shapes to fit. Diamonds require more room than rectangles.
- Default relationship arrows are dark, solid, destination-headed, and bound at both ends. Prefer orthogonal routes with clear ports. A multipoint polyline is not automatically a native elbow arrow; use the active schema.
- Reserve at least 24 px around unrelated nodes/text for connector corridors. Avoid crossings; if unavoidable, reorganize or split views and explain continuation markers.
- Use dashed, arrowless lines only for annotations, with a legend. Async semantics are explicit edge labels, not an unexplained color or dash change.
- Place group headings as standalone text near the top-left, outside node content. Bound text belongs inside its node. Titles and notes must remain readable in the final overview.
- The connected MCP's camera is a rendering constraint, not a universal document aspect ratio. Use its supported padded 4:3 viewport; use multiple detail views rather than scaling text down.

## Acceptance

At ordinary reading size, labels are legible, no text clips, no nodes overlap accidentally, and no arrow crosses an unrelated node or label. Inspect the actual render; numeric checks alone cannot establish visual quality.
