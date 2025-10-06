#!/usr/bin/env bash

# Test runner script for dev-toolkit
# Makes it easy to run tests with common options

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Change to project root
cd "$PROJECT_ROOT"

# Check if bats is installed
if ! command -v bats >/dev/null 2>&1; then
  echo -e "${RED}❌ bats is not installed${NC}"
  echo ""
  echo "Install bats:"
  echo "  macOS:   brew install bats-core"
  echo "  Linux:   See https://github.com/bats-core/bats-core#installation"
  exit 1
fi

# Print header
echo -e "${BLUE}🧪 Dev Toolkit Test Runner${NC}"
echo ""

# Parse arguments
VERBOSE=false
TIMING=false
TEST_PATH="tests/"

while [[ $# -gt 0 ]]; do
  case $1 in
    -v|--verbose)
      VERBOSE=true
      shift
      ;;
    -t|--timing)
      TIMING=true
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS] [TEST_PATH]"
      echo ""
      echo "Options:"
      echo "  -v, --verbose    Show verbose output (TAP format)"
      echo "  -t, --timing     Show timing information"
      echo "  -h, --help       Show this help message"
      echo ""
      echo "Examples:"
      echo "  $0                           # Run all tests"
      echo "  $0 tests/unit/              # Run unit tests only"
      echo "  $0 tests/unit/core/test-simple.bats  # Run specific test"
      echo "  $0 --verbose tests/         # Run with verbose output"
      exit 0
      ;;
    *)
      TEST_PATH="$1"
      shift
      ;;
  esac
done

# Build bats command
BATS_CMD="bats"

if [ "$VERBOSE" = true ]; then
  BATS_CMD="$BATS_CMD --tap"
fi

if [ "$TIMING" = true ]; then
  BATS_CMD="$BATS_CMD --timing"
fi

# Run tests
echo -e "${YELLOW}Running tests: $TEST_PATH${NC}"
echo ""

if $BATS_CMD "$TEST_PATH"; then
  echo ""
  echo -e "${GREEN}✅ All tests passed!${NC}"
  exit 0
else
  echo ""
  echo -e "${RED}❌ Some tests failed${NC}"
  echo ""
  echo "Tips:"
  echo "  • Run with --verbose for more details"
  echo "  • Check docs/troubleshooting/testing-issues.md"
  echo "  • Run specific test file to isolate issues"
  exit 1
fi
