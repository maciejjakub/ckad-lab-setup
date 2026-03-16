#!/bin/bash
# Question 7 – Validate: Fix NetworkPolicy by Updating Pod Labels
PASS=0
FAIL=0

check() {
  local desc="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc"
    ((FAIL++))
  fi
}

check_val() {
  local desc="$1"
  local got="$2"
  local expected="$3"
  if [ "$got" = "$expected" ]; then
    echo "  [PASS] $desc"
    ((PASS++))
  else
    echo "  [FAIL] $desc (got: '$got', expected: '$expected')"
    ((FAIL++))
  fi
}

echo "=============================="
echo " Validating Question 7"
echo "=============================="

FRONTEND_ROLE=$(kubectl get pod frontend -n network-demo -o jsonpath='{.metadata.labels.role}' 2>/dev/null)
check_val "Pod 'frontend' has label role=frontend" "$FRONTEND_ROLE" "frontend"

BACKEND_ROLE=$(kubectl get pod backend -n network-demo -o jsonpath='{.metadata.labels.role}' 2>/dev/null)
check_val "Pod 'backend' has label role=backend" "$BACKEND_ROLE" "backend"

DB_ROLE=$(kubectl get pod database -n network-demo -o jsonpath='{.metadata.labels.role}' 2>/dev/null)
check_val "Pod 'database' has label role=db" "$DB_ROLE" "db"

# NetworkPolicies should NOT have been modified
check "NetworkPolicy 'deny-all' unchanged" \
  "kubectl get networkpolicy deny-all -n network-demo"

check "NetworkPolicy 'allow-frontend-to-backend' still selects role=backend" \
  "kubectl get networkpolicy allow-frontend-to-backend -n network-demo -o yaml | grep -q 'role: backend'"

check "NetworkPolicy 'allow-backend-to-db' still selects role=db" \
  "kubectl get networkpolicy allow-backend-to-db -n network-demo -o yaml | grep -q 'role: db'"

check "All 3 Pods are still Running" \
  "kubectl get pods -n network-demo -o jsonpath='{.items[*].status.phase}' | tr ' ' '\n' | grep -v Running | wc -l | grep -q '^0$'"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
