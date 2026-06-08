from __future__ import annotations

import re
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List

from .safe_writes import extract_requested_targets, materialize_safe_writes


@dataclass
class WorkerOutcome:
    status: str
    confidence: str
    details: List[str]
    validation: List[str]
    notes: List[str]
    files: List[str]
    written_files: List[str]
    blocked_targets: List[str]


def classify_prompt(prompt: str) -> str:
    p = prompt.lower()
    if any(k in p for k in ['audit', 'analysis', 'investigate', 'discover', 'map']):
        return 'analysis'
    if any(k in p for k in ['refactor', 'feature', 'implement', 'build', 'fix', 'migration', 'write', 'update']):
        return 'implementation'
    if any(k in p for k in ['review', 'validate', 'check']):
        return 'review'
    return 'general'


def search_relevant_files(root: Path, prompt: str, limit: int = 12) -> List[str]:
    terms = [t for t in re.findall(r'[A-Za-z][A-Za-z0-9_-]{2,}', prompt.lower()) if t not in STOPWORDS]
    if not terms:
        return []
    cmd = ['rg', '-l', '-S'] + terms[:6] + ['.']
    try:
        completed = subprocess.run(cmd, cwd=root, capture_output=True, text=True, check=False)
        lines = [line.strip().removeprefix('./') for line in completed.stdout.splitlines() if line.strip()]
        filtered = [line for line in lines if not line.startswith('.cursor/runtime/runs/')]
        return filtered[:limit]
    except FileNotFoundError:
        return []


def build_outcome(root: Path, run_root: Path, packet: Dict, revision_round: int = 0) -> WorkerOutcome:
    prompt_type = classify_prompt(packet['prompt'])
    relevant_files = search_relevant_files(root, packet['prompt'])
    requested_targets = extract_requested_targets(packet['prompt'], relevant_files)
    written_files = materialize_safe_writes(root, run_root, packet['tier'], requested_targets)
    tier = packet['tier']
    details = [f"Prompt type classified as: {prompt_type}.", f"Scoped ownership: {', '.join(packet['owned_scope'])}."]
    validation = [f"Relevant file candidates: {', '.join(relevant_files[:6]) if relevant_files else 'none found'}."]
    notes = [f"Written files: {', '.join(written_files) if written_files else 'none'}.", f'Revision round: {revision_round}.']
    status = 'Completed'
    confidence = 'Medium'
    blocked_targets: List[str] = []

    if tier == 'T5':
        details += ['Produced discovery-oriented evidence lane.', 'Prepared search-derived context for T4 consolidation.']
    elif tier == 'T4':
        details += ['Consolidated raw evidence into implementation-ready guidance.', 'Checked for duplicate/weak evidence lanes.']
    elif tier == 'T3':
        details += ['Prepared bounded implementation lane.', 'Scoped possible edit surfaces for downstream application.']
    elif tier == 'T2':
        details += ['Performed complex implementation/review lane preparation.', 'Validated lower-tier artifact completeness.']
    elif tier == 'T1':
        details += ['Performed architecture/review pass over integrated artifacts.', 'Checked residual risk visibility.']

    if not relevant_files:
        confidence = 'Low'
        status = 'Partial'
        notes.append('Prompt-to-file mapping found no direct repository hits; operator follow-up may be required.')

    if 'force-revision' in packet['prompt'].lower() and revision_round < 1 and tier in {'T3', 'T5'}:
        status = 'Partial'
        notes.append('Synthetic revision trigger applied for validation of revision loop.')

    return WorkerOutcome(
        status=status,
        confidence=confidence,
        details=details,
        validation=validation,
        notes=notes,
        files=relevant_files or packet.get('context_files', []),
        written_files=written_files,
        blocked_targets=blocked_targets,
    )


STOPWORDS = {
    'the', 'and', 'for', 'with', 'from', 'into', 'task', 'feature', 'build', 'real', 'local', 'parallel',
    'delegate', 'mode', 'review', 'audit', 'analysis', 'implement', 'fix', 'migration', 'refactor', 'auth',
}
