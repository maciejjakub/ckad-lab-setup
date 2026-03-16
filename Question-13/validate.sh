#!/bin/bash
# Question 13 – Validate: Create NodePort Service
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
echo " Validating Question 13"
echo "=============================="

check "Service 'api-nodeport' exists in namespace 'default'" \
  "kubectl get service api-nodeport -n default"

SVC_TYPE=$(kubectl get service api-nodeport -n default -o jsonpath='{.spec.type}' 2>/dev/null)
check_val "Service type is NodePort" "$SVC_TYPE" "NodePort"

SELECTOR=$(kubectl get service api-nodeport -n default -o jsonpath='{.spec.selector.app}' 2>/dev/null)
check_val "Service selector is app=api" "$SELECTOR" "api"

PORT=$(kubectl get service api-nodeport -n default -o jsonpath='{.spec.ports[0].port}' 2>/dev/null)
check_val "Service port is 80" "$PORT" "80"

TARGET_PORT=$(kubectl get service api-nodeport -n default -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)
check_val "Service targetPort is 9090" "$TARGET_PORT" "9090"

NODE_PORT=$(kubectl get service api-nodeport -n default -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
if [ -n "$NODE_PORT" ] && [ "$NODE_PORT" -gt 0 ] 2>/dev/null; then
  echo "  [PASS] NodePort assigned: $NODE_PORT"
  ((PASS++))
else
  echo "  [FAIL] No NodePort assigned"
  ((FAIL++))
fi

check "Service endpoints include api-server pods" \
  "kubectl get endpoints api-nodeport -n default -o jsonpath='{.subsets[0].addresses}' | grep -q ."

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
