#!/usr/bin/env python3
from __future__ import annotations
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PAIRS = [
    ("README", ROOT / "README.md", ROOT / "README.tr.md"),
    ("START_HERE", ROOT / "START_HERE.md", ROOT / "START_HERE.tr.md"),
    ("USAGE", ROOT / "USAGE.md", ROOT / "USAGE.tr.md"),
    ("AGENTS", ROOT / "AGENTS.md", ROOT / "AGENTS.tr.md"),
    ("ONE_PAGE_QUICKSTART", ROOT / "ONE_PAGE_QUICKSTART.md", ROOT / "ONE_PAGE_QUICKSTART.tr.md"),
    ("OPERATIONS_RUNBOOK", ROOT / "OPERATIONS_RUNBOOK.md", ROOT / "OPERATIONS_RUNBOOK.tr.md"),
    ("INDEX", ROOT / "INDEX.md", ROOT / "INDEX.tr.md"),
]

REQ_EN = ["doc_id", "lang", "source_of_truth", "version", "last_updated", "sync_group", "translation_of", "sync_status"]
REQ_TR = REQ_EN + ["last_aligned"]
VALID_STATUSES = {"canonical", "aligned", "minor-drift", "major-drift", "partial", "deprecated"}
INLINE_RE = re.compile(r"`([^`]+)`")
HEADING_RE = re.compile(r"^(##|###)\s+(.+)$", re.MULTILINE)


def parse_frontmatter(text: str) -> dict[str, str]:
    if not text.startswith("---\n"):
        return {}
    end = text.find("\n---\n", 4)
    if end == -1:
        return {}
    block = text[4:end].strip().splitlines()
    data = {}
    for line in block:
        if ':' not in line:
            continue
        k, v = line.split(':', 1)
        data[k.strip()] = v.strip()
    return data


def headings(text: str):
    return [m.group(1) + ' ' + m.group(2).strip() for m in HEADING_RE.finditer(text)]


def inline_tokens(text: str):
    return sorted(set(INLINE_RE.findall(text)))


def check_pair(name: str, en_path: Path, tr_path: Path):
    issues = []
    if not en_path.exists() or not tr_path.exists():
        return f"{name}: translation-missing", [f"missing pair: en={en_path.exists()} tr={tr_path.exists()}"]

    en_text = en_path.read_text(encoding='utf-8')
    tr_text = tr_path.read_text(encoding='utf-8')
    en_meta = parse_frontmatter(en_text)
    tr_meta = parse_frontmatter(tr_text)

    for key in REQ_EN:
        if key not in en_meta:
            issues.append(f"EN missing metadata: {key}")
    for key in REQ_TR:
        if key not in tr_meta:
            issues.append(f"TR missing metadata: {key}")

    if en_meta.get('doc_id') != name:
        issues.append(f"EN doc_id mismatch: expected {name}, got {en_meta.get('doc_id')}")
    if tr_meta.get('doc_id') != name:
        issues.append(f"TR doc_id mismatch: expected {name}, got {tr_meta.get('doc_id')}")
    if en_meta.get('lang') != 'en':
        issues.append(f"EN lang should be en, got {en_meta.get('lang')}")
    if tr_meta.get('lang') != 'tr':
        issues.append(f"TR lang should be tr, got {tr_meta.get('lang')}")
    if en_meta.get('source_of_truth') != 'true':
        issues.append(f"EN source_of_truth should be true, got {en_meta.get('source_of_truth')}")
    if tr_meta.get('source_of_truth') != 'false':
        issues.append(f"TR source_of_truth should be false, got {tr_meta.get('source_of_truth')}")
    if tr_meta.get('translation_of') != en_path.name:
        issues.append(f"TR translation_of should be {en_path.name}, got {tr_meta.get('translation_of')}")
    if en_meta.get('version') != tr_meta.get('version'):
        issues.append(f"version mismatch: EN={en_meta.get('version')} TR={tr_meta.get('version')}")
    if en_meta.get('sync_group') != tr_meta.get('sync_group'):
        issues.append(f"sync_group mismatch: EN={en_meta.get('sync_group')} TR={tr_meta.get('sync_group')}")
    if en_meta.get('sync_status') not in VALID_STATUSES:
        issues.append(f"invalid EN sync_status: {en_meta.get('sync_status')}")
    if tr_meta.get('sync_status') not in VALID_STATUSES:
        issues.append(f"invalid TR sync_status: {tr_meta.get('sync_status')}")

    en_heads = headings(en_text)
    tr_heads = headings(tr_text)
    if len(en_heads) != len(tr_heads):
        issues.append(f"heading-count mismatch: EN={len(en_heads)} TR={len(tr_heads)}")

    en_tokens = inline_tokens(en_text)
    tr_tokens = inline_tokens(tr_text)
    missing_tokens = [t for t in en_tokens if t not in tr_tokens]
    if missing_tokens:
        issues.append("missing inline tokens in TR: " + ', '.join(missing_tokens[:10]))

    if not issues:
        return f"{name}: aligned", []
    return f"{name}: minor-drift", issues


def main():
    results = []
    failures = 0
    for name, en_path, tr_path in PAIRS:
        status, issues = check_pair(name, en_path, tr_path)
        results.append((status, issues))
        if issues:
            failures += 1
    print("# Parity Validation Report")
    print()
    for status, issues in results:
        print(status)
        for issue in issues:
            print(f"  - {issue}")
    print()
    print(f"pairs_checked: {len(PAIRS)}")
    print(f"pairs_with_issues: {failures}")
    sys.exit(1 if failures else 0)

if __name__ == '__main__':
    main()
