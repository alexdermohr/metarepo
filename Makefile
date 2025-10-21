PYTHON ?= python3
REPOS_YML := repos.yml
ORG_GENERATOR := $(PYTHON) scripts/generate_org_assets.py --repos-file $(REPOS_YML)

.PHONY: all index graph

all: index graph

index:
	$(ORG_GENERATOR) --index docs/org-index.md

graph:
	$(ORG_GENERATOR) --graph docs/org-graph.mmd
