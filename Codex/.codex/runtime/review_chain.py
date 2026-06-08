from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List

from .artifacts import write_text


@dataclass
class ReviewResult:
    review_id: str
    reviewer_tier: str
    item_under_review: str
    decision: str
    severity_summary: Dict[str, int]
    findings: Dict[str, List[str]]
    required_fixes: List[str]
    residual_risks: List[str]
    validation_notes: List[str]
    escalation_target: str | None


def generate_review(review_id: str, reviewer_tier: str, item_under_review: str, body: str) -> ReviewResult:
    findings = {'Critical': [], 'High': [], 'Medium': [], 'Low': []}
    required_fixes: List[str] = []
    residual_risks: List[str] = []
    validation = ['Generated via local orchestration runtime review pass.', 'This is a contract artifact, not an LLM judgement.']

    lower_body = body.lower()
    if 'status: failed' in lower_body:
        findings['High'].append('Worker reported failed status.')
        required_fixes.append('Repair failed worker output before approval.')
        decision = 'Revision Required'
    elif '**status**: partial' in lower_body or 'status: partial' in lower_body:
        findings['Medium'].append('Worker reported partial status.')
        required_fixes.append('Complete partial work or document explicit acceptance.')
        decision = 'Revision Required'
    else:
        decision = 'Approved'
        residual_risks.append('Human/operator should still verify semantic quality for production usage.')

    severity_summary = {k.lower(): len(v) for k, v in findings.items()}
    return ReviewResult(
        review_id=review_id,
        reviewer_tier=reviewer_tier,
        item_under_review=item_under_review,
        decision=decision,
        severity_summary=severity_summary,
        findings=findings,
        required_fixes=required_fixes,
        residual_risks=residual_risks,
        validation_notes=validation,
        escalation_target=None if decision == 'Approved' else reviewer_tier,
    )


def render_review(result: ReviewResult, related_task: str) -> str:
    lines = [
        '# Review Report',
        '',
        '## Header',
        f'- Review ID: {result.review_id}',
        f'- Reviewer Tier: {result.reviewer_tier}',
        f'- Item Under Review: {result.item_under_review}',
        f'- Related Task / Session: {related_task}',
        '',
        '## Review Decision',
        f'- Decision: {result.decision}',
        f"- Severity Summary: Critical {result.severity_summary['critical']} / High {result.severity_summary['high']} / Medium {result.severity_summary['medium']} / Low {result.severity_summary['low']}",
        '',
        '## Findings',
    ]
    for severity in ['Critical', 'High', 'Medium', 'Low']:
        bucket = result.findings[severity]
        lines.append(f'### {severity}')
        if bucket:
            lines.extend([f'- {item}' for item in bucket])
        else:
            lines.append('- none')
        lines.append('')
    lines += ['## Required Fixes']
    lines += [f'- {item}' for item in result.required_fixes] if result.required_fixes else ['- none']
    lines += ['', '## Residual Risks']
    lines += [f'- {item}' for item in result.residual_risks] if result.residual_risks else ['- none']
    lines += ['', '## Validation Notes']
    lines += [f'- {item}' for item in result.validation_notes]
    lines += ['', '## Escalation']
    lines.append(f"- {'none' if result.escalation_target is None else result.escalation_target}")
    return '\n'.join(lines)


def persist_review(path: Path, result: ReviewResult, related_task: str) -> None:
    write_text(path, render_review(result, related_task))
