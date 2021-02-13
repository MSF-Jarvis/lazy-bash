#!/usr/bin/env bash

# Copyright (C) Harsh Shandilya <me@msfjarvis.dev>
# SPDX-License-Identifier: GPL-3.0-only

function nixpatch() {
  [ -z "${1}" ] && return
  patchelf --set-interpreter "$(nix eval nixpkgs.glibc.outPath | sed 's/"//g')/lib/ld-linux-x86-64.so.2" "${1}"
}
