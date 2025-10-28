from __future__ import annotations
from typing import Any, Dict, List

# Platzhalter-Tool-Implementierungen.
# In echten Repos an hausKI/semantAH/aussensensor koppeln.

def search_codebase(query: str, repo_filter: List[str] | None = None) -> Dict[str, Any]:
    return {
        "tool": "search_codebase",
        "query": query,
        "repos": repo_filter or [],
        "hits": [],
    }


def query_knowledge_graph(sparql_query: str) -> Dict[str, Any]:
    return {
        "tool": "query_knowledge_graph",
        "sparql": sparql_query,
        "rows": [],
    }


TOOL_REGISTRY = {
    "search_codebase": search_codebase,
    "query_knowledge_graph": query_knowledge_graph,
}
