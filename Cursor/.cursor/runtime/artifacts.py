from __future__ import annotations

from dataclasses import asdict
from datetime import datetime, timezone
import json
from pathlib import Path
from typing import Any, Dict, Iterable, List


def utc_now_stamp() -> str:
    return datetime.now(timezone.utc).strftime('%Y-%m-%dT%H-%M-%SZ')


def ensure_run_dirs(root: Path, run_id: str) -> Dict[str, Path]:
    run_root = root / '.cursor' / 'runtime' / 'runs' / run_id
    paths = {
        'run_root': run_root,
        'packets': run_root / 'packets',
        'agents': run_root / 'agents',
        'reviews': run_root / 'reviews',
        'logs': run_root / 'logs',
        'spawn_packets': run_root / 'spawn-packets',
    }
    for p in paths.values():
        p.mkdir(parents=True, exist_ok=True)
    return paths


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, indent=2, ensure_ascii=False) + '\n', encoding='utf-8')


def write_text(path: Path, payload: str) -> None:
    path.write_text(payload.rstrip() + '\n', encoding='utf-8')


def write_packets(paths: Dict[str, Path], packets: Iterable[Any]) -> None:
    manifest: List[Dict[str, Any]] = []
    for packet in packets:
        payload = packet.to_dict()
        manifest.append(payload)
        write_json(paths['packets'] / f"{packet.agent_id}.json", payload)
    write_json(paths['run_root'] / 'manifest.json', manifest)


def append_markdown_section(path: Path, heading: str, lines: List[str]) -> None:
    existing = path.read_text(encoding='utf-8') if path.exists() else ''
    chunk = [heading, ''] + lines + ['']
    path.write_text((existing.rstrip() + '\n\n' if existing else '') + '\n'.join(chunk), encoding='utf-8')
