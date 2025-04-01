#!/bin/bash
set -euo pipefail

npx nuxi build
cd .output/server && zip -r ../../lambda.zip .
