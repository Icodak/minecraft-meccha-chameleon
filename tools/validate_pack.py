#!/usr/bin/env python3
"""Static sanity checker for the Meccha datapack.

Not a full Minecraft parser - it catches the mistakes that actually bite:
  * macro lines (containing $(...)) that forget the leading '$'
  * unbalanced { } [ ] " on a command line
  * `function ns:path` references with no corresponding file
  * advancement `rewards.function` references with no file
"""
from __future__ import annotations
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(ROOT, "data")
errors: list[str] = []
warnings: list[str] = []

func_files: set[str] = set()       # "ns:path"
func_tags: set[str] = set()


def fn_id(ns, rel):
    return f"{ns}:{rel[:-len('.mcfunction')]}"


def scan_files():
    for ns in os.listdir(DATA):
        fdir = os.path.join(DATA, ns, "function")
        if not os.path.isdir(fdir):
            continue
        for dp, _, files in os.walk(fdir):
            for f in files:
                if f.endswith(".mcfunction"):
                    rel = os.path.relpath(os.path.join(dp, f), fdir).replace(os.sep, "/")
                    func_files.add(fn_id(ns, rel))
        tdir = os.path.join(DATA, ns, "tags", "function")
        if os.path.isdir(tdir):
            for dp, _, files in os.walk(tdir):
                for f in files:
                    if f.endswith(".json"):
                        rel = os.path.relpath(os.path.join(dp, f), tdir).replace(os.sep, "/")
                        func_tags.add(f"{ns}:{rel[:-5]}")


def balanced(line: str) -> bool:
    depth = {"{": 0, "[": 0}
    pairs = {"}": "{", "]": "["}
    in_str = False
    esc = False
    quote = None
    for ch in line:
        if in_str:
            if esc:
                esc = False
            elif ch == "\\":
                esc = True
            elif ch == quote:
                in_str = False
            continue
        if ch in ('"', "'"):
            in_str = True
            quote = ch
        elif ch in "{[":
            depth[ch] += 1
        elif ch in "}]":
            depth[pairs[ch]] -= 1
            if depth[pairs[ch]] < 0:
                return False
    return depth["{"] == 0 and depth["["] == 0 and not in_str


FUNC_REF = re.compile(r"\bfunction\s+(#?)([a-z0-9_.-]+:[a-z0-9_./-]+)")


OWNED_NS = "meccha"      # only lint our own code; third-party libs are trusted


def check_functions():
    for ns in os.listdir(DATA):
        if ns != OWNED_NS:              # skip bookshelf / load / minecraft internals
            continue
        fdir = os.path.join(DATA, ns, "function")
        if not os.path.isdir(fdir):
            continue
        for dp, _, files in os.walk(fdir):
            for f in files:
                if not f.endswith(".mcfunction"):
                    continue
                path = os.path.join(dp, f)
                rel = os.path.relpath(path, fdir).replace(os.sep, "/")
                fid = fn_id(ns, rel)
                pending = ""            # accumulate '\'-continued lines
                for i, raw in enumerate(open(path, encoding="utf-8"), 1):
                    line = raw.rstrip("\n")
                    if line.rstrip().endswith("\\"):
                        pending += line.rstrip()[:-1] + " "
                        continue
                    s = (pending + line).strip()
                    pending = ""
                    if not s or s.startswith("#"):
                        continue
                    # macro safety
                    if "$(" in s and not s.startswith("$"):
                        errors.append(f"{fid}:{i} macro '$(...)' without leading '$': {s[:60]}")
                    # balance (strip leading macro '$')
                    chk = s[1:] if s.startswith("$") else s
                    if not balanced(chk):
                        errors.append(f"{fid}:{i} unbalanced brackets/quotes: {s[:70]}")
                    # function references
                    for m in FUNC_REF.finditer(s):
                        is_tag, ref = m.group(1), m.group(2)
                        if "$(" in ref or s[m.end():m.end() + 2] == "$(":
                            continue  # macro-constructed name; can't resolve statically
                        if is_tag:
                            if ref.startswith("bs."):
                                continue  # external Bookshelf tag
                            if ref not in func_tags:
                                warnings.append(f"{fid}:{i} unknown function tag #{ref}")
                        else:
                            if ref.startswith(("bs.", "#")):
                                continue
                            if ref not in func_files:
                                errors.append(f"{fid}:{i} missing function {ref}")


def check_advancements():
    for ns in os.listdir(DATA):
        adir = os.path.join(DATA, ns, "advancement")
        if not os.path.isdir(adir):
            continue
        for dp, _, files in os.walk(adir):
            for f in files:
                if not f.endswith(".json"):
                    continue
                data = json.load(open(os.path.join(dp, f), encoding="utf-8"))
                fnref = data.get("rewards", {}).get("function")
                if fnref and fnref.split(":", 1)[-1] and fnref not in func_files:
                    errors.append(f"advancement {f}: reward function {fnref} missing")


def main():
    scan_files()
    check_functions()
    check_advancements()
    for w in warnings:
        print("WARN ", w)
    for e in errors:
        print("ERROR", e)
    print(f"\n{len(func_files)} functions, {len(func_tags)} tags | "
          f"{len(errors)} errors, {len(warnings)} warnings")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
