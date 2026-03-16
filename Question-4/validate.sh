#!/bin/bash
# Question 4 – Validate: Fix Broken Pod with Correct ServiceAccount
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
echo " Validating Question 4"
echo "=============================="

check "Pod 'metrics-pod' exists in namespace 'monitoring'" \
  "kubectl get pod metrics-pod -n monitoring"

SA=$(kubectl get pod metrics-pod -n monitoring -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)

if [ "$SA" = "monitor-sa" ]; then
  echo "  [PASS] Pod uses correct ServiceAccount 'monitor-sa'"
  ((PASS++))
else
  echo "  [FAIL] Pod uses ServiceAccount '$SA' (expected: 'monitor-sa')"
  ((FAIL++))
fi

check "Pod is NOT using 'wrong-sa'" \
  "kubectl get pod metrics-pod -n monitoring -o jsonpath='{.spec.serviceAccountName}' | grep -vq 'wrong-sa'"

check "Pod 'metrics-pod' is Running" \
  "kubectl get pod metrics-pod -n monitoring -o jsonpath='{.status.phase}' | grep -q Running"

check "ServiceAccount 'monitor-sa' still exists" \
  "kubectl get serviceaccount monitor-sa -n monitoring"

check "RoleBinding 'monitor-binding' still references 'monitor-sa'" \
  "kubectl get rolebinding monitor-binding -n monitoring -o yaml | grep -q 'monitor-sa'"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
