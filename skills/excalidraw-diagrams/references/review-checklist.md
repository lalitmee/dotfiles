# Review checklist

Report each category as passed, failed, or pending with evidence. “Rendered” and “move-tested” are different checks.

## Logic

- [ ] Type, audience, scope and modeled entity are stated.
- [ ] Nodes, direction and relationships match the source model.
- [ ] Unknowns are marked; illustrative examples are identified.
- [ ] Decisions have labeled outcomes; guard overlaps and uncovered outcomes are addressed.
- [ ] State names describe states; transitions carry events and relevant guards/actions.
- [ ] Initial/terminal states, reachability, loops, retry/timeout policy and concurrency are checked where applicable.
- [ ] Architecture level and boundary meanings are consistent; async is not mistaken for completion.
- [ ] Cosmetic edits preserve existing semantics; corrections are explicit proposals.

## Structure and attachment

- [ ] Unique IDs; no dangling references or deleted binding targets.
- [ ] Every relationship arrow has the intended source AND target binding.
- [ ] Each native endpoint shape reciprocally lists the arrow in `boundElements`.
- [ ] Bound label/container references are reciprocal.
- [ ] Endpoints meet intended border ports; routes clear unrelated objects.
- [ ] External regular-arrow bindings use positive gaps; adjacent route points stay outside shapes during resize.
- [ ] Independently drag EVERY connected shape horizontally and vertically; all incident endpoints follow.
- [ ] Resize connected shapes and confirm endpoint border geometry as well as retained binding IDs.
- [ ] Save/export, reopen in the target editor, and repeat source/target movement.
- [ ] Inspect the saved artifact after conversion; payload-only checks are identified as such.

Run `python3 scripts/validate_scene.py examples/*.excalidraw` from the skill directory for structural checks. Read its documented limitations. A passing static validator does not replace editor behavior checks.

## Appearance

- [ ] Actual overview and detail renders inspected at ordinary reading size.
- [ ] Shared palette, font sizes, strokes and spacing applied; no clipped text.
- [ ] No accidental overlaps, connectors through unrelated nodes, or label collisions.
- [ ] Branches and returns have clear routes and readable labels.
- [ ] Title, scope and legend are present; color is not the sole signal.
- [ ] Group headings and background boundaries do not obscure content.

## Delivery record

```text
Artifact:
Type / scope:
Assumptions and unknowns:
Logic review: passed / failed / pending — evidence
Visual review: passed / failed / pending — inspected render
Binding structure: passed / failed / pending — saved file or payload
Source/target movement: passed / failed / pending — editor/version
Resize and reopen: passed / failed / pending — editor/version
Remaining issues:
```
