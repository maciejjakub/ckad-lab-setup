#!/bin/bash
# Question 14 – Validate: Create Ingress Resource
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
echo " Validating Question 14"
echo "=============================="

check "Ingress 'web-ingress' exists in namespace 'default'" \
  "kubectl get ingress web-ingress -n default"

check "Ingress uses networking.k8s.io/v1 API" \
  "kubectl get ingress web-ingress -n default -o yaml | grep -q 'networking.k8s.io/v1'"

HOST=$(kubectl get ingress web-ingress -n default \
  -o jsonpath='{.spec.rules[0].host}' 2>/dev/null)
check_val "Ingress host is web.example.com" "$HOST" "web.example.com"

PATH_VAL=$(kubectl get ingress web-ingress -n default \
  -o jsonpath='{.spec.rules[0].http.paths[0].path}' 2>/dev/null)
check_val "Ingress path is /" "$PATH_VAL" "/"

PATH_TYPE=$(kubectl get ingress web-ingress -n default \
  -o jsonpath='{.spec.rules[0].http.paths[0].pathType}' 2>/dev/null)
check_val "Ingress pathType is Prefix" "$PATH_TYPE" "Prefix"

BACKEND_SVC=$(kubectl get ingress web-ingress -n default \
  -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.name}' 2>/dev/null)
check_val "Backend service is web-svc" "$BACKEND_SVC" "web-svc"

BACKEND_PORT=$(kubectl get ingress web-ingress -n default \
  -o jsonpath='{.spec.rules[0].http.paths[0].backend.service.port.number}' 2>/dev/null)
check_val "Backend service port is 8080" "$BACKEND_PORT" "8080"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
