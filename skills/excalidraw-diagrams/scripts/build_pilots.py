"""Rebuild the illustrative native scenes, MCP inputs, SVG previews and library.

Run from anywhere: python3 /path/to/skill/scripts/build_pilots.py
SVG previews are deterministic schematic previews, not Excalidraw renderer output.
"""

import copy
import html
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INK = "#1e1e1e"
BLUE, YELLOW, GREEN, RED, GRAY = "#a5d8ff", "#fff3bf", "#b2f2bb", "#ffc9c9", "#f1f3f5"


class Scene:
    def __init__(self, title, subtitle):
        self.elements = []
        self.text("title", title, 48, 32, 32)
        self.text("scope", subtitle, 48, 80, 16)

    def base(self, name, kind, x, y, w, h, fill="transparent"):
        element = dict(
            id=name,
            type=kind,
            x=x,
            y=y,
            width=w,
            height=h,
            angle=0,
            strokeColor=INK,
            backgroundColor=fill,
            fillStyle="solid",
            strokeWidth=2,
            strokeStyle="solid",
            roughness=1,
            opacity=100,
            groupIds=[],
            frameId=None,
            index=None,
            roundness=None,
            seed=len(self.elements) + 1,
            version=1,
            versionNonce=len(self.elements) + 100,
            isDeleted=False,
            boundElements=[],
            updated=1,
            link=None,
            locked=False,
        )
        self.elements.append(element)
        return element

    def text(self, name, text, x, y, size=20, container=None):
        lines = text.split("\n")
        width = max(len(s) for s in lines) * size * 0.58
        height = len(lines) * size * 1.25
        element = self.base(name, "text", x, y, width, height)
        element.update(
            text=text,
            originalText=text,
            fontSize=size,
            fontFamily=5,
            textAlign="center" if container else "left",
            verticalAlign="middle",
            containerId=container,
            autoResize=True,
            lineHeight=1.25,
        )
        return element

    def box(self, name, label, x, y, w=192, h=80, fill=BLUE, kind="rectangle"):
        element = self.base(name, kind, x, y, w, h, fill)
        if kind == "rectangle":
            element["roundness"] = {"type": 3}
        if label:
            txt = self.text(name + "-label", label, 0, 0, container=name)
            txt["x"] = x + (w - txt["width"]) / 2
            txt["y"] = y + (h - txt["height"]) / 2
            element["boundElements"].append({"id": txt["id"], "type": "text"})
        return element

    def edge(self, name, source, target, points, label="", label_at=None):
        x, y = points[0]
        relative = [[px - x, py - y] for px, py in points]
        element = self.base(
            name,
            "arrow",
            x,
            y,
            max(p[0] for p in points) - min(p[0] for p in points),
            max(p[1] for p in points) - min(p[1] for p in points),
        )
        element.update(
            points=relative,
            startArrowhead=None,
            endArrowhead="arrow",
            elbowed=False,
            lastCommittedPoint=None,
            # Excalidraw 0.18 treats gap=0 as an interior binding:
            # with focus=0 a dragged endpoint can move to the center.
            # A positive gap requests an external border attachment.
            startBinding={"elementId": source, "focus": 0, "gap": 1},
            endBinding={"elementId": target, "focus": 0, "gap": 1},
        )
        for target_id in (source, target):
            node = next(e for e in self.elements if e["id"] == target_id)
            node["boundElements"].append({"id": name, "type": "arrow"})
        if label:
            lx, ly = label_at
            txt = self.text(name + "-label", label, lx, ly, 16, container=name)
            element["boundElements"].append({"id": txt["id"], "type": "text"})
        return element

    def save(self, slug):
        scene = dict(
            type="excalidraw",
            version=2,
            source="excalidraw-diagrams skill",
            elements=self.elements,
            appState={"viewBackgroundColor": "#ffffff", "gridSize": 8},
            files={},
        )
        folder = ROOT / "examples"
        folder.mkdir(parents=True, exist_ok=True)
        (folder / f"{slug}.excalidraw").write_text(json.dumps(scene, indent=2) + "\n")
        mcp = [{"type": "cameraUpdate", "x": 0, "y": 0, "width": 1200, "height": 900}]
        for e in self.elements:
            if e["type"] == "text" and e.get("containerId"):
                continue
            raw = {
                k: copy.deepcopy(e[k])
                for k in (
                    "id",
                    "type",
                    "x",
                    "y",
                    "width",
                    "height",
                    "strokeColor",
                    "backgroundColor",
                    "strokeWidth",
                    "roughness",
                    "roundness",
                )
            }
            # Preserve shape-side references, and supply converter skeleton
            # start/end below: Excalidraw 0.18 drops raw arrow binding fields.
            # Label text is regenerated by the MCP, so preserve arrow refs only.
            raw["boundElements"] = [b for b in e["boundElements"] if b["type"] == "arrow"]
            if e["type"] == "text":
                raw.update(text=e["text"], fontSize=e["fontSize"], fontFamily=5)
            elif e["type"] == "arrow":
                raw.update(points=e["points"], startArrowhead=None, endArrowhead="arrow")
                for key in ("startBinding", "endBinding"):
                    raw[key] = e[key]
                raw["start"] = {"id": e["startBinding"]["elementId"]}
                raw["end"] = {"id": e["endBinding"]["elementId"]}
            label = next((t for t in self.elements if t.get("containerId") == e["id"]), None)
            if label:
                raw["label"] = {"text": label["text"], "fontSize": label["fontSize"]}
            mcp.append(raw)
        (folder / f"{slug}.mcp.json").write_text(json.dumps(mcp, indent=2) + "\n")
        (folder / f"{slug}.svg").write_text(self.svg())
        return scene

    def svg(self):
        parts = [
            '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 900" '
            'width="1200" height="900">',
            '<rect width="1200" height="900" fill="white"/>',
            '<defs><marker id="arrow" markerWidth="10" markerHeight="8" '
            'refX="9" refY="4" orient="auto"><path d="M0,0 L9,4 L0,8" '
            'fill="none" stroke="#1e1e1e" stroke-width="1.5"/></marker></defs>',
        ]
        for e in self.elements:
            x, y, w, h = e["x"], e["y"], e["width"], e["height"]
            fill = e["backgroundColor"] if e["backgroundColor"] != "transparent" else "none"
            attrs = f'fill="{fill}" stroke="{INK}" stroke-width="2"'
            if e["type"] == "rectangle":
                parts.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="12" {attrs}/>')
            elif e["type"] == "diamond":
                parts.append(
                    f'<polygon points="{x + w / 2},{y} {x + w},{y + h / 2} '
                    f'{x + w / 2},{y + h} {x},{y + h / 2}" {attrs}/>'
                )
            elif e["type"] == "ellipse":
                parts.append(
                    f'<ellipse cx="{x + w / 2}" cy="{y + h / 2}" '
                    f'rx="{w / 2}" ry="{h / 2}" {attrs}/>'
                )
            elif e["type"] == "arrow":
                points = " ".join(f"{x + p[0]},{y + p[1]}" for p in e["points"])
                parts.append(
                    f'<polyline points="{points}" fill="none" stroke="{INK}" '
                    'stroke-width="2" marker-end="url(#arrow)"/>'
                )
            elif e["type"] == "text":
                # Positions approximate bounds; native font rendering is a separate check.
                parts.append(
                    f'<text x="{x}" y="{y + e["fontSize"]}" fill="{INK}" '
                    f'font-size="{e["fontSize"]}" font-family="sans-serif">'
                )
                for i, line in enumerate(e["text"].split("\n")):
                    parts.append(
                        f'<tspan x="{x}" dy="{0 if i == 0 else e["fontSize"] * 1.25}">'
                        f"{html.escape(line)}</tspan>"
                    )
                parts.append("</text>")
        parts.append("</svg>")
        return "\n".join(parts) + "\n"


def build():
    payment = Scene(
        "Payment lifecycle · state machine",
        "Illustrative model only · one payment · retry policy unspecified",
    )
    payment.box("initial", "", 48, 208, 24, 24, INK, "ellipse")
    payment.box("pending", "Pending", 144, 184)
    payment.box("paid", "Paid", 480, 184, fill=GREEN)
    payment.box("refunded", "Refunded", 864, 184)
    payment.box("failed", "Failed", 144, 448, fill=RED)
    payment.edge("begin", "initial", "pending", [(72, 220), (144, 220)])
    payment.edge("authorize", "pending", "paid", [(336, 224), (480, 224)], "authorized", (360, 192))
    payment.edge(
        "refund", "paid", "refunded", [(672, 224), (864, 224)], "refund confirmed", (692, 192)
    )
    payment.edge("decline", "pending", "failed", [(240, 264), (240, 448)], "declined", (256, 344))
    retry = payment.edge(
        "retry",
        "failed",
        "pending",
        [(144, 488), (96, 488), (96, 352), (192, 352), (192, 264)],
        "retry requested",
        (48, 536),
    )
    # Bottom-left half port: (center_x - endpoint_x) / (width / 2).
    # The positive focus preserves the off-center approach on the bottom side.
    retry["endBinding"]["focus"] = 0.5
    payment.text(
        "terminal-note",
        "Refunded is terminal within this view.\n"
        "Retry is preserved; no attempt limit or new-attempt semantics are assumed.",
        448,
        448,
        16,
    )
    payment.text(
        "legend",
        "Legend: blue = ordinary state · green = success · red = failure\n"
        "Solid arrows = transitions; labels name triggering events.",
        48,
        656,
        16,
    )
    payment_scene = payment.save("payment-state-machine")

    approval = Scene(
        "Approval process · branching flow",
        "Illustrative model only · manager review and resubmission",
    )
    approval.box("submitted", "Submitted", 48, 296)
    approval.box("review", "Review\noutcome?", 384, 240, 208, 192, YELLOW, "diamond")
    approval.box("approved", "Approved", 864, 160, fill=GREEN)
    approval.box("rejected", "Rejected", 864, 432, fill=RED)
    approval.box("revise", "Revise request", 384, 608, fill=GRAY)
    approval.edge("submit", "submitted", "review", [(240, 336), (384, 336)], "submit", (280, 304))
    approval.edge(
        "approve",
        "review",
        "approved",
        [(488, 240), (488, 200), (864, 200)],
        "approved",
        (672, 168),
    )
    approval.edge(
        "reject",
        "review",
        "rejected",
        [(592, 336), (720, 336), (720, 472), (864, 472)],
        "rejected",
        (760, 440),
    )
    approval.edge(
        "needs-info", "review", "revise", [(488, 432), (488, 608)], "needs information", (512, 520)
    )
    approval.edge(
        "resubmit",
        "revise",
        "submitted",
        [(384, 648), (144, 648), (144, 376)],
        "resubmit",
        (208, 616),
    )
    approval.text(
        "legend",
        "Legend: diamond = decision · blue = ordinary step · green/red = outcomes\n"
        "Every decision exit is explicit; the loop returns the revised request for review.",
        48,
        768,
        16,
    )
    approval.save("approval-flow")

    architecture = Scene(
        "Asynchronous job processing · architecture",
        "Illustrative container view · delivery, retry and result retrieval policies unspecified",
    )
    architecture.box("browser", "Browser\n[Client]", 48, 184, fill=GRAY)
    architecture.box("api", "Job API\n[Service]", 480, 184)
    architecture.box("queue", "Job queue\n[Queue]", 864, 184, fill=GRAY)
    architecture.box("worker", "Job worker\n[Service]", 864, 488)
    architecture.box("store", "Job store\n[Datastore]", 480, 488, fill=GRAY)
    architecture.edge(
        "request", "browser", "api", [(240, 224), (480, 224)], "submit job", (304, 192)
    )
    architecture.edge(
        "enqueue", "api", "queue", [(672, 224), (864, 224)], "enqueue job", (704, 192)
    )
    architecture.edge(
        "deliver", "queue", "worker", [(960, 264), (960, 488)], "deliver job (async)", (768, 368)
    )
    architecture.edge(
        "persist", "worker", "store", [(864, 528), (672, 528)], "persist result", (696, 496)
    )
    architecture.text(
        "boundary-note",
        "Scope: logical components; deployment and ownership boundaries are not specified.",
        48,
        656,
        16,
    )
    architecture.text(
        "legend",
        "Legend: blue = ordinary component · gray = actor or passive resource\n"
        "Solid directed arrows = named interactions; async is explicit in the label.\n"
        "Acceptance is not job completion; completion delivery to the client is outside this view.",
        48,
        712,
        16,
    )
    architecture.save("service-architecture")

    library_scene = Scene("", "")
    library_scene.elements = []
    for name, label, fill, kind, w, h in [
        ("action", "Action", BLUE, "rectangle", 192, 80),
        ("decision", "Condition?", YELLOW, "diamond", 208, 192),
        ("success", "Success", GREEN, "rectangle", 192, 80),
        ("failure", "Failure", RED, "rectangle", 192, 80),
        ("resource", "Resource", GRAY, "rectangle", 192, 80),
    ]:
        library_scene.box(name, label, 0, 0, w, h, fill, kind)
    items = []
    for e in library_scene.elements:
        if e["type"] in {"rectangle", "diamond"}:
            group = [copy.deepcopy(e)] + [
                copy.deepcopy(t) for t in library_scene.elements if t.get("containerId") == e["id"]
            ]
            items.append(
                {
                    "id": "component-" + e["id"],
                    "status": "unpublished",
                    "created": 0,
                    "elements": group,
                }
            )
    assets = ROOT / "assets"
    assets.mkdir(exist_ok=True)
    (assets / "components.excalidrawlib").write_text(
        json.dumps(
            {
                "type": "excalidrawlib",
                "version": 2,
                "source": "excalidraw-diagrams skill",
                "libraryItems": items,
            },
            indent=2,
        )
        + "\n"
    )
    return payment_scene


if __name__ == "__main__":
    build()
    print(
        "Built three illustrative scenes, MCP inputs, schematic SVG previews, "
        "and component library."
    )
