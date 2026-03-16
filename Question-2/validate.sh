#!/bin/bash
# Question 2 – Validate: CronJob with Schedule and History Limits
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
echo " Validating Question 2"
echo "=============================="

check "CronJob 'backup-job' exists in namespace 'default'" \
  "kubectl get cronjob backup-job -n default"

SCHEDULE=$(kubectl get cronjob backup-job -n default -o jsonpath='{.spec.schedule}' 2>/dev/null)
check_val "Schedule is '*/30 * * * *'" "$SCHEDULE" "*/30 * * * *"

SUCCESS_LIMIT=$(kubectl get cronjob backup-job -n default -o jsonpath='{.spec.successfulJobsHistoryLimit}' 2>/dev/null)
check_val "successfulJobsHistoryLimit is 3" "$SUCCESS_LIMIT" "3"

FAIL_LIMIT=$(kubectl get cronjob backup-job -n default -o jsonpath='{.spec.failedJobsHistoryLimit}' 2>/dev/null)
check_val "failedJobsHistoryLimit is 2" "$FAIL_LIMIT" "2"

DEADLINE=$(kubectl get cronjob backup-job -n default -o jsonpath='{.spec.jobTemplate.spec.activeDeadlineSeconds}' 2>/dev/null)
check_val "activeDeadlineSeconds is 300" "$DEADLINE" "300"

IMAGE=$(kubectl get cronjob backup-job -n default -o jsonpath='{.spec.jobTemplate.spec.template.spec.containers[0].image}' 2>/dev/null)
check_val "Container image is 'busybox:latest'" "$IMAGE" "busybox:latest"

RESTART=$(kubectl get cronjob backup-job -n default -o jsonpath='{.spec.jobTemplate.spec.template.spec.restartPolicy}' 2>/dev/null)
check_val "restartPolicy is 'Never'" "$RESTART" "Never"

check "Container command includes 'echo'" \
  "kubectl get cronjob backup-job -n default -o yaml | grep -qE 'echo|Backup'"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
