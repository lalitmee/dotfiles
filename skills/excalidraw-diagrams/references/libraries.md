# Components and libraries

Use the bundled `assets/components.excalidrawlib` as a small local, project-neutral starting set. Inspect and normalize new public assets before reuse; retain required attribution and check the source license. Do not add logos purely for decoration.

## Recipes

| Component | Shape and meaning |
| --- | --- |
| Action | Blue rectangle, verb phrase |
| State | Blue rounded rectangle, state name |
| Decision | Yellow diamond, predicate with labeled outgoing edges |
| Success / failure | Green / red outcome with explicit text |
| Service | Blue rectangle, typed label and responsibility |
| Queue / store / actor | Gray typed rectangle; avoid relying on icon recognition |
| Boundary | Subtle gray container with standalone heading |
| Note | Gray note with non-relationship annotation line if needed |

Library assets supply appearance; diagram logic comes from the model. Clone complete components, remapping IDs and every binding reference together. Add relationship arrows after positioning the new instances and bind both ends.

The current two-tool MCP does not expose a dedicated library import tool. Use compatible shape recipes in `create_view`; import `.excalidrawlib` through an editor that supports it. Do not claim an import occurred merely because a component was reconstructed from primitives.

## Sources

- [Official Excalidraw libraries](https://libraries.excalidraw.com/)
- [Official Excalidraw MCP](https://github.com/excalidraw/excalidraw-mcp)
- [C4 notation](https://c4model.com/diagrams/notation)
- [Mermaid state diagrams](https://mermaid.js.org/syntax/stateDiagram.html)
- [Community layout guidance](https://github.com/yctimlin/mcp_excalidraw/blob/main/skills/excalidraw-skill/SKILL.md) — adapt ideas, not server-specific calls.

This skill's palette and dimensions are chosen defaults, not an official Excalidraw standard or a popularity ranking.
