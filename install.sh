#!/usr/bin/env bash
# vim: ai ts=2 sw=2 et sts=2 ft=sh


set -e -u

ANSIBLE_ARGS=""

case "$(uname)" in
    Darwin)
        if ! (id -Gn | grep 'wheel' &>/dev/null); then
            sudo dscl . append /Groups/wheel GroupMembership $(whoami)
        fi
        sudo sed -i '' '/NOPASSWD/s/# %wheel/%wheel/g' /etc/sudoers

        if ! hash brew 2>/dev/null; then
            printf "\nInstalling HomeBrew: http://brew.sh ...\n\n"
            ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            printf "\nUpdating HomeBrew: brew update ...\n\n"
            brew update
            printf "\nUpgrading existing HomeBrew software: brew upgrade ...\n\n"
            brew upgrade
            printf "\nCleaning up after HomeBrew ...\n\n"
            brew cleanup
            brew cask cleanup
            brew prune
        fi
        if [[ ! -d /usr/include ]]; then
            printf "\nInstalling the latest Xcode Command Line Tools ...\n\n"
            "xcode-select" --install
        fi
        if [[ ! -d /usr/local/opt/openssl ]]; then
            brew install openssl
        fi
        if ! hash pip 2>/dev/null; then
            printf "\nInstalling Python via HomeBrew ...\n\n"
            # https://github.com/MacPython/wiki/wiki/Which-Python
            brew install python
            pip install -q -U pip setuptools
        fi
        if ! hash ansible-pull 2>/dev/null; then
            printf "\nInstalling Ansible via HomeBrew ...\n\n"
            brew install ansible
        fi
    ;;
    Linux)
        # Debian
        if hash apt-get 2>/dev/null; then
            export DEBIAN_FRONTEND=noninteractive
            export DEBCONF_NONINTERACTIVE_SEEN=true
            if sudo apt-get install -qy software-properties-common; then
                printf "\nInstalling Ansible Ubuntu PPA ...\n\n"
                sudo apt-add-repository -y ppa:ansible/ansible
                sudo apt-get -y update
                sudo apt-get install -y ansible
            else
                sudo apt-get install -y python-dev-all python-yaml python-paramiko python-jinja2 python-pip
                sudo pip install --upgrade ansible
            fi
          fi
esac


ansible-pull $ANSIBLE_ARGS --url=https://github.com/jacob-hudson/ansible-role-ude.git -i localhost,
