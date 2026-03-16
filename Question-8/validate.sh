#!/bin/bash
# Question 8 – Validate: Fix Broken Deployment YAML
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
echo " Validating Question 8"
echo "=============================="

check "File /root/broken-deploy.yaml exists" \
  "test -f /root/broken-deploy.yaml"

check "Fixed file uses apiVersion: apps/v1" \
  "grep -q 'apps/v1' /root/broken-deploy.yaml"

check "Fixed file does NOT use deprecated extensions/v1beta1" \
  "grep -vq 'extensions/v1beta1' /root/broken-deploy.yaml"

check "Fixed file contains a 'selector' field" \
  "grep -q 'selector' /root/broken-deploy.yaml"

check "Fixed file contains 'matchLabels'" \
  "grep -q 'matchLabels' /root/broken-deploy.yaml"

check "Deployment 'broken-app' exists in namespace 'default'" \
  "kubectl get deployment broken-app -n default"

API=$(kubectl get deployment broken-app -n default -o jsonpath='{.apiVersion}' 2>/dev/null)
check "Deployment uses apps/v1 API (live resource)" \
  "kubectl get deployment broken-app -n default -o yaml | grep -q 'apiVersion: apps/v1'"

check "Deployment 'broken-app' has 2 replicas" \
  "kubectl get deployment broken-app -n default -o jsonpath='{.spec.replicas}' | grep -q '2'"

check "Deployment 'broken-app' rollout is complete" \
  "kubectl rollout status deployment/broken-app -n default --timeout=60s"

check "Pods for 'broken-app' are running" \
  "kubectl get pods -n default -l app=myapp --field-selector=status.phase=Running | grep -q myapp"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
