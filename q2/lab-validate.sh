#!/bin/bash
CJ=$(kubectl get cronjob dice -n project-hamster -o json)
SCHEDULE=$(echo $CJ | jq -r '.spec.schedule')
LIMIT=$(echo $CJ | jq -r '.spec.successfulJobsHistoryLimit')

if [[ "$SCHEDULE" == "*/30 * * * *" ]] && [[ "$LIMIT" == "3" ]]; then
  echo "✅ CronJob configured correctly."
else
  echo "❌ CronJob configuration mismatch."
fi