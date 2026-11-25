"""Check native Excalidraw scene structure and conservative geometry.

Run: python3 scripts/validate_scene.py examples/*.excalidraw
Static checks cannot establish editor drag behavior or visual readability.
For ordinary external relationship arrows, positive binding gaps are required:
Excalidraw 0.18 treats zero-gap bindings as interior focus-point attachments.
"""

import copy
import json
import math
import sys
from pathlib import Path

PALETTE = {
    "transparent",
    "#ffffff",
    "#1e1e1e",
    "#a5d8ff",
    "#fff3bf",
    "#b2f2bb",
    "#ffc9c9",
    "#f1f3f5",
}
SHAPES = {"rectangle", "ellipse", "diamond"}


def overlaps(a, b, inset=0):
    """Whether two axis-aligned bounding boxes have positive intersection."""
    return max(a[0], b[0]) < min(a[2], b[2]) - inset and max(a[1], b[1]) < min(a[3], b[3]) - inset


def bounds(element):
    return (
        element["x"],
        element["y"],
        element["x"] + element["width"],
        element["y"] + element["height"],
    )


def segment_hits_box(p, q, box):
    """Strict interior intersection for the orthogonal pilot routes."""
    x1, y1, x2, y2 = box
    margin = 1
    if abs(p[0] - q[0]) < 0.01:
        return x1 + margin < p[0] < x2 - margin and max(min(p[1], q[1]), y1 + margin) < min(
            max(p[1], q[1]), y2 - margin
        )
    if abs(p[1] - q[1]) < 0.01:
        return y1 + margin < p[1] < y2 - margin and max(min(p[0], q[0]), x1 + margin) < min(
            max(p[0], q[0]), x2 - margin
        )
    return False


def on_border(point, shape, tolerance=2):
    """Approximate the actual rectangle, ellipse or diamond boundary."""
    x, y, w, h = shape["x"], shape["y"], shape["width"], shape["height"]
    if w <= 0 or h <= 0:
        return False
    dx, dy = abs(point[0] - x - w / 2), abs(point[1] - y - h / 2)
    if shape["type"] == "diamond":
        return abs(dx / (w / 2) + dy / (h / 2) - 1) <= tolerance / min(w / 2, h / 2)
    if shape["type"] == "ellipse":
        return abs(math.hypot(dx / (w / 2), dy / (h / 2)) - 1) <= tolerance / min(w / 2, h / 2)
    return (abs(dx - w / 2) <= tolerance and dy <= h / 2 + tolerance) or (
        abs(dy - h / 2) <= tolerance and dx <= w / 2 + tolerance
    )


def validate(scene):
    errors = []
    if scene.get("type") != "excalidraw" or scene.get("version") != 2:
        errors.append("Expected native excalidraw scene version 2")
    elements = [e for e in scene.get("elements", []) if not e.get("isDeleted")]
    ids = [e.get("id") for e in elements]
    if len(ids) != len(set(ids)) or None in ids:
        errors.append("Missing or duplicate element IDs")
    by_id = {e.get("id"): e for e in elements}
    shapes = [
        e for e in elements if e.get("type") in SHAPES and not e.get("customData", {}).get("zone")
    ]
    for e in elements:
        name = e.get("id", "?")
        for field in ("x", "y", "width", "height"):
            if not isinstance(e.get(field), (int, float)) or not math.isfinite(e[field]):
                errors.append(f"{name}: invalid {field}")
        for field in ("strokeColor", "backgroundColor"):
            if e.get(field, "transparent").lower() not in PALETTE:
                errors.append(f"{name}: unsupported {field}")
        if e.get("type") == "text":
            if e.get("fontFamily") != 5 or e.get("fontSize", 0) < 16:
                errors.append(f"{name}: unsupported font or font size")
            parent = e.get("containerId")
            if parent:
                if parent not in by_id:
                    errors.append(f"{name}: missing text container {parent}")
                elif not any(
                    b.get("id") == name and b.get("type") == "text"
                    for b in by_id[parent].get("boundElements", [])
                ):
                    errors.append(f"{name}: no reciprocal text reference")
                elif by_id[parent].get("type") in SHAPES:
                    outer, inner = bounds(by_id[parent]), bounds(e)
                    if not (
                        outer[0] <= inner[0]
                        and outer[1] <= inner[1]
                        and outer[2] >= inner[2]
                        and outer[3] >= inner[3]
                    ):
                        errors.append(f"{name}: text extends beyond container bounding box")
        if e.get("type") == "arrow":
            targets = set()
            for endpoint in ("startBinding", "endBinding"):
                binding = e.get(endpoint)
                if not binding or not binding.get("elementId"):
                    errors.append(f"{name}: missing {endpoint}")
                    continue
                if binding.get("gap") == 0:
                    errors.append(
                        f"{name}: unsafe zero-gap {endpoint}; use a positive external border gap"
                    )
                elif not isinstance(binding.get("gap"), (int, float)) or binding["gap"] < 0:
                    errors.append(f"{name}: invalid external binding gap on {endpoint}")
                target = binding["elementId"]
                targets.add(target)
                if target not in by_id or by_id[target].get("type") not in SHAPES:
                    errors.append(f"{name}: {endpoint} target missing or not a shape: {target}")
                elif not any(
                    b.get("id") == name and b.get("type") == "arrow"
                    for b in by_id[target].get("boundElements", [])
                ):
                    errors.append(f"{name}: no reciprocal arrow reference on {target}")
            points = [(e["x"] + p[0], e["y"] + p[1]) for p in e.get("points", [])]
            if len(points) < 2:
                errors.append(f"{name}: fewer than two points")
            else:
                for binding_key, endpoint in (
                    ("startBinding", points[0]),
                    ("endBinding", points[-1]),
                ):
                    target = by_id.get((e.get(binding_key) or {}).get("elementId"))
                    if target and target.get("type") in SHAPES and not on_border(endpoint, target):
                        errors.append(
                            f"{name}: {binding_key} endpoint is detached from target border"
                        )
            for a, b in zip(points, points[1:]):
                if a[0] != b[0] and a[1] != b[1]:
                    errors.append(f"{name}: non-orthogonal route")
                for shape in shapes:
                    if shape["id"] not in targets and segment_hits_box(a, b, bounds(shape)):
                        errors.append(f"{name}: crosses unrelated shape {shape['id']}")
        for ref in e.get("boundElements", []):
            other = by_id.get(ref.get("id"))
            if not other:
                errors.append(f"{name}: dangling boundElements reference {ref.get('id')}")
            elif ref.get("type") == "arrow" and not any(
                (other.get(k) or {}).get("elementId") == name
                for k in ("startBinding", "endBinding")
            ):
                errors.append(f"{name}: stale reciprocal arrow reference {ref['id']}")
    for i, a in enumerate(shapes):
        for b in shapes[i + 1 :]:
            if overlaps(bounds(a), bounds(b)):
                errors.append(f"Shapes overlap: {a['id']} / {b['id']}")
    return errors


def main():
    if sys.argv[1:] == ["--self-test"]:
        scene = json.loads(
            (
                Path(__file__).resolve().parents[1] / "examples/payment-state-machine.excalidraw"
            ).read_text()
        )
        assert not validate(scene)
        for fault in (
            "startBinding",
            "endBinding",
            "zero-gap",
            "dangling",
            "reciprocal",
            "detached",
            "overlap",
        ):
            damaged = copy.deepcopy(scene)
            arrow = next(e for e in damaged["elements"] if e["type"] == "arrow")
            if fault in {"startBinding", "endBinding"}:
                arrow[fault] = None
                expected = fault
            elif fault == "zero-gap":
                arrow["startBinding"]["gap"] = 0
                expected = "zero-gap"
            elif fault == "dangling":
                arrow["endBinding"]["elementId"] = "missing-shape"
                expected = "missing-shape"
            elif fault == "reciprocal":
                target = next(
                    e for e in damaged["elements"] if e["id"] == arrow["startBinding"]["elementId"]
                )
                target["boundElements"] = []
                expected = "reciprocal"
            elif fault == "detached":
                arrow["x"] += 16
                expected = "detached"
            else:
                shapes = [e for e in damaged["elements"] if e["type"] in SHAPES]
                shapes[1]["x"], shapes[1]["y"] = shapes[0]["x"], shapes[0]["y"]
                expected = "overlap"
            assert any(expected in error for error in validate(damaged)), fault
            print(f"PASS rejects {fault}")
        return 0
    if len(sys.argv) < 2:
        print("Usage: python3 validate_scene.py scene.excalidraw [...] | --self-test")
        return 2
    failed = False
    for filename in sys.argv[1:]:
        try:
            errors = validate(json.loads(Path(filename).read_text()))
        except (OSError, ValueError, KeyError, TypeError) as exc:
            errors = [str(exc)]
        print(f"{'FAIL' if errors else 'PASS'} {filename}")
        for error in errors:
            print(f"  {error}")
        failed |= bool(errors)
    return int(failed)


if __name__ == "__main__":
    sys.exit(main())
