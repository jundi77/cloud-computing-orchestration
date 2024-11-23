#!/bin/bash
## /bin/sh is weirded out by SCRIPT_DIR

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

wget -P "$SCRIPT_DIR" --content-disposition https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
