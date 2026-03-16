#!/bin/bash
# Question 3 – Validate: ServiceAccount, Role, and RoleBinding
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
echo " Validating Question 3"
echo "=============================="

check "ServiceAccount 'log-sa' exists in namespace 'audit'" \
  "kubectl get serviceaccount log-sa -n audit"

check "Role 'log-role' exists in namespace 'audit'" \
  "kubectl get role log-role -n audit"

check "Role 'log-role' has verb 'get' on pods" \
  "kubectl get role log-role -n audit -o yaml | grep -q 'get'"

check "Role 'log-role' has verb 'list' on pods" \
  "kubectl get role log-role -n audit -o yaml | grep -q 'list'"

check "Role 'log-role' has verb 'watch' on pods" \
  "kubectl get role log-role -n audit -o yaml | grep -q 'watch'"

check "Role 'log-role' applies to resource 'pods'" \
  "kubectl get role log-role -n audit -o yaml | grep -q 'pods'"

check "RoleBinding 'log-rb' exists in namespace 'audit'" \
  "kubectl get rolebinding log-rb -n audit"

check "RoleBinding 'log-rb' references role 'log-role'" \
  "kubectl get rolebinding log-rb -n audit -o yaml | grep -q 'log-role'"

check "RoleBinding 'log-rb' binds ServiceAccount 'log-sa'" \
  "kubectl get rolebinding log-rb -n audit -o yaml | grep -q 'log-sa'"

check "Pod 'log-collector' exists in namespace 'audit'" \
  "kubectl get pod log-collector -n audit"

SA=$(kubectl get pod log-collector -n audit -o jsonpath='{.spec.serviceAccountName}' 2>/dev/null)
if [ "$SA" = "log-sa" ]; then
  echo "  [PASS] Pod 'log-collector' uses ServiceAccount 'log-sa'"
  ((PASS++))
else
  echo "  [FAIL] Pod 'log-collector' uses ServiceAccount '$SA' (expected: 'log-sa')"
  ((FAIL++))
fi

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
