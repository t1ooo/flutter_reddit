#!/bin/bash

source "./.env"
flutter run \
    --dart-define=CLIENT_ID="$(printf "%q" "$CLIENT_ID")" \
    --dart-define=REDIRECT_URI="$(printf "%q" "$REDIRECT_URI")" \
    -d linux "$@"
