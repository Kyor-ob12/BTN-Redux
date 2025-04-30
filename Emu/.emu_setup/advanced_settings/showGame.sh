#!/bin/sh

CURRENT_GAME=""

if [ -z ${CURRENT_GAME} ]; then
    echo -n "Game not detected"
else
    echo -n "${CURRENT_GAME}"
fi