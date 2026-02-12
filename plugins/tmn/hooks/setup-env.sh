#!/bin/bash

# Capture environment before sourcing
ENV_BEFORE=$(env | sort)

# Source project-specific env file
source "$CLAUDE_PROJECT_DIR/.env.sh" 2>/dev/null || true

# Write new/changed variables to CLAUDE_ENV_FILE
if [ -n "$CLAUDE_ENV_FILE" ]; then
  ENV_AFTER=$(env | sort)
  # Find new or changed variables and write them
  comm -13 <(echo "$ENV_BEFORE") <(echo "$ENV_AFTER") >> "$CLAUDE_ENV_FILE"
fi

exit 0