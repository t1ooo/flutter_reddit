#!/bin/bash

deps=(
    # carousel_slider
    draw
    provider
    logger
    equatable
    clock
)

dev_deps=(
)

for d in "${deps[@]}"; do
    # flutter pub remove "$d"
    flutter pub add "$d"
done

for d in "${dev_deps[@]}"; do
    # flutter pub remove "$d" --dev
    flutter pub add "$d" --dev
done

flutter pub get
