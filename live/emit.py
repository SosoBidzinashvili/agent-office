#!/usr/bin/env python3
"""Emit an event to the live office (status.json). The office (?live=1) polls this.

Usage:
  python3 live/emit.py reset
  python3 live/emit.py user  "ბაზრის გვერდზე ფილტრი"
  python3 live/emit.py orc   "მიმართულება: 🆕 Feature — ვანაწილებ გუნდს"
  python3 live/emit.py start nino   "📝 speც"   "ვწერ user stories + ACs"
  python3 live/emit.py gate  "SPEC ✅"
  python3 live/emit.py gate  "FAIL — ბრუნდება" fail
  python3 live/emit.py done  "✅ SHIPPED — commit abc123"

Agent ids: nino giorgi tamar lela vakho zaza dato mariam beka irakli maestro
"""
import json, os, sys

P = os.path.join(os.path.dirname(os.path.abspath(__file__)), "status.json")

def load():
    try:
        with open(P, encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return {"seq": 0, "events": []}

def save(s):
    with open(P, "w", encoding="utf-8") as f:
        json.dump(s, f, ensure_ascii=False)

def main():
    if len(sys.argv) < 2:
        print(__doc__); sys.exit(1)
    cmd = sys.argv[1]
    a = sys.argv[2:]
    if cmd == "reset":
        save({"seq": 0, "events": [{"type": "reset"}]}); print("reset"); return
    s = load()
    ev = {"type": cmd}
    if cmd in ("user", "orc", "done"):
        ev["text"] = a[0] if a else ""
    elif cmd == "gate":
        ev["text"] = a[0] if a else ""
        if len(a) > 1: ev["kind"] = a[1]
    elif cmd == "start":
        ev["agent"] = a[0] if a else ""
        ev["label"] = a[1] if len(a) > 1 else ""
        ev["text"]  = a[2] if len(a) > 2 else ev["label"]
    else:
        print("unknown command:", cmd); sys.exit(1)
    s["events"].append(ev); s["seq"] = s.get("seq", 0) + 1
    save(s); print("ok seq", s["seq"], "-", cmd, *a)

if __name__ == "__main__":
    main()
