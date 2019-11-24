#!/usr/bin/env bash

# Copyright (C) Harsh Shandilya <msfjarvis@gmail.com>
# SPDX-License-Identifier: GPL-3.0-only

trap 'rm -rf /tmp/nano 2>/dev/null' INT TERM EXIT

# shellcheck source=common
source "${SCRIPT_DIR:?}"/common

function install_nano() {
    local NANO_VER LATEST_NANO_VER
    echoText "Checking and updating nano"
    NANO_VER="$(nano --version | head -n1 | awk '{print $4}')"
    LATEST_NANO_VER="4.5"
    if [ "${NANO_VER}" != "${LATEST_NANO_VER}" ]; then
        echoText "Building latest nano version from git"
        sudo apt purge nano -y
        cd /tmp || return 1
        dl https://www.nano-editor.org/dist/v4/nano-"${LATEST_NANO_VER}".tar.xz nano.tar.xz
        tar xf nano.tar.xz
        cd nano-"${LATEST_NANO_VER}" || return 1
        CC=clang CXX=clang++ ./configure --enable-color --enable-extra --enable-multibuffer --enable-nanorc --enable-utf8 --disable-libmagic
        make all -j"$(nproc)"
        sudo make install
        cd "${SCRIPT_DIR}" || return 1
    else
        reportWarning "nano ${NANO_VER} is already installed!"
    fi
    rm -rf /tmp/nano 2>/dev/null
}

install_nano
