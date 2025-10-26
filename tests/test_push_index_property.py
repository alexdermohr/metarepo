"""Tests for push_index_property batching helpers."""

from __future__ import annotations

import importlib
import math
from typing import Any

import pandas as pd
import pytest


_CANDIDATE_MODULES = (
    "push_index_property",
    "tools.push_index_property",
    "heimgewebe.tools.push_index_property",
    "heimgewebe_tools.push_index_property",
    "metarepo_tools.push_index_property",
)


def _load_push_index_module() -> Any:
    """Load the push_index_property module from one of several candidate paths."""

    for module_name in _CANDIDATE_MODULES:
        try:
            module = importlib.import_module(module_name)
            module.__dict__.setdefault("__loaded_from__", module_name)
            return module
        except ModuleNotFoundError:
            continue
    return None


push_index_property = _load_push_index_module()

if push_index_property is None:
    pytest.skip(
        "push_index_property module not available; skipping push index tests",
        allow_module_level=True,
    )


to_batches = push_index_property.to_batches


@pytest.mark.parametrize(
    ("namespace_value", "expected"),
    [
        (None, "vault-default"),
        ("", "vault-default"),
        ("   ", "vault-default"),
        (math.nan, "vault-default"),
        ("vault", "vault"),
    ],
    ids=["None", "empty", "spaces", "nan", "value"],
)
def test_default_namespace_applied(namespace_value: object, expected: str) -> None:
    df = pd.DataFrame(
        [
            {
                "doc_id": "D",
                "namespace": namespace_value,
                "text": "x",
                "embedding": [0.1, 0.2],
            }
        ]
    )

    batches = list(to_batches(df, default_namespace="vault-default"))

    assert len(batches) == 1
    assert batches[0]["namespace"] == expected


def test_batches_shape_and_chunk_ids_clean() -> None:
    """Batches enthalten doc_id, zwei Chunks und keine 'nan'-IDs."""
    df = pd.DataFrame(
        [
            {
                "doc_id": "D",
                "namespace": None,
                "text": "alpha",
                "embedding": [0.1, 0.2],
            },
            {
                "doc_id": "D",
                "namespace": "   ",
                "text": "beta",
                "embedding": [0.2, 0.3],
            },
        ]
    )

    batches = list(to_batches(df, default_namespace="vault-default"))
    assert len(batches) == 1
    batch = batches[0]

    # Grundform
    assert batch["doc_id"] == "D"
    assert batch["namespace"] == "vault-default"
    assert "chunks" in batch and isinstance(batch["chunks"], list)
    assert len(batch["chunks"]) == 2

    # Chunk-ID Hygiene
    for chunk in batch["chunks"]:
        cid = str(chunk["id"])
        assert cid, "chunk id must be non-empty"
        low = cid.lower()
        assert low != "nan" and "nan" not in low


def test_doc_id_preserved_exactly() -> None:
    """doc_id is trimmed but otherwise unmodified when batching."""
    doc_id = "  MixED Id  "
    df = pd.DataFrame(
        [
            {
                "doc_id": doc_id,
                "namespace": None,
                "text": "payload",
                "embedding": [0.3, 0.4],
            }
        ]
    )

    batches = list(to_batches(df, default_namespace="vault-default"))

    assert len(batches) == 1
    assert batches[0]["doc_id"] == doc_id.strip()
