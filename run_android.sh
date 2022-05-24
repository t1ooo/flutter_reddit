#!/bin/bash

source "./.env.mobile"
export REDDIT_REDIRECT_URI="$REDDIT_REDIRECT_URI" # gradle env
flutter run \
    --dart-define="REDDIT_CLIENT_ID=$REDDIT_CLIENT_ID" \
    --dart-define="REDDIT_REDIRECT_URI=$REDDIT_REDIRECT_URI" \
    -d android "$@"
