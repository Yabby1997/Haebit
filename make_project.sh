#!/bin/bash

execute_command() {
    echo "----------------------------------------"
    echo "🚀 $1"
    $2
    if [ $? -eq 0 ]; then
        echo "✨ Success"
    else
        echo "🚨 Failure"
        exit 1
    fi
}

fetch_dependencies() {
    execute_command "Fetching external dependencies..." "tuist fetch"
}

cache_all() {
    execute_command "Caching xcframeworks..." "tuist cache warm -x"
    execute_command "Cleaining old caches..." "clean_old_cache"
}

cache_except() {
    execute_command "Caching xcframeworks..." "tuist cache warm -x --dependencies-only $1"
    execute_command "Cleaining old caches..." "clean_old_cache"
}

generate_target() {
    execute_command "Generating project $1..." "tuist generate -x $1"
}

generate_target_without_cache() {
    execute_command "Generating project $1 without cache..." "tuist generate $1"
}

cache_directory="$HOME/.tuist/Cache/BuildCache"
disabled_cache_folder="$cache_directory/temp"
original_cache_folder=""

disable_cache() {
    original_cache_folder=$(find "$cache_directory" -type d -name "$1" -exec dirname {} \;)
    execute_command "Disabling $1..." "mv $original_cache_folder $disabled_cache_folder"
}

restore_cache() {
    execute_command "Restoring $1..." "mv $disabled_cache_folder $original_cache_folder"
}

clean_old_cache() {
    find "$cache_directory" -type d -name "*.xcframework" | while read -r framework; do
        base_name=$(basename "$framework")
        duplicates=($(find "$cache_directory" -type d -name "$base_name"))

        if [ ${#duplicates[@]} -gt 1 ]; then
            latest_file=""
            latest_time=0

            for file in "${duplicates[@]}"; do
                parent_dir=$(dirname "$file")
                file_time=$(stat -f "%m" "$parent_dir")

                if [ "$file_time" -gt "$latest_time" ]; then
                    latest_time=$file_time
                    latest_file=$parent_dir
                fi
            done

            for file in "${duplicates[@]}"; do
                parent_dir=$(dirname "$file")
                if [ "$parent_dir" != "$latest_file" ]; then
                    echo "Deleting old cache: $file"
                    rm -rf "$parent_dir"
                else
                    echo "Keeping latest cache: $file"
                fi
            done
        fi
    done
}

execute_option() {
    case $1 in
        1)
            fetch_dependencies
            cache_all
            generate_target "HaebitDev"
            ;;
        2)
            fetch_dependencies
            cache_all
            generate_target "Haebit"
            ;;
        3)
            cd LightMeterFeature || exit
            fetch_dependencies
            disable_cache "LightMeterFeature.xcframework"
            cache_except "LightMeterFeature"
            generate_target "LightMeterFeatureDemo"
            restore_cache "LightMeterFeature"
            cd - || exit
            ;;
        4)
            cd LightMeterFeature || exit
            fetch_dependencies
            generate_target_without_cache "LightMeterFeatureDemo"
            cd - || exit
            ;;
        5)
            cd FilmLogFeature || exit
            fetch_dependencies
            disable_cache "FilmLogFeature.xcframework"
            cache_except "FilmLogFeature"
            generate_target "FilmLogFeatureDemo"
            restore_cache "FilmLogFeature"
            cd - || exit
            ;;
        6)
            cd FilmLogFeature || exit
            fetch_dependencies
            generate_target_without_cache "FilmLogFeatureDemo"
            cd - || exit
            ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac
}

echo "🎯 Choose a target to make project:"
echo "1. HaebitDev"
echo "2. Haebit"
echo "3. LightMeterFeature"
echo "4. LightMeterFeature (without cache)"
echo "5. FilmLogFeature"
echo "6. FilmLogFeature (without cache)"
echo ""
read -p "Enter your target: " choice
execute_option $choice
