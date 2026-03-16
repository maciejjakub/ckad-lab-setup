#!/bin/bash
# Question 10 – Validate: Add Readiness Probe to Deployment
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
echo " Validating Question 10"
echo "=============================="

check "Deployment 'api-deploy' exists in namespace 'default'" \
  "kubectl get deployment api-deploy -n default"

check "Deployment has a readinessProbe defined" \
  "kubectl get deployment api-deploy -n default -o yaml | grep -q 'readinessProbe'"

PROBE_PATH=$(kubectl get deployment api-deploy -n default \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null)
check_val "readinessProbe path is '/ready'" "$PROBE_PATH" "/ready"

PROBE_PORT=$(kubectl get deployment api-deploy -n default \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.port}' 2>/dev/null)
check_val "readinessProbe port is 8080" "$PROBE_PORT" "8080"

INITIAL_DELAY=$(kubectl get deployment api-deploy -n default \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.initialDelaySeconds}' 2>/dev/null)
check_val "initialDelaySeconds is 5" "$INITIAL_DELAY" "5"

PERIOD=$(kubectl get deployment api-deploy -n default \
  -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.periodSeconds}' 2>/dev/null)
check_val "periodSeconds is 10" "$PERIOD" "10"

check "Deployment 'api-deploy' rollout is complete" \
  "kubectl rollout status deployment/api-deploy -n default --timeout=30s"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
