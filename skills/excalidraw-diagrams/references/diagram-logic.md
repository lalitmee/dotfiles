# Diagram-specific logic

Choose a family before drawing. The same visual tokens span families; notation retains its declared meaning within each family. These are lightweight conventions, not a claim of complete UML or BPMN conformance.

## State machines

Required model: entity, scope, states, initial state if known, transitions with source/target/event/guard/action, terminal states within scope, unknowns.

- State names describe conditions: `Pending`, `Paid`. Transition labels describe events: `authorized [amount matches] / record payment`.
- Preserve the entity model. A retry may change state or create an attempt: use evidence to choose. If unspecified, label policy unknown; do not invent limits, backoff, idempotency, or new entities.
- Use rounded cards for states, a filled initial circle and a final bullseye for termination of the modeled lifecycle. A successful state need not be terminal; `Paid` can transition to `Refunded`.
- Show timeouts, cancellation, failures and retries when evidenced or required by the brief. Mark missing policies explicitly. Do not add transitions merely to make the machine “complete.”
- Branching transitions need guards that distinguish outcomes. Check overlapping guards, unreachable states, conflicting events, and transitions out of terminal states.
- Separate orthogonal regions or composite states only when concurrency/hierarchy is evidenced. A loop is valid; do not force state machines into trees.

## Flowcharts and decisions

Required model: trigger/input, verb-named actions, predicates, labeled outcomes, loops and exits, unknowns.

- Rectangles denote actions, diamonds denote decisions, rounded terminators denote start/end. Label the diagram as a flowchart so rounded states and terminators are not confused.
- Every decision exit has a condition: `Yes`/`No`, named outcomes, or guards. Outcomes should cover the modeled domain; specify priority when guards overlap. Mark uncovered/unknown outcomes instead of guessing.
- Separate an information request from resubmission when the distinction matters. Draw the return path explicitly.
- A decision is not a parallel fork. Show parallel branches and their join condition with an explicit legend or use a better-suited diagram family.
- Retry loops expose stop conditions where known; flag unbounded or unspecified retry policies.

## Architecture

Required model: declared abstraction level, actors/components, responsibilities, boundaries, directed labeled relationships, known protocols, unknowns.

- Choose context, container/service, component, or deployment level. Keep code-level detail in a separate view.
- Use typed labels and concise responsibilities. Show system/trust/ownership boundaries where relevant and supported.
- Relationship labels state intent and direction: `enqueue job (async)` or `read/write records`. Include protocol only if known. Separate request direction from data direction when needed.
- A queue does not establish delivery guarantees, ordering, acknowledgments, retries, or exactly-once execution. Mark these unknown until evidenced.
- Async acceptance is not completion. Include response/result paths only when known; document omitted paths as scope limits.

## Sequence diagrams

Required model: participants, top-to-bottom message order, request/response or async events, alternatives, loops, concurrency if known.

- Keep participant columns stable. Lifelines are non-relationship lines, not pretend connections between services.
- Bind message arrows to participant/lifeline shapes supported by the editor. A plain line may not be a bindable target: use narrow transparent bindable lifeline shapes or another supported representation; verify movement.
- Label messages and explicitly distinguish replies and async sends in the legend. Use `alt`/`else`, `loop`, and `par` regions with conditions.
- Horizontal order does not imply runtime sequence. Avoid inventing timing, retries, or acknowledgments.

## Model example

```text
Entity: illustrative payment lifecycle (not a production contract)
Pending -> Paid: authorized
Pending -> Failed: declined
Failed -> Pending: retry requested; retry/entity policy unspecified
Paid -> Refunded: refund confirmed
Terminal within this scope: Refunded
```

Use the model to check the drawing: every relationship must map to one modeled edge with the correct label, direction and endpoints.
