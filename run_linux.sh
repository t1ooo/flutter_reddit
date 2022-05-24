#!/bin/bash

source "./.env.desktop"
flutter run \
    --dart-define="REDDIT_CLIENT_ID=$REDDIT_CLIENT_ID" \
    --dart-define="REDDIT_REDIRECT_URI=$REDDIT_REDIRECT_URI" \
    -d linux "$@"
