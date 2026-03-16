#!/bin/bash
# Question 15 – Validate: Fix Ingress PathType
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
echo " Validating Question 15"
echo "=============================="

check "File /root/fix-ingress.yaml exists" \
  "test -f /root/fix-ingress.yaml"

check "File no longer contains invalid pathType 'InvalidType'" \
  "grep -vq 'InvalidType' /root/fix-ingress.yaml"

FIXED_PATH_TYPE=$(grep 'pathType' /root/fix-ingress.yaml | awk '{print $2}' | tr -d '"' | head -1)
if [[ "$FIXED_PATH_TYPE" == "Prefix" || "$FIXED_PATH_TYPE" == "Exact" || "$FIXED_PATH_TYPE" == "ImplementationSpecific" ]]; then
  echo "  [PASS] pathType is a valid value: '$FIXED_PATH_TYPE'"
  ((PASS++))
else
  echo "  [FAIL] pathType '$FIXED_PATH_TYPE' is not a valid Kubernetes pathType"
  ((FAIL++))
fi

check "Ingress 'api-ingress' exists in namespace 'default' (manifest was applied)" \
  "kubectl get ingress api-ingress -n default"

check "Ingress path is /api" \
  "kubectl get ingress api-ingress -n default -o jsonpath='{.spec.rules[0].http.paths[0].path}' | grep -q '/api'"

check "Ingress backend service is api-svc" \
  "kubectl get ingress api-ingress -n default -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' | grep -q 'api-svc'"

check "Ingress backend port is 8080" \
  "kubectl get ingress api-ingress -n default -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' | grep -q '8080'"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
