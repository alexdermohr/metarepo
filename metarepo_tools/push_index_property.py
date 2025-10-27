"""Helpers for batching index payloads for push_index_property workflows."""

from __future__ import annotations

from collections import OrderedDict
from collections.abc import Iterable, Iterator, Mapping, Sequence
import math
from typing import Any, Dict, List

__all__ = ["to_batches"]

_RECORD_KEYS = {"doc_id", "namespace", "text", "embedding"}


def to_batches(frame: Any, *, default_namespace: str) -> Iterator[Dict[str, Any]]:
    """Yield push-index batches grouped by ``doc_id``.

    Parameters
    ----------
    frame:
        Tabular rows describing payload items. Supports real ``pandas`` frames,
        the lightweight stub shipped with this repository, or any iterable of
        mapping objects.
    default_namespace:
        Namespace that should be applied when the source rows do not define a
        usable value.
    """

    if not isinstance(default_namespace, str) or not default_namespace.strip():
        raise ValueError("default_namespace must be a non-empty string")

    records = list(_coerce_records(frame))
    grouped: "OrderedDict[str, List[Dict[str, Any]]]" = OrderedDict()
    for record in records:
        doc_id = _normalise_doc_id(record.get("doc_id"))
        grouped.setdefault(doc_id, []).append(record)

    for doc_id, rows in grouped.items():
        namespace = _resolve_namespace(rows, default_namespace)
        chunks = [_build_chunk(index, row) for index, row in enumerate(rows, start=1)]
        yield {
            "doc_id": doc_id,
            "namespace": namespace,
            "chunks": chunks,
        }


def _coerce_records(frame: Any) -> Iterator[Dict[str, Any]]:
    if isinstance(frame, Mapping):
        yield dict(frame)
        return

    if hasattr(frame, "to_dict"):
        try:
            data = frame.to_dict(orient="records")  # type: ignore[call-arg]
        except TypeError:
            data = frame.to_dict()  # type: ignore[call-arg]
        if isinstance(data, Mapping):
            yield from _from_columnar_mapping(data)
            return
        for row in data:
            if not isinstance(row, Mapping):
                raise TypeError("Rows produced by to_dict must be mappings")
            yield dict(row)
        return

    if isinstance(frame, Iterable):
        for row in frame:
            if not isinstance(row, Mapping):
                raise TypeError("Iterable rows must be mappings")
            yield dict(row)
        return

    raise TypeError("Unsupported frame type; expected DataFrame or iterable of mappings")


def _normalise_doc_id(value: Any) -> str:
    if value is None:
        raise ValueError("doc_id column is required")
    doc_id = str(value).strip()
    if not doc_id:
        raise ValueError("doc_id must contain non-whitespace characters")
    return doc_id


def _resolve_namespace(rows: Sequence[Mapping[str, Any]], default_namespace: str) -> str:
    for row in rows:
        namespace = row.get("namespace")
        if namespace is None:
            continue
        if isinstance(namespace, str):
            candidate = namespace.strip()
            if candidate:
                return candidate
            continue
        if _is_nan(namespace):
            continue
        return str(namespace)
    return default_namespace.strip() or default_namespace


def _build_chunk(index: int, row: Mapping[str, Any]) -> Dict[str, Any]:
    chunk: Dict[str, Any] = {
        "id": _chunk_id(index),
        "text": row.get("text"),
        "embedding": row.get("embedding"),
    }
    metadata = {
        key: value for key, value in row.items() if key not in _RECORD_KEYS
    }
    if metadata:
        chunk["metadata"] = metadata
    return chunk


def _chunk_id(index: int) -> str:
    return f"chunk-{index:04d}"


def _is_nan(value: Any) -> bool:
    try:
        return math.isnan(value)  # type: ignore[arg-type]
    except TypeError:
        return False


def _from_columnar_mapping(data: Mapping[str, Any]) -> Iterator[Dict[str, Any]]:
    columns: List[str] = list(data.keys())
    normalised: List[List[Any]] = []
    max_len = 0
    for key in columns:
        value = data[key]
        if isinstance(value, Sequence) and not isinstance(value, (str, bytes, bytearray)):
            values_list = list(value)
        else:
            values_list = [value]
        normalised.append(values_list)
        max_len = max(max_len, len(values_list))

    for index in range(max_len):
        row: Dict[str, Any] = {}
        for column, values in zip(columns, normalised):
            row[column] = values[index] if index < len(values) else None
        yield row
