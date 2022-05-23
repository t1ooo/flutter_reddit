#!/bin/bash

source "./.env.mobile"
export REDIRECT_URI="$REDIRECT_URI"
flutter run \
    --dart-define=CLIENT_ID="$(printf "%q" "$CLIENT_ID")" \
    --dart-define=REDIRECT_URI="$(printf "%q" "$REDIRECT_URI")" \
    -d android "$@"
