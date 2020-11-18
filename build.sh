#!/bin/sh
set -e

# Get the absolute path to the directory this script is in.
PROJECT_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Run script inside a nix shell if it is available.
if command -v nix-shell && [ $NIX_PATH ] && [ -z $IN_NIX_SHELL ]; then
	cd ${PROJECT_DIR}
	nix-shell --pure --run "bash ./build.sh"
	exit
fi

# Build godot-xterm.
GODOT_XTERM_DIR=${PROJECT_DIR}/thirdparty/godot-xterm
if [ ! -d $GODOT_XTERM_DIR ]; then
	cd $PROJECT_DIR
	git submodule update --init --recursive -- $GODOT_XTERM_DIR
fi
${GODOT_XTERM_DIR}/addons/godot_xterm/native/build.sh

# Build godot-python.
GODOT_PYTHON_DIR=${PROJECT_DIR}/thirdparty/godot-python
if [ ! -d "$GODOT_PYTHON_DIR" ]; then
	cd $PROJECT_DIR
	git submodule update --init --recursive -- $GODOT_PYTHON_DIR
fi
cd $GODOT_PYTHON_DIR
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
scons platform=x11-64 release
deactivate

# Use the godot-python python binary from here on out.
python="${PROJECT_DIR}/addons/pythonscript/x11-64/bin/python3"
if [ $IN_NIX_SHELL ]; then
	# We need to patch the python3 binary produced by godot-python so it can work on NixOS.
	patchelf --set-interpreter $(patchelf --print-interpreter $(which python)) $python
fi

# Install python modules used by this project.
cd $PROJECT_DIR
$python -m ensurepip
$python -m pip install -r requirements.txt
