#!/bin/bash

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "===== MAVEN BUILD STARTED ====="

cd "$PROJECT_ROOT/app"

mvn clean package

echo "===== MAVEN BUILD COMPLETED ====="