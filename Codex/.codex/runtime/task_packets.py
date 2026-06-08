from __future__ import annotations

from dataclasses import dataclass, asdict
import re
from pathlib import Path
from typing import Dict, List

from .tiers import TIER_SPECS, distribution_for_mode, root_files_for_context


@dataclass
class TaskPacket:
    agent_id: str
    display_name: str
    tier: str
    role: str
    wave: str
    prompt: str
    task_summary: str
    owned_scope: List[str]
    required_skills: List[str]
    skipped_skills: List[str]
    context_files: List[str]
    review_target: str | None
    expected_output_format: str
    expected_model: str
    reasoning_effort: str
    edit_permission: str

    def to_dict(self) -> Dict:
        return asdict(self)


def infer_scope(tier: str, prompt: str = '') -> List[str]:
    if tier == 'T5':
        return ['repo discovery', 'risk extraction', 'test scenarios', *infer_prompt_scope(prompt)]
    if tier == 'T4':
        return ['analysis consolidation', 'evidence de-duplication', 'review of T5', *infer_prompt_scope(prompt)]
    if tier == 'T3':
        return ['bounded implementation', 'scoped edits', 'local validation', *infer_prompt_scope(prompt)]
    if tier == 'T2':
        return ['complex implementation', 'review of T3', 'integration validation', *infer_prompt_scope(prompt)]
    if tier == 'T1':
        return ['architecture review', 'final high-risk review', 'escalation handling', *infer_prompt_scope(prompt)]
    return ['final orchestration']


def required_skills_for_tier(tier: str) -> List[str]:
    base = ['Context Mode', 'Graphify']
    if tier in {'T5', 'T4'}:
        return base + ['Analysis']
    if tier in {'T3', 'T2'}:
        return base + ['Implementation', 'Testing Standards']
    if tier == 'T1':
        return base + ['Architect', 'Code Review']
    return base


def create_packets(root: Path, prompt: str, mode: str) -> List[TaskPacket]:
    distro = distribution_for_mode(mode)
    context_files = root_files_for_context(root)
    packets: List[TaskPacket] = []
    for tier in ['T5', 'T4', 'T3', 'T2', 'T1']:
        count = distro[tier]
        for idx in range(1, count + 1):
            spec = TIER_SPECS[tier]
            packets.append(
                TaskPacket(
                    agent_id=f'{tier}-{idx}',
                    display_name=f'{tier}-{idx} {spec.role}',
                    tier=tier,
                    role=spec.role,
                    wave=_wave_for_tier(tier),
                    prompt=prompt,
                    task_summary=_summary_for_tier(tier, prompt),
                    owned_scope=infer_scope(tier, prompt),
                    required_skills=required_skills_for_tier(tier),
                    skipped_skills=_skipped_skills_for_tier(tier),
                    context_files=context_files,
                    review_target=spec.reviewer_tier,
                    expected_output_format='task-report',
                    expected_model=spec.primary_model,
                    reasoning_effort=spec.reasoning_effort,
                    edit_permission=spec.edit_permission,
                )
            )
    return packets


def _wave_for_tier(tier: str) -> str:
    return {
        'T5': 'wave1-discovery',
        'T4': 'wave2-consolidation',
        'T3': 'wave3-implementation',
        'T2': 'wave4-staff-review',
        'T1': 'wave5-principal-review',
    }[tier]


def _summary_for_tier(tier: str, prompt: str) -> str:
    by_tier = {
        'T5': f'Analyze repository context and produce raw evidence for: {prompt}',
        'T4': f'Consolidate T5 evidence into actionable analysis for: {prompt}',
        'T3': f'Implement bounded scoped changes for: {prompt}',
        'T2': f'Handle complex implementation and/or review T3 output for: {prompt}',
        'T1': f'Perform principal review and architecture validation for: {prompt}',
    }
    return by_tier[tier]


def _skipped_skills_for_tier(tier: str) -> List[str]:
    if tier in {'T5', 'T4'}:
        return ['Implementation']
    if tier in {'T3', 'T2'}:
        return ['Analysis-only long-form discovery']
    if tier == 'T1':
        return ['Scoped coding unless escalation requires it']
    return []


def infer_prompt_scope(prompt: str) -> List[str]:
    tokens = [t for t in re.findall(r'[A-Za-z][A-Za-z0-9_-]{2,}', prompt.lower()) if t not in {'x2','x3','x4','x5','x7','x10'}]
    return tokens[:4]
