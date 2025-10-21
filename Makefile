PYTHON ?= python3
REPOS_YML := repos.yml
ORG_GENERATOR := $(PYTHON) scripts/generate_org_assets.py --repos-file $(REPOS_YML)

.PHONY: all index graph linkcheck

all: index graph

index:
	$(ORG_GENERATOR) --index docs/org-index.md

graph:
	$(ORG_GENERATOR) --graph docs/org-graph.mmd

linkcheck:
	docker run --rm -v $$(pwd):/work ghcr.io/lycheeverse/lychee:v0.14.3 --config /work/.lychee.toml
