#!/usr/bin/env bash
set -e
sudo cp ./git-story /usr/local/bin/
sudo cp ./git-story-install-hooks /usr/local/bin/
sudo cp ./git-story-prepare-commit-msg /usr/local/bin/
sudo cp ./git-story-duet /usr/local/bin/
chmod +x /usr/local/bin/git-story*
