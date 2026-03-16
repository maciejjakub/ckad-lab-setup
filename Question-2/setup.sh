#!/bin/bash
# Question 2 – Create CronJob with Schedule and History Limits
# No pre-existing resources required for this question.

echo "[setup] Namespace 'default' is ready."
echo ""
echo "[setup] Your task: Create a CronJob named 'backup-job' in namespace 'default' with:"
echo "  - Schedule: */30 * * * *"
echo "  - Image: busybox:latest"
echo "  - Command: echo \"Backup completed\""
echo "  - successfulJobsHistoryLimit: 3"
echo "  - failedJobsHistoryLimit: 2"
echo "  - activeDeadlineSeconds: 300"
echo "  - restartPolicy: Never"
