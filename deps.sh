#!/bin/bash

deps=(
    flutter_cache_manager
    cached_network_image
    # carousel_slider
    draw
    provider
    logger
    equatable
    clock
    intl
    share_plus
    # share_plus_linux
    url_launcher
    # url_launcher_linux
    persistent_bottom_nav_bar
    # meta
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
