from __future__ import annotations

import json
from pathlib import Path
from typing import Dict, List

from .task_packets import TaskPacket
from .tiers import TIER_SPECS


AGENT_FILES = {
    'T1': 'principal.md',
    'T2': 'staff-engineer.md',
    'T3': 'mid-coder.md',
    'T4': 'lead-analyst.md',
    'T5': 'analyst.md',
}

SUBAGENT_TYPES = {
    'T1': ('generalPurpose', False),
    'T2': ('generalPurpose', False),
    'T3': ('generalPurpose', False),
    'T4': ('explore', True),
    'T5': ('explore', True),
}


def load_agent_template(root: Path, tier: str) -> str:
    agent_file = root / '.cursor' / 'agents' / AGENT_FILES[tier]
    if agent_file.exists():
        return agent_file.read_text(encoding='utf-8')
    return f'# {tier} agent template missing'


def build_spawn_markdown(root: Path, packet: TaskPacket) -> str:
    template = load_agent_template(root, packet.tier)
    subagent_type, readonly = SUBAGENT_TYPES[packet.tier]
    spec = TIER_SPECS[packet.tier]
    lines = [
        f'# Spawn Packet: {packet.agent_id}',
        '',
        '## Cursor Task Invocation',
        f'- subagent_type: `{subagent_type}`',
        f'- readonly: `{str(readonly).lower()}`',
        f'- description: `{packet.display_name}`',
        '',
        '## Agent Template',
        template,
        '',
        '## Task Assignment',
        f'- task_summary: {packet.task_summary}',
        f'- owned_scope: {", ".join(packet.owned_scope)}',
        f'- required_skills: {", ".join(packet.required_skills)}',
        f'- review_target: {packet.review_target or "orchestrator"}',
        f'- expected_model_hint: {spec.primary_model}',
        '',
        '## Context Files',
        *[f'- {item}' for item in packet.context_files],
        '',
        '## Output Contract',
        'Produce a task report per `.cursor/contracts/task-report.md`.',
        'Write analysis only inside tier-scoped analysis directories.',
    ]
    return '\n'.join(lines) + '\n'


def write_spawn_packets(root: Path, paths: Dict[str, Path], packets: List[TaskPacket]) -> List[str]:
    spawn_dir = paths['run_root'] / 'spawn-packets'
    spawn_dir.mkdir(parents=True, exist_ok=True)
    order: List[str] = []
    for packet in packets:
        content = build_spawn_markdown(root, packet)
        target = spawn_dir / f'{packet.agent_id}.md'
        target.write_text(content, encoding='utf-8')
        order.append(packet.agent_id)
    return order


def enrich_manifest(paths: Dict[str, Path], packets: List[TaskPacket], spawn_order: List[str], mode: str, prompt: str) -> None:
    manifest = {
        'mode': mode,
        'prompt': prompt,
        'spawn_order': spawn_order,
        'packets': [p.to_dict() for p in packets],
        'spawn_packets_dir': str(paths['run_root'] / 'spawn-packets'),
        'orchestration': 'cursor-task',
    }
    paths['run_root'].joinpath('manifest.json').write_text(
        json.dumps(manifest, indent=2, ensure_ascii=False) + '\n',
        encoding='utf-8',
    )
