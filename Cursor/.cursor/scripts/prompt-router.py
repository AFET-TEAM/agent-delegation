#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List


XN_RE = re.compile(r'\bx(2|3|4|5|7|10)\b', re.I)
CODE_FENCE_RE = re.compile(r'```[\s\S]*?```|~~~[\s\S]*?~~~')

KEYWORDS = {
    'pcd': re.compile(r'(?:^|[\s,.;])(?:/?pcd)(?:[\s,.;]|$)', re.I),
    'caveman': re.compile(r'(?:^|[\s,.;])(?:/?caveman(?:\s+(?:lite|full|ultra))?)(?:[\s,.;]|$)', re.I),
    'graphify': re.compile(r'(?:^|[\s,.;])(?:/?graphify)(?:[\s,.;]|$)', re.I),
    'context_mode': re.compile(r'(?:^|[\s,.;])(?:/?context-mode|/?contextmode|/?ctx)(?:[\s,.;]|$)', re.I),
    'review': re.compile(r'(?:^|[\s,.;])(?:/?review)(?:[\s,.;]|$)', re.I),
    'architect': re.compile(r'(?:^|[\s,.;])(?:/?architect)(?:[\s,.;]|$)', re.I),
}

OPT_OUT = {
    'caveman': re.compile(r'no caveman|stop caveman|normal mode', re.I),
    'context_mode': re.compile(r'context-mode off|no context-mode', re.I),
    'graphify': re.compile(r'graphify off|no graphify', re.I),
}


def strip_code_fences(text: str) -> str:
    return CODE_FENCE_RE.sub(' ', text)


def detect_xn(text: str) -> str:
    matches = XN_RE.findall(strip_code_fences(text))
    if not matches:
        return ''
    return f'x{matches[-1].lower()}'


def detect_keywords(text: str) -> Dict[str, bool]:
    probe = strip_code_fences(text)
    found = {key: bool(pattern.search(probe)) for key, pattern in KEYWORDS.items()}
    for key, pattern in OPT_OUT.items():
        if pattern.search(probe):
            if key == 'caveman':
                found['caveman'] = False
            elif key == 'context_mode':
                found['context_mode'] = False
            elif key == 'graphify':
                found['graphify'] = False
    return found


def default_modes() -> Dict[str, bool]:
    return {'caveman': True, 'context_mode': True, 'graphify': True}


def apply_opt_out(text: str, modes: Dict[str, bool]) -> Dict[str, bool]:
    result = modes.copy()
    if OPT_OUT['caveman'].search(text):
        result['caveman'] = False
    if OPT_OUT['context_mode'].search(text):
        result['context_mode'] = False
    if OPT_OUT['graphify'].search(text):
        result['graphify'] = False
    return result


def build_modes(text: str, detected: Dict[str, bool]) -> Dict[str, bool]:
    modes = default_modes()
    for key in ('caveman', 'context_mode', 'graphify'):
        if detected.get(key):
            modes[key] = True
    return apply_opt_out(text, modes)


def run_orchestrate(cursor_root: Path, prompt: str) -> Dict[str, Any]:
    script = cursor_root / 'runtime' / 'orchestrate.py'
    project_root = cursor_root.parent
    if not script.exists():
        return {'ok': False, 'error': f'missing {script}'}
    completed = subprocess.run(
        [sys.executable, str(script), '--plan-only', prompt],
        cwd=str(project_root),
        capture_output=True,
        text=True,
    )
    runs = sorted((cursor_root / 'runtime' / 'runs').glob('*'), reverse=True)
    latest = runs[0] if runs else None
    manifest_path = latest / 'manifest.json' if latest else None
    spawn_dir = latest / 'spawn-packets' if latest else None
    return {
        'ok': completed.returncode == 0,
        'returncode': completed.returncode,
        'run_id': latest.name if latest else '',
        'manifest': str(manifest_path) if manifest_path and manifest_path.exists() else '',
        'spawn_packets_dir': str(spawn_dir) if spawn_dir and spawn_dir.exists() else '',
        'stderr': completed.stderr.strip()[-500:] if completed.stderr else '',
    }


def build_context(prompt: str, modes: Dict[str, bool], xn: str, detected: Dict[str, bool], orchestration: Dict[str, Any]) -> str:
    parts: List[str] = []
    if xn:
        parts.append(
            f'MULTI-AGENT {xn.upper()} aktif. Uygulama kodu yazma; AGENTS.md Step 2-5 uygula. '
            'Task subagent spawn zorunlu.'
        )
        if orchestration.get('ok') and orchestration.get('spawn_packets_dir'):
            parts.append(
                f'Manifest hazır: {orchestration["manifest"]}. '
                f'Spawn sırası: {orchestration["spawn_packets_dir"]}/*.md dosyalarını manifest spawn_order ile çalıştır.'
            )
        elif orchestration.get('ok') is False:
            parts.append('Manifest üretilemedi; önce python3 .cursor/runtime/orchestrate.py --plan-only çalıştır.')
    if detected.get('pcd'):
        parts.append('PCD aktif: README.md ve docs/ oku; implementasyondan önce proje bağlamını özetle.')
    if detected.get('review'):
        parts.append('REVIEW modu: review zinciri öncelikli; kod değişikliği ikincil.')
    if detected.get('architect'):
        parts.append('ARCHITECT modu: T1 Principal yönlendirmesi; mimari kararlar önce.')
    if modes.get('caveman'):
        parts.append('CAVEMAN: kullanıcıya kısa yanıt; kod/path/komut sıkıştırma.')
    if modes.get('context_mode') or detected.get('context_mode'):
        parts.append('CONTEXT-MODE: dar arama, geniş dump yok.')
    if modes.get('graphify') or detected.get('graphify'):
        parts.append('GRAPHIFY: topoloji-first daraltma; dosya kanıtı şart.')
    if not parts:
        return ''
    return ' '.join(parts)


def route(prompt: str, cursor_root: Path) -> Dict[str, Any]:
    detected = detect_keywords(prompt)
    modes = build_modes(prompt, detected)
    xn = detect_xn(prompt)
    orchestration: Dict[str, Any] = {}
    if xn:
        orchestration = run_orchestrate(cursor_root, prompt)
    context = build_context(prompt, modes, xn, detected, orchestration)
    return {
        'modes': modes,
        'xn': xn,
        'detected': detected,
        'orchestration': orchestration,
        'additional_context': context,
        'prompt': prompt,
    }


def main() -> int:
    if len(sys.argv) < 2:
        print('Usage: prompt-router.py <prompt>', file=sys.stderr)
        return 2
    prompt = ' '.join(sys.argv[1:]).strip()
    cursor_root = Path(__file__).resolve().parents[1]
    result = route(prompt, cursor_root)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
