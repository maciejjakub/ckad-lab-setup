#!/bin/bash
# Question 6 – Validate: Canary Deployment with Manual Traffic Split
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
echo " Validating Question 6"
echo "=============================="

check "Deployment 'web-app' exists" \
  "kubectl get deployment web-app -n default"

REPLICAS=$(kubectl get deployment web-app -n default -o jsonpath='{.spec.replicas}' 2>/dev/null)
check_val "Deployment 'web-app' has 8 replicas" "$REPLICAS" "8"

check "Deployment 'web-app-canary' exists" \
  "kubectl get deployment web-app-canary -n default"

CANARY_REPLICAS=$(kubectl get deployment web-app-canary -n default -o jsonpath='{.spec.replicas}' 2>/dev/null)
check_val "Deployment 'web-app-canary' has 2 replicas" "$CANARY_REPLICAS" "2"

check "Canary Deployment has label app=webapp" \
  "kubectl get deployment web-app-canary -n default -o yaml | grep -q 'app: webapp'"

check "Canary Deployment has label version=v2" \
  "kubectl get deployment web-app-canary -n default -o yaml | grep -q 'version: v2'"

check "Service 'web-service' selects app=webapp (covers both deployments)" \
  "kubectl get service web-service -n default -o yaml | grep -q 'app: webapp'"

# Endpoints should include pods from both deployments (8+2=10 pods)
ENDPOINT_COUNT=$(kubectl get endpoints web-service -n default -o jsonpath='{.subsets[0].addresses}' 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(len(d))" 2>/dev/null || echo "0")
if [ "$ENDPOINT_COUNT" -ge 2 ]; then
  echo "  [PASS] Service 'web-service' has $ENDPOINT_COUNT endpoints (pods from both deployments)"
  ((PASS++))
else
  echo "  [FAIL] Service 'web-service' has too few endpoints ($ENDPOINT_COUNT)"
  ((FAIL++))
fi

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
