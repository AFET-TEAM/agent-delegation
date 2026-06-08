from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List
import re


@dataclass(frozen=True)
class TierSpec:
    tier: str
    role: str
    primary_model: str
    fallbacks: List[str]
    reasoning_effort: str
    reviewer_tier: str | None
    edit_permission: str


DISTROS: Dict[str, Dict[str, int]] = {
    'x1': {'T1': 0, 'T2': 0, 'T3': 0, 'T4': 0, 'T5': 0, 'total': 1},
    'x2': {'T1': 1, 'T2': 0, 'T3': 0, 'T4': 0, 'T5': 1, 'total': 2},
    'x3': {'T1': 1, 'T2': 1, 'T3': 0, 'T4': 0, 'T5': 1, 'total': 3},
    'x4': {'T1': 1, 'T2': 1, 'T3': 1, 'T4': 0, 'T5': 1, 'total': 4},
    'x5': {'T1': 1, 'T2': 1, 'T3': 1, 'T4': 1, 'T5': 1, 'total': 5},
    'x7': {'T1': 1, 'T2': 2, 'T3': 1, 'T4': 1, 'T5': 2, 'total': 7},
    'x10': {'T1': 2, 'T2': 2, 'T3': 2, 'T4': 2, 'T5': 2, 'total': 10},
}

WAVES: List[tuple[str, List[str]]] = [
    ('wave1-discovery', ['T5']),
    ('wave2-consolidation', ['T4']),
    ('wave3-implementation', ['T3']),
    ('wave4-staff-review', ['T2']),
    ('wave5-principal-review', ['T1']),
    ('wave6-consolidation', ['ORCH']),
]

TIER_SPECS: Dict[str, TierSpec] = {
    'T1': TierSpec('T1', 'Principal', 'claude-4.6-opus', ['claude-4.5-opus', 'claude-4.6-sonnet'], 'high', None, 'Full'),
    'T2': TierSpec('T2', 'Staff Engineer', 'claude-4.6-sonnet', ['gpt-5.3-codex', 'composer-2.5-fast'], 'high', 'T1', 'Full'),
    'T3': TierSpec('T3', 'Mid Coder', 'composer-2.5-fast', ['gpt-5.3-codex', 'claude-4.6-sonnet'], 'medium', 'T2', 'Full'),
    'T4': TierSpec('T4', 'Lead Analyst', 'gemini-3.1-pro', ['gemini-3-flash', 'claude-4.6-sonnet'], 'high', None, 'Scoped consolidated'),
    'T5': TierSpec('T5', 'Analyst', 'gemini-3-flash', ['claude-haiku-4.5', 'composer-2.5-fast'], 'high', 'T4', 'Scoped raw only'),
}


def parse_mode(prompt: str) -> str:
    m = re.search(r'\bx(2|3|4|5|7|10)\b', prompt)
    return f"x{m.group(1)}" if m else 'x1'


def distribution_for_mode(mode: str) -> Dict[str, int]:
    return DISTROS[mode].copy()


def root_files_for_context(root: Path) -> List[str]:
    candidates = [
        'README.md',
        'AGENTS.md',
        '.cursor/config/delegation-rules.md',
        '.cursor/config/tier-definitions.md',
        '.cursor/instructions/reference/review-chain.instructions.md',
        '.cursor/contracts/review-report.md',
    ]
    return [c for c in candidates if (root / c).exists()]
