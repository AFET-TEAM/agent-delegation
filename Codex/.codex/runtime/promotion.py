from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import List, Tuple
import difflib
import json


@dataclass
class PromotionCandidate:
    relative_target: str
    mirror_path: str
    diff_path: str
    approval_required: bool


def build_diff_for_pair(root: Path, run_root: Path, mirror_rel: str) -> Tuple[str, str]:
    mirror_path = run_root / mirror_rel
    target_rel = mirror_rel.removeprefix('workspace-mirror/')
    target_path = root / target_rel
    before = target_path.read_text(encoding='utf-8').splitlines(keepends=True) if target_path.exists() else []
    after = mirror_path.read_text(encoding='utf-8').splitlines(keepends=True) if mirror_path.exists() else []
    diff = ''.join(difflib.unified_diff(before, after, fromfile=str(target_rel), tofile=f'{target_rel} (mirror)'))
    return target_rel, diff


def collect_promotion_candidates(root: Path, run_root: Path) -> List[PromotionCandidate]:
    mirror_root = run_root / 'workspace-mirror'
    if not mirror_root.exists():
        return []
    diff_root = run_root / 'diffs'
    diff_root.mkdir(parents=True, exist_ok=True)
    candidates: List[PromotionCandidate] = []
    for path in sorted(mirror_root.rglob('*')):
        if not path.is_file():
            continue
        mirror_rel = str(path.relative_to(run_root))
        target_rel, diff = build_diff_for_pair(root, run_root, mirror_rel)
        diff_name = target_rel.replace('/', '__') + '.diff'
        diff_path = diff_root / diff_name
        diff_path.write_text(diff or '# no diff\n', encoding='utf-8')
        candidates.append(PromotionCandidate(
            relative_target=target_rel,
            mirror_path=mirror_rel,
            diff_path=str(diff_path.relative_to(run_root)),
            approval_required=True,
        ))
    manifest = [c.__dict__ for c in candidates]
    (run_root / 'promotion-candidates.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
    return candidates


def render_approval_summary(candidates: List[PromotionCandidate]) -> str:
    lines = ['# Promotion Approval Summary', '']
    if not candidates:
        lines += ['- no promotion candidates']
        return '\n'.join(lines)
    lines += ['The following mirror artifacts are ready for optional promotion after human approval:', '']
    for c in candidates:
        lines.append(f'- target: {c.relative_target} | mirror: {c.mirror_path} | diff: {c.diff_path} | approval_required: yes')
    return '\n'.join(lines)
