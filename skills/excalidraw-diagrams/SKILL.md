---
name: excalidraw-diagrams
description: Use when creating, editing, reviewing, or restyling Excalidraw diagrams, .excalidraw files, flowcharts, state machines, architecture views, or sequence diagrams, especially with inconsistent styles, ambiguous decisions, overlapping labels, or arrows that detach when boxes move.
---

# Excalidraw diagrams

Preserve meaning before polishing appearance. A relationship arrow is a bound connection between entities, not a line that happens to touch them.

## Workflow

1. Identify audience, scope, diagram family, and evidence. Read an existing scene before editing. Preserve its nodes, edges, events, guards, retry policy, and IDs during a restyle. If a relationship is ambiguous, retain it and mark its meaning unconfirmed; never fill missing behavior from convention.
2. Resolve whether the diagram is work or personal before choosing a durable artifact path. Work diagrams belong in the **Work second-brain** at `~/Projects/Work/Github/second-brain/brain/notes/diagrams/`; personal diagrams belong in the **Personal AI Brain** at `~/Projects/Personal/Github/ai-brain/`, never in the Work second-brain by default. Inspect the selected repository's `AGENTS.md`, index, and placement conventions first. The Personal AI Brain does not currently have an established diagrams folder; follow its instructions and propose a suitable location before writing there. If context does not clearly resolve work vs personal, ask before saving. For Work diagrams, use these context folders:
   - Repository-specific: `repos/<repo-slug>/<diagram-slug>.excalidraw`
   - Cross-repository feature: `features/<feature-slug>/<diagram-slug>.excalidraw`
   - Coordinated workspace initiative: `workspaces/<workspace-slug>/<diagram-slug>.excalidraw`
   Use the clearest primary context; for work spanning repositories, prefer `features/` when it has its own lifecycle and `workspaces/` for a broader coordinated initiative. If the context remains unclear and changes the destination, ask before saving. Read [the diagrams index](~/Projects/Work/Github/second-brain/brain/notes/diagrams/README.md) for naming and companion-file conventions.
3. Give the native file a short, lowercase kebab-case name that describes its subject and view, such as `checkout-order-creation-flow.excalidraw`. Save the native scene by default when creating a diagram; an MCP-rendered view is a preview and does not replace the file. Keep useful previews or source inputs beside the scene, using the same basename. Do not save durable diagrams in the current working directory, a temporary folder, or the skill's examples folder.
4. Load [design system](references/design-system.md) and the relevant section of [diagram logic](references/diagram-logic.md). Produce a compact node/edge model before coordinates. Separate mixed abstraction levels into linked views.
5. Read the active MCP's tool help/format guide once. Follow [MCP and binding guidance](references/mcp-bindings.md); distinguish shorthand tool input from native scene JSON. Use only capabilities actually exposed.
6. Compose nodes and labels, then route connectors through reserved space. Use the shared tokens exactly. Read [library recipes](references/libraries.md) when reusing components.
7. For EVERY relationship arrow, bind both ends to their intended shapes, with reciprocal native references. Use positive gaps for external regular-arrow bindings; keep approach points outside shapes. Validate saved output and post-resize geometry. Decorative lines are separate elements.
8. Apply the [review checklist](references/review-checklist.md). Render and inspect the whole scene and readable details. Move each connected shape independently, resize, save/reopen, and repeat the attachment check when an editor is available. A screenshot or valid JSON does not prove attachment.
9. Show the rendered preview in the current chat whenever the active MCP and agentic client can display it. Use the MCP's view/render tool on the saved scene, then return its view through the client's display mechanism (for example, the returned MCP app view or image content). Confirm the preview is actually user-visible before reporting it as shown. When the current client cannot display the MCP result, use its best available preview mechanism and say what remains unavailable; keep the native artifact as the source of truth.
10. Deliver the artifact and the report contract below. If rendering or editor interaction is unavailable, mark that check pending and identify the limitation.

## Quick reference

| Concern | Required choice |
| --- | --- |
| Tokens | White canvas, dark text/strokes, font 5, title32/node20/note16, stroke2/roughness1 |
| Meaning | Blue ordinary; yellow decision; green success; red failure; gray structural |
| Logic | Events/guards explicit; decision exits labeled; unknowns marked |
| Attachment | Two endpoint bindings plus reciprocal native references |
| Existing diagrams | Separate cosmetic edits from proposed semantic corrections |

## Delivery contract

- Artifact paths or actual returned MCP view.
- Preview: shown in the current chat, or pending with the client limitation stated.
- Diagram type, scope, and assumptions; flag illustrative examples.
- Logic review: preserved/changed behavior, unresolved conditions, retry/timeout policy.
- Visual review: inspected render, readability, overlaps and connector routing.
- Binding review: structure checked; source/target drag, resize and reopen each passed or pending.

## Common mistakes

- Inferring “retry creates a new attempt”: keep the observed transition and mark entity/policy unknown.
- Coloring a worker green for decoration: green is reserved for successful outcomes.
- Drawing endpoints at box borders: use bindings and test independent movement.
- Deleting cycles or branches for neatness: preserve meaning and reorganize the view.
- Reporting “validated” after a tool accepts JSON: name the checks actually performed.

Use [migration guidance](references/migration.md) for existing collections and [pilot examples](examples/) as illustrative starting points.
