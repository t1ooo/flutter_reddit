#!/bin/bash

deps=(
    markdown
    quiver
    youtube_player_flutter
    flutter_secure_storage
    uni_links
    responsive_framework
    video_player
    chewie
    carousel_slider
    dart_vlc
    flutter_markdown
    path_provider
    alfred
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
