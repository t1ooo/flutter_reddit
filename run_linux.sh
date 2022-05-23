#!/bin/bash

source "./.env.desktop"
flutter run \
    --dart-define=REDDIT_CLIENT_ID="$(printf "%q" "$REDDIT_CLIENT_ID")" \
    --dart-define=REDDIT_REDIRECT_URI="$(printf "%q" "$REDDIT_REDIRECT_URI")" \
    -d linux "$@"
