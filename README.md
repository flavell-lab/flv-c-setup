# flv-c-setup

This script installs all the necessary packages and dependencies to run ANTSUN and CePNEM. By default, it will install both package suites, but you can comment out the relevant lines of code (`julia -e "using FlavellPkg; FlavellPkg.install_ANTSUN(false);"` or `julia -e "using FlavellPkg; FlavellPkg.install_ANTSUN(false);"`) to install only one of them.

## Requirements
This package installation script requires you to be using a Linux distribution; it has been tested on Ubuntu, though other distributions could also work. To use `ANTSUN`, you also need have a working GPU with at least 8GB of dedicated memory, and you need to have previously installed all the relevant NVIDIA drivers, CUDA, and CUDNN.

## Usage
Download the `flv-c-init.sh` file and simply execute it from a terminal, eg `sh flv-c-init.sh`.
