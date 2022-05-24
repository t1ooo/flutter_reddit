#!/bin/bash

export REDDIT_REDIRECT_URI="fake://fake" # gradle env
flutter run -d linux "$@"
