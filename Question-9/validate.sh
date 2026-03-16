#!/bin/bash
# Question 9 – Validate: Rolling Update and Rollback
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
echo " Validating Question 9"
echo "=============================="

check "Deployment 'app-v1' exists in namespace 'default'" \
  "kubectl get deployment app-v1 -n default"

IMAGE=$(kubectl get deployment app-v1 -n default -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
if [ "$IMAGE" = "nginx:1.20" ]; then
  echo "  [PASS] Deployment image is nginx:1.20 (rollback successful)"
  ((PASS++))
else
  echo "  [FAIL] Deployment image is '$IMAGE' (expected: nginx:1.20 after rollback)"
  ((FAIL++))
fi

check "Deployment 'app-v1' rollout is complete" \
  "kubectl rollout status deployment/app-v1 -n default --timeout=30s"

HISTORY=$(kubectl rollout history deployment/app-v1 -n default 2>/dev/null | grep -c 'nginx\|revision' || true)
REVISION_COUNT=$(kubectl rollout history deployment/app-v1 -n default 2>/dev/null | tail -n +3 | grep -c .)
if [ "$REVISION_COUNT" -ge 2 ]; then
  echo "  [PASS] Rollout history shows $REVISION_COUNT revisions (update + rollback recorded)"
  ((PASS++))
else
  echo "  [FAIL] Expected at least 2 revisions in rollout history (got: $REVISION_COUNT)"
  ((FAIL++))
fi

check "Pods for 'app-v1' are running" \
  "kubectl get pods -n default -l app=app-v1 --field-selector=status.phase=Running | grep -q app-v1"

check "All 3 replicas are available" \
  "kubectl get deployment app-v1 -n default -o jsonpath='{.status.availableReplicas}' | grep -q '3'"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
