# flv-c-setup

This script installs all the necessary packages and dependencies to run ANTSUN and CePNEM. By default, it will install both package suites, but you can comment out the relevant lines of code (`julia -e "using FlavellPkg; FlavellPkg.install_ANTSUN(false);"` or `julia -e "using FlavellPkg; FlavellPkg.install_ANTSUN(false);"`) to install only one of them.

## Requirements
This package installation script requires you to be using a Linux distribution; it has been tested on Ubuntu, though other distributions could also work. To use `ANTSUN`, you also need have a working GPU with at least 8GB of dedicated memory, and you need to have previously installed all the relevant NVIDIA drivers, CUDA, and CUDNN.

## Usage
Set up your `ssh` keys with GitHub if you haven't already (see below), download the `flv-c-init.sh` file, and simply execute it from a terminal (eg `sh flv-c-init.sh`).

## Set up `ssh` keys
### SSH key  - GitHub
Open a terminal on the computer where you're trying to install the packages. Modify the email address below and run the command: 
```
ssh-keygen -m PEM -t ed25519 -C “email-you-used-for-github@email.com”
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

Add your key on github: 
- Go to your GitHub settings on the account you intend to use for accessing lab packages, then navigate to "SSH and GPG keys"
- Click the "New SSH key" button, then paste in the contents of the file (run `cat ~/.ssh/id_ed25519.pub`, or whatever file the key was saved in)
- Ensure there are no newlines after the contents you paste.

### Set up `ssh-agent`:
Copy and paste the following, appending it to your `~/.profile` file:
```
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initializing new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
```
Close and re-open your shell.


## Install packages with flv-c-setup
### When you are starting from a clean slate (i.e. new, empty Julia environment)
```
cd ~
git clone git@github.com:flavell-lab/flv-c-setup.git
cd flv-c-setup
sh flv-c-init.sh
```
### When you need to update all julia packages
```
julia
]update
```
### When you need to update all python packages
```
cd flv-c-setup
sh update-py.sh
```
Note that currently DeepReg, autolabel and euler_gpu are updated to their latest version automatically when you do `sh update-py.sh`.
However, if you would like to update other python packages owned by `flavell-lab`, you will need to add them to the list by simply editing line 1 of `update-py.sh`
