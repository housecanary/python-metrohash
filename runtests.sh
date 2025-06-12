#!/bin/sh
# For use inside the Docker container to run tests and install the package

# Install package
echo 'Installing package...'
pip3 install --break-system-packages --force-reinstall --upgrade .

# Run package tests
pytest tests
