VENV_PATH ?= venv
PYTHON ?= python
PYTEST ?= pytest
PIP ?= pip
YAPF ?= yapf

ifeq ($(VENV_PATH),)
ACTIVATE = 
else
ACTIVATE = . $(VENV_PATH)/bin/activate &&
endif

clean:
	! test -d $(VENV_PATH) || rm -r $(VENV_PATH)

reinstall: venv
	$(ACTIVATE) $(PIP) install --upgrade --force-reinstall -e .[testing]

venv: 
ifneq ($(VENV_PATH),)
	test -d $(VENV_PATH) || echo "Creating new venv" && $(PYTHON) -m venv ./$(VENV_PATH)
endif

install: venv
	$(ACTIVATE) $(PIP) install -e .[testing]

test: 
	$(ACTIVATE) $(PYTEST) tests

test-gpu: 
	$(ACTIVATE) $(PYTEST) tests --gpu

check-formatting:
	$(ACTIVATE) $(YAPF) \
		--parallel \
		--diff \
		--recursive \
		daceml tests setup.py \
		--exclude daceml/onnx/symbolic_shape_infer.py
