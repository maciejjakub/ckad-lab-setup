#!/bin/bash
# Question 11 – Validate: Pod and Container Security Context
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
echo " Validating Question 11"
echo "=============================="

check "Deployment 'secure-app' exists in namespace 'default'" \
  "kubectl get deployment secure-app -n default"

RUN_AS_USER=$(kubectl get deployment secure-app -n default \
  -o jsonpath='{.spec.template.spec.securityContext.runAsUser}' 2>/dev/null)
check_val "Pod-level runAsUser is 1000" "$RUN_AS_USER" "1000"

check "Container 'app' has securityContext.capabilities defined" \
  "kubectl get deployment secure-app -n default -o yaml | grep -q 'capabilities'"

check "Container 'app' adds NET_ADMIN capability" \
  "kubectl get deployment secure-app -n default -o yaml | grep -q 'NET_ADMIN'"

# Verify it's in capabilities.add (not just anywhere)
check "NET_ADMIN is under capabilities.add" \
  "kubectl get deployment secure-app -n default -o jsonpath='{.spec.template.spec.containers[0].securityContext.capabilities.add}' | grep -q 'NET_ADMIN'"

check "Deployment 'secure-app' rollout is complete" \
  "kubectl rollout status deployment/secure-app -n default --timeout=30s"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
