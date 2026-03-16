#!/bin/bash
# Question 16 – Validate: Resource Requests and Limits
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

# Convert memory strings to Mi for comparison
to_mi() {
  local val="$1"
  if echo "$val" | grep -q 'Gi'; then
    echo $(echo "$val" | sed 's/Gi//' | awk '{print $1 * 1024}')
  elif echo "$val" | grep -q 'Mi'; then
    echo "$val" | sed 's/Mi//'
  elif echo "$val" | grep -q 'G'; then
    echo $(echo "$val" | sed 's/G//' | awk '{print $1 * 1024}')
  else
    echo "$val"
  fi
}

# Convert CPU to millicores
to_millicores() {
  local val="$1"
  if echo "$val" | grep -q 'm'; then
    echo "$val" | sed 's/m//'
  else
    echo $(echo "$val" | awk '{print $1 * 1000}')
  fi
}

echo "=============================="
echo " Validating Question 16"
echo "=============================="

check "Namespace 'prod' exists" \
  "kubectl get namespace prod"

check "ResourceQuota 'prod-quota' exists in namespace 'prod'" \
  "kubectl get resourcequota prod-quota -n prod"

check "Pod 'resource-pod' exists in namespace 'prod'" \
  "kubectl get pod resource-pod -n prod"

IMAGE=$(kubectl get pod resource-pod -n prod \
  -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
if [[ "$IMAGE" == "nginx:latest" || "$IMAGE" == "nginx" ]]; then
  echo "  [PASS] Pod image is nginx:latest"
  ((PASS++))
else
  echo "  [FAIL] Pod image is '$IMAGE' (expected: nginx:latest)"
  ((FAIL++))
fi

# Check CPU request >= 100m
CPU_REQ=$(kubectl get pod resource-pod -n prod \
  -o jsonpath='{.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
CPU_REQ_M=$(to_millicores "$CPU_REQ")
if [ -n "$CPU_REQ_M" ] && [ "$CPU_REQ_M" -ge 100 ] 2>/dev/null; then
  echo "  [PASS] CPU request is ${CPU_REQ} (>= 100m)"
  ((PASS++))
else
  echo "  [FAIL] CPU request '$CPU_REQ' is too low or not set (need >= 100m)"
  ((FAIL++))
fi

# Check memory request >= 128Mi
MEM_REQ=$(kubectl get pod resource-pod -n prod \
  -o jsonpath='{.spec.containers[0].resources.requests.memory}' 2>/dev/null)
MEM_REQ_MI=$(to_mi "$MEM_REQ")
if [ -n "$MEM_REQ_MI" ] && [ "$MEM_REQ_MI" -ge 128 ] 2>/dev/null; then
  echo "  [PASS] Memory request is ${MEM_REQ} (>= 128Mi)"
  ((PASS++))
else
  echo "  [FAIL] Memory request '$MEM_REQ' is too low or not set (need >= 128Mi)"
  ((FAIL++))
fi

# Check CPU limit <= 1000m (half of 2)
CPU_LIM=$(kubectl get pod resource-pod -n prod \
  -o jsonpath='{.spec.containers[0].resources.limits.cpu}' 2>/dev/null)
CPU_LIM_M=$(to_millicores "$CPU_LIM")
if [ -n "$CPU_LIM_M" ] && [ "$CPU_LIM_M" -le 1000 ] && [ "$CPU_LIM_M" -gt 0 ] 2>/dev/null; then
  echo "  [PASS] CPU limit is ${CPU_LIM} (<= 1000m, which is half of quota 2)"
  ((PASS++))
else
  echo "  [FAIL] CPU limit '$CPU_LIM' should be <= 1 (1000m), half of the quota limit of 2"
  ((FAIL++))
fi

# Check memory limit <= 2048Mi (half of 4Gi)
MEM_LIM=$(kubectl get pod resource-pod -n prod \
  -o jsonpath='{.spec.containers[0].resources.limits.memory}' 2>/dev/null)
MEM_LIM_MI=$(to_mi "$MEM_LIM")
if [ -n "$MEM_LIM_MI" ] && [ "$MEM_LIM_MI" -le 2048 ] && [ "$MEM_LIM_MI" -gt 0 ] 2>/dev/null; then
  echo "  [PASS] Memory limit is ${MEM_LIM} (<= 2Gi, which is half of quota 4Gi)"
  ((PASS++))
else
  echo "  [FAIL] Memory limit '$MEM_LIM' should be <= 2Gi, half of the quota limit of 4Gi"
  ((FAIL++))
fi

check "Pod 'resource-pod' is Running" \
  "kubectl get pod resource-pod -n prod -o jsonpath='{.status.phase}' | grep -q Running"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
