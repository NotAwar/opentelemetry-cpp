#!/bin/bash


set -e

echo "Running Bazel tests for examples..."
# Ensure Bazelisk is installed or available
sudo apt-get update
sudo apt-get install -y bazelisk
bazelisk test //examples/...

echo "Running CMake tests for examples..."
sudo apt-get update
sudo apt-get install -y cmake

# Loop over each subdirectory in examples and run CMake tests if a CMakeLists.txt exists.
for d in examples/*/ ; do
  if [ -f "$d/CMakeLists.txt" ]; then
    echo "Building CMake project in $d"
    mkdir -p "$d/build"
    pushd "$d/build"
    cmake ..
    cmake --build .
    ctest --output-on-failure
    popd
  else
    echo "Skipping $d as no CMakeLists.txt found."
  fi
done
