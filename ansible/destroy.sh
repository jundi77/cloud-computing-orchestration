#!/bin/sh
sudo ~/.local/bin/ansible-playbook -i hosts -c local destroy.yml
