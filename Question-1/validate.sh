#!/bin/bash
# Question 1 – Validate: Secret from Hardcoded Variables
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
echo " Validating Question 1"
echo "=============================="

# 1. Secret exists
check "Secret 'db-credentials' exists in namespace 'default'" \
  "kubectl get secret db-credentials -n default"

# 2. Secret has DB_USER key
check "Secret contains key 'DB_USER'" \
  "kubectl get secret db-credentials -n default -o jsonpath='{.data.DB_USER}' | grep -q ."

# 3. Secret has DB_PASS key
check "Secret contains key 'DB_PASS'" \
  "kubectl get secret db-credentials -n default -o jsonpath='{.data.DB_PASS}' | grep -q ."

# 4. Secret value for DB_USER is correct (base64 of 'admin')
EXPECTED_USER=$(echo -n "admin" | base64)
check "Secret DB_USER value is 'admin'" \
  "kubectl get secret db-credentials -n default -o jsonpath='{.data.DB_USER}' | grep -q '$EXPECTED_USER'"

# 5. Secret value for DB_PASS is correct (base64 of 'Secret123!')
EXPECTED_PASS=$(echo -n "Secret123!" | base64)
check "Secret DB_PASS value is 'Secret123!'" \
  "kubectl get secret db-credentials -n default -o jsonpath='{.data.DB_PASS}' | grep -q '$EXPECTED_PASS'"

# 6. Deployment still exists
check "Deployment 'api-server' still exists" \
  "kubectl get deployment api-server -n default"

# 7. Deployment uses secretKeyRef for DB_USER
check "Deployment uses secretKeyRef for DB_USER" \
  "kubectl get deployment api-server -n default -o yaml | grep -A3 'name: DB_USER' | grep -q 'secretKeyRef'"

# 8. Deployment uses secretKeyRef for DB_PASS
check "Deployment uses secretKeyRef for DB_PASS" \
  "kubectl get deployment api-server -n default -o yaml | grep -A3 'name: DB_PASS' | grep -q 'secretKeyRef'"

# 9. SecretKeyRef points to correct secret name
check "SecretKeyRef references secret 'db-credentials'" \
  "kubectl get deployment api-server -n default -o yaml | grep -q 'name: db-credentials'"

# 10. Deployment is available/rolled out
check "Deployment 'api-server' rollout is complete" \
  "kubectl rollout status deployment/api-server -n default --timeout=30s"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
