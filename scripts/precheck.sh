#!/usr/bin/env bash
# precheck.sh — deterministic pre-publish checks for fidgetflo
#
# Usage:
#   bash scripts/precheck.sh
#
# Checks:
#   1. Git-tracked secret files (.env, .pem, .key, etc.)
#   2. Git-tracked .env files (any path)
#   3. Stale brand strings ("ruflo") in source files
#   4. npm audit (high/critical only)
#   5. package.json files[] includes skills/
#   6. Hardcoded API key patterns in source
#
# Exits 0 if all checks pass. Exits 1 if any check fails.

set -uo pipefail

PASS=0
FAIL=0
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

check_pass() { echo -e "  ${GREEN}✓${NC} $1"; ((PASS++)) || true; }
check_fail() { echo -e "  ${RED}✗${NC} $1"; ((FAIL++)) || true; }
check_warn() { echo -e "  ${YELLOW}⚠${NC} $1"; }

echo ""
echo -e "${BOLD}─── FidgetFlo Pre-Publish Checks ───${NC}"
echo ""

# 1. Git-tracked secret files
echo "1. Git-tracked secret files"
TRACKED_SECRETS=$(git ls-files 2>/dev/null | grep -iE '\.(env|key|pem|secret|credentials|p12|pfx|keystore)$' || true)
if [ -n "$TRACKED_SECRETS" ]; then
  check_fail "Secret files tracked in git:"
  echo "$TRACKED_SECRETS" | sed 's/^/     /'
else
  check_pass "No secret files tracked in git"
fi

# 2. Git-tracked .env files (any name containing .env, excluding .env.example)
echo ""
echo "2. Git-tracked .env files"
TRACKED_ENV=$(git ls-files 2>/dev/null | grep -E '\.env' | grep -vE '\.env\.example$' || true)
if [ -n "$TRACKED_ENV" ]; then
  check_fail ".env files tracked in git:"
  echo "$TRACKED_ENV" | sed 's/^/     /'
else
  check_pass "No .env files tracked in git (.env.example files excluded)"
fi

# 3. Stale brand strings ("ruflo") in source
# Excludes: CREDITS, ATTRIBUTION (attribution docs), install.sh (user-facing docs),
#           CHANGELOG (historical record), and README (has intentional upstream refs)
echo ""
echo "3. Stale 'ruflo' brand strings in source"
RUFLO_HITS=$(grep -ril "ruflo" \
  --include="*.ts" \
  --include="*.js" \
  --include="*.sh" \
  --include="*.json" \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  --exclude-dir=ruflo \
  . 2>/dev/null || true)
RUFLO_HITS_FILTERED=$(echo "$RUFLO_HITS" | grep -vE '(CREDITS|ATTRIBUTION|README|CHANGELOG|scripts/install\.sh|scripts/precheck\.sh)' | grep -v '^$' || true)
if [ -n "$RUFLO_HITS_FILTERED" ]; then
  check_fail "Stale 'ruflo' strings in source — grep these files:"
  echo "$RUFLO_HITS_FILTERED" | sed 's/^/     /'
  check_warn "Run: grep -rn 'ruflo' <file> to see exact lines"
else
  check_pass "No stale 'ruflo' strings in source"
fi

# 4. npm audit (high/critical)
echo ""
echo "4. npm audit (high/critical)"
AUDIT_OUT=$(npm audit --audit-level high 2>&1 || true)
if echo "$AUDIT_OUT" | grep -qiE "(critical|high)" ; then
  check_fail "npm audit found high/critical vulnerabilities"
  echo "$AUDIT_OUT" | grep -iE "(critical|high|vulnerabilit)" | head -8 | sed 's/^/     /'
else
  check_pass "npm audit clean (no high/critical)"
fi

# 5. package.json files[] includes skills/
echo ""
echo "5. package.json files[] includes skills/"
if [ -f "package.json" ]; then
  FILES_ARRAY=$(node -e "const p=require('./package.json'); console.log((p.files||[]).join('\n'));" 2>/dev/null || true)
  if echo "$FILES_ARRAY" | grep -q "skills"; then
    check_pass "skills/ present in package.json files[]"
  else
    check_fail "skills/ missing from package.json files[] — f* skill family won't be installed by users"
  fi
else
  check_warn "No package.json found — skipping files[] check"
fi

# 6. Hardcoded API key patterns in source
echo ""
echo "6. Hardcoded API key patterns in source"
SECRET_PATTERNS='(sk-[a-zA-Z0-9]{20,}|AIzaSy[a-zA-Z0-9_-]{30,}|AKIA[0-9A-Z]{16}|ghp_[a-zA-Z0-9]{36}|pk_live_[a-zA-Z0-9]+|sk_live_[a-zA-Z0-9]+|xox[bpsa]-[a-zA-Z0-9-]+)'
SECRET_HITS=$(grep -ril -E "$SECRET_PATTERNS" \
  --include="*.ts" --include="*.js" --include="*.sh" --include="*.json" \
  --exclude-dir=node_modules --exclude-dir=.git \
  . 2>/dev/null || true)
SECRET_HITS_FILTERED=$(echo "$SECRET_HITS" | grep -vE '\.(test|spec|example)\.' | grep -vE '(detect-secrets|manifest-validator|security-compliance|precheck\.sh)' | grep -v '^$' || true)
if [ -n "$SECRET_HITS_FILTERED" ]; then
  check_fail "Potential hardcoded API keys found:"
  echo "$SECRET_HITS_FILTERED" | sed 's/^/     /'
else
  check_pass "No hardcoded API key patterns found"
fi

# Summary
echo ""
echo -e "${BOLD}─── Results ───${NC}"
echo ""

if [ "$FAIL" -gt 0 ]; then
  echo -e "  ${RED}${BOLD}FAILED${NC} — ${FAIL} check(s) failed, ${PASS} passed"
  echo -e "  Fix the above before publishing."
  echo ""
  exit 1
else
  echo -e "  ${GREEN}${BOLD}PASSED${NC} — all ${PASS} checks passed"
  echo ""
  exit 0
fi
