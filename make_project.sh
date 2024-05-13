#!/bin/bash

execute_tuist_command() {
    echo "Executing command: $1"
    $1
    if [ $? -eq 0 ]; then
        echo "✨ Success"
    else
        echo "🚨 Failure"
        exit 1
    fi
}

cache_directory="$HOME/.tuist/Cache/BuildCache"
disabled_cache_folder="$cache_directory/temp"
original_cache_folder=""

disable_cache() {
    original_cache_folder=$(find "$cache_directory" -type d -name "$1" -exec dirname {} \;)
    if [ -n "$original_cache_folder" ]; then
        mv "$original_cache_folder" "$disabled_cache_folder"
        echo "Cache $1 disabled."
    else
        echo "Cache not found."
    fi
}

restore_cache() {
    if [ -n "$disabled_cache_folder" ]; then
        mv "$disabled_cache_folder" "$original_cache_folder"
        echo "Cache $1 restored successfully."
    else
        echo "Disabled cache not found."
    fi
}

# Function to execute commands for each option
execute_option() {
    case $1 in
        1)
            execute_tuist_command "tuist fetch"
            execute_tuist_command "tuist cache warm -x"
            execute_tuist_command "tuist generate -x HaebitDev"
            ;;
        2)
            execute_tuist_command "tuist fetch"
            execute_tuist_command "tuist cache warm -x"
            execute_tuist_command "tuist generate -x Haebit"
            ;;
        3)
            cd LightMeterFeature || exit
            execute_tuist_command "tuist fetch"
            disable_cache "LightMeterFeature.xcframework"
            execute_tuist_command "tuist cache warm -x LightMeterFeature --dependencies-only"
            execute_tuist_command "tuist generate -x LightMeterFeatureDemo"
            restore_cache "LightMeterFeature.xcframework"
            cd - || exit
            ;;
        4)
            cd LightMeterFeature || exit
            execute_tuist_command "tuist fetch"
            execute_tuist_command "tuist generate LightMeterFeatureDemo"
            cd - || exit
            ;;
        5)
            cd FilmLogFeature || exit
            execute_tuist_command "tuist fetch"
            disable_cache "FilmLogFeature.xcframework"
            execute_tuist_command "tuist cache warm -x FilmLogFeature --dependencies-only"
            execute_tuist_command "tuist generate -x FilmLogFeatureDemo"
            restore_cache "FilmLogFeature.xcframework"
            cd - || exit
            ;;
        6)
            cd FilmLogFeature || exit
            execute_tuist_command "tuist fetch"
            execute_tuist_command "tuist generate FilmLogFeatureDemo"
            cd - || exit
            ;;
        *)
            echo "Invalid option. Exiting."
            exit 1
            ;;
    esac
}

echo "Choose a target:"
echo "1. HaebitDev"
echo "2. Haebit"
echo "3. LightMeterFeature"
echo "4. LightMeterFeature (without cache)"
echo "5. FilmLogFeature"
echo "6. FilmLogFeature (without cache)"

read -p "Enter your target: " choice

execute_option $choice

