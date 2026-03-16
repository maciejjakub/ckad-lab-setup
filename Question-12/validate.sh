#!/bin/bash
# Question 12 – Validate: Fix Service Selector
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

echo "=============================="
echo " Validating Question 12"
echo "=============================="

check "Service 'web-svc' exists in namespace 'default'" \
  "kubectl get service web-svc -n default"

SELECTOR=$(kubectl get service web-svc -n default -o jsonpath='{.spec.selector.app}' 2>/dev/null)
if [ "$SELECTOR" = "webapp" ]; then
  echo "  [PASS] Service selector app=webapp (correct)"
  ((PASS++))
else
  echo "  [FAIL] Service selector app=$SELECTOR (expected: webapp)"
  ((FAIL++))
fi

check "Service selector is NOT app=wrongapp" \
  "kubectl get service web-svc -n default -o jsonpath='{.spec.selector.app}' | grep -vq 'wrongapp'"

# Endpoints should now be populated
ENDPOINT_ADDRS=$(kubectl get endpoints web-svc -n default -o jsonpath='{.subsets[0].addresses}' 2>/dev/null)
if [ -n "$ENDPOINT_ADDRS" ] && [ "$ENDPOINT_ADDRS" != "null" ]; then
  echo "  [PASS] Service 'web-svc' endpoints are populated (pointing to web-app pods)"
  ((PASS++))
else
  echo "  [FAIL] Service 'web-svc' has no endpoints (selector may still be wrong)"
  ((FAIL++))
fi

check "Deployment 'web-app' still exists and is available" \
  "kubectl get deployment web-app -n default"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
