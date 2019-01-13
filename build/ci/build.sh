#!/usr/bin/env bash

if [[ ! -z "${REACTIVEOAUTH_CREDENTIALS}" ]]; then
    echo "${REACTIVEOAUTH_CREDENTIALS}" > "${TRAVIS_BUILD_DIR}/test/oauth.json"
    echo "Updated ${TRAVIS_BUILD_DIR}/test/oauth.json with REACTIVEOAUTH_CREDENTIALS environment variable."
else
    echo "No REACTIVEOAUTH_CREDENTIALS environment variable is set, OAuth tests will be skipped."
fi