# Restyling existing diagrams

1. Read the original scene and identify the modeled entity, scope and family. Preserve a copy or work in a new output file.
2. Inventory node IDs and labels, edge IDs/source/target/direction/labels, guards, loops, notes, groups and boundaries. Record ambiguous relationships explicitly.
3. Separate appearance edits from semantic corrections. Preserve evidenced behavior, even if unusual. A retry limit, entity split, missing branch or inferred terminal state is a proposed model change, not a cosmetic fix.
4. Apply tokens and typography; fit text by growing shapes. Reposition nodes, then route and bind arrows. Keep IDs stable when editing existing scenes.
5. Compare the before/after node and edge inventories. All semantic differences must be explained; do not silently drop branches, notes or links.
6. Validate binding references and render. Move each connected shape independently, resize, save/reopen, and repeat attachment checks. Report pending checks honestly.

Pilot a state machine, branching flowchart and architecture view before migrating a collection. Approve the visual defaults against those examples, then batch only diagrams with understood meanings. Keep domain-specific facts in their owning projects, not in this general skill.
