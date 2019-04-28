PYTHON := python3.7
MYPYVY_OPTS := --seed=0 --log=warning --timeout 2000  --minimize-models

check:
	$(PYTHON) -m mypy --config-file ./mypy.ini src/mypyvy.py

test: check typecheck verify trace updr

typecheck: $(patsubst %.pyv, %.typecheck, $(wildcard examples/*.pyv))

verify: examples/lockserv.verify examples/consensus.verify examples/sharded-kv.verify

trace: $(patsubst %.pyv, %.trace, $(wildcard examples/*.pyv))

updr: examples/lockserv.updr examples/sharded-kv.updr

bench:
	$(PYTHON) script/benchmark.py

%.typecheck: %.pyv
	$(PYTHON) src/mypyvy.py typecheck $(MYPYVY_OPTS) $<

%.trace: %.pyv
	$(PYTHON) src/mypyvy.py trace $(MYPYVY_OPTS) $<

%.verify: %.pyv
	time $(PYTHON) src/mypyvy.py verify $(MYPYVY_OPTS) $<

%.updr: %.pyv
	time $(PYTHON) src/mypyvy.py updr $(MYPYVY_OPTS) $<

.PHONY: check run test verify updr bench typecheck trace
