# CKAD Practice Lab

> CKAD lab setup based on https://github.com/aravind4799/CKAD-Practice-Questions
> Hands-on practice questions for the **Certified Kubernetes Application Developer (CKAD)** exam.
> Each question folder contains a `setup.sh` to prepare the environment and a `validate.sh` to check your work.

---

## Repository Structure

```
ckad-prep/
├── Question-1/
│   ├── setup.sh       # Creates pre-existing resources described in the question
│   └── validate.sh    # Checks your solution is correct
├── Question-2/
│   ├── setup.sh
│   └── validate.sh
...
└── Question-16/
    ├── setup.sh
    └── validate.sh
```

---

## How to Use (Killercoda / any K8s playground)

**1. Clone or copy the repo into your environment**

```bash
git clone <your-repo-url>
cd ckad-prep
```

**2. Pick a question and run its setup script**

```bash
chmod +x Question-1/setup.sh
./Question-1/setup.sh
```

The setup script will create all pre-existing resources described in the question and print the task you need to complete.

**3. Solve the task** using `kubectl` commands.

**4. Validate your solution**

```bash
chmod +x Question-1/validate.sh
./validate.sh
```

Each check prints `[PASS]` or `[FAIL]` with a final score summary.

---

## Questions

| # | Topic | Namespace(s) |
|---|-------|-------------|
| [Q1](#question-1--create-secret-from-hardcoded-variables) | Create Secret from Hardcoded Variables | default |
| [Q2](#question-2--create-cronjob-with-schedule-and-history-limits) | Create CronJob with Schedule and History Limits | default |
| [Q3](#question-3--create-serviceaccount-role-and-rolebinding) | Create ServiceAccount, Role, and RoleBinding | audit |
| [Q4](#question-4--fix-broken-pod-with-correct-serviceaccount) | Fix Broken Pod with Correct ServiceAccount | monitoring |
| [Q5](#question-5--build-container-image-and-save-as-tarball) | Build Container Image and Save as Tarball | — |
| [Q6](#question-6--canary-deployment-with-manual-traffic-split) | Canary Deployment with Manual Traffic Split | default |
| [Q7](#question-7--fix-networkpolicy-by-updating-pod-labels) | Fix NetworkPolicy by Updating Pod Labels | network-demo |
| [Q8](#question-8--fix-broken-deployment-yaml) | Fix Broken Deployment YAML | default |
| [Q9](#question-9--rolling-update-and-rollback) | Rolling Update and Rollback | default |
| [Q10](#question-10--add-readiness-probe-to-deployment) | Add Readiness Probe to Deployment | default |
| [Q11](#question-11--configure-pod-and-container-security-context) | Configure Pod and Container Security Context | default |
| [Q12](#question-12--fix-service-selector) | Fix Service Selector | default |
| [Q13](#question-13--create-nodeport-service) | Create NodePort Service | default |
| [Q14](#question-14--create-ingress-resource) | Create Ingress Resource | default |
| [Q15](#question-15--fix-ingress-pathtype) | Fix Ingress PathType | default |
| [Q16](#question-16--add-resource-requests-and-limits-to-pod) | Add Resource Requests and Limits to Pod | prod |

---

## Question 1 – Create Secret from Hardcoded Variables

**Setup creates:** Deployment `api-server` in `default` with hardcoded env vars `DB_USER=admin` and `DB_PASS=Secret123!`.

**Your task:**
1. Create a Secret named `db-credentials` in `default` containing those credentials
2. Update Deployment `api-server` to reference the Secret via `valueFrom.secretKeyRef`

---

## Question 2 – Create CronJob with Schedule and History Limits

**Setup creates:** Nothing — clean namespace.

**Your task:**
Create a CronJob named `backup-job` in `default` with:
- Schedule: `*/30 * * * *`
- Image: `busybox:latest`, command: `echo "Backup completed"`
- `successfulJobsHistoryLimit: 3`, `failedJobsHistoryLimit: 2`
- `activeDeadlineSeconds: 300`, `restartPolicy: Never`

---

## Question 3 – Create ServiceAccount, Role, and RoleBinding

**Setup creates:** Namespace `audit` with Pod `log-collector` failing due to missing RBAC permissions.

**Your task:**
1. Create ServiceAccount `log-sa` in `audit`
2. Create Role `log-role` granting `get`, `list`, `watch` on `pods`
3. Create RoleBinding `log-rb` binding `log-role` to `log-sa`
4. Update Pod `log-collector` to use ServiceAccount `log-sa`

---

## Question 4 – Fix Broken Pod with Correct ServiceAccount

**Setup creates:** Namespace `monitoring` with ServiceAccounts (`monitor-sa`, `wrong-sa`, `admin-sa`), Roles, RoleBindings, and Pod `metrics-pod` incorrectly using `wrong-sa`.

**Your task:**
1. Investigate existing RBAC to identify which ServiceAccount has correct permissions
2. Update Pod `metrics-pod` to use the correct ServiceAccount (`monitor-sa`)

---

## Question 5 – Build Container Image and Save as Tarball

**Setup creates:** Directory `/root/app-source` with a valid `Dockerfile`.

**Your task:**
1. Build image `my-app:1.0` using `/root/app-source` as build context (podman or docker)
2. Save the image as a tarball to `/root/my-app.tar`

---

## Question 6 – Canary Deployment with Manual Traffic Split

**Setup creates:** Deployment `web-app` (5 replicas, `app=webapp, version=v1`) and Service `web-service` selecting `app=webapp`.

**Your task:**
1. Scale `web-app` to 8 replicas
2. Create Deployment `web-app-canary` with 2 replicas, labels `app=webapp, version=v2`
3. Verify both Deployments are selected by `web-service`

---

## Question 7 – Fix NetworkPolicy by Updating Pod Labels

**Setup creates:** Namespace `network-demo` with Pods `frontend`, `backend`, `database` having **wrong** labels, plus three NetworkPolicies implementing a deny-all + allow chain.

**Your task:**
Update Pod labels only (do NOT modify NetworkPolicies) to enable: `frontend → backend → database`

---

## Question 8 – Fix Broken Deployment YAML

**Setup creates:** `/root/broken-deploy.yaml` with two bugs: deprecated `apiVersion` and missing `selector`.

**Your task:**
1. Fix the apiVersion to `apps/v1`
2. Add the missing `selector.matchLabels` field
3. Apply the fixed manifest

---

## Question 9 – Rolling Update and Rollback

**Setup creates:** Deployment `app-v1` in `default` with image `nginx:1.20`.

**Your task:**
1. Update image to `nginx:1.25` and verify rollout
2. Roll back to the previous revision (`nginx:1.20`) and verify

---

## Question 10 – Add Readiness Probe to Deployment

**Setup creates:** Deployment `api-deploy` in `default` with container on port `8080`, no readiness probe.

**Your task:**
Add a readiness probe: HTTP GET `/ready` on port `8080`, `initialDelaySeconds: 5`, `periodSeconds: 10`.

---

## Question 11 – Configure Pod and Container Security Context

**Setup creates:** Deployment `secure-app` in `default` with no security context.

**Your task:**
1. Set Pod-level `securityContext.runAsUser: 1000`
2. Add container-level capability `NET_ADMIN` to the container named `app`

---

## Question 12 – Fix Service Selector

**Setup creates:** Deployment `web-app` (labels `app=webapp, tier=frontend`) and Service `web-svc` with incorrect selector `app=wrongapp`.

**Your task:**
Fix Service `web-svc` selector to `app=webapp` so it correctly targets `web-app` pods.

---

## Question 13 – Create NodePort Service

**Setup creates:** Deployment `api-server` with Pods labeled `app=api` on container port `9090`.

**Your task:**
Create Service `api-nodeport`: type `NodePort`, selector `app=api`, port `80` → targetPort `9090`.

---

## Question 14 – Create Ingress Resource

**Setup creates:** Deployment `web-deploy` and Service `web-svc` on port `8080`.

**Your task:**
Create Ingress `web-ingress`: host `web.example.com`, path `/` with `pathType: Prefix`, backend `web-svc:8080`.

---

## Question 15 – Fix Ingress PathType

**Setup creates:** `/root/fix-ingress.yaml` with invalid `pathType: InvalidType` and Service `api-svc`.

**Your task:**
1. Attempt to apply (observe the error)
2. Fix `pathType` to a valid value (`Prefix`, `Exact`, or `ImplementationSpecific`)
3. Apply the fixed manifest

---

## Question 16 – Add Resource Requests and Limits to Pod

**Setup creates:** Namespace `prod` with a ResourceQuota (`limits.cpu: 2`, `limits.memory: 4Gi`).

**Your task:**
Create Pod `resource-pod` with image `nginx:latest`, setting limits to **half** of the quota values and requests of at least `100m` CPU and `128Mi` memory.

---

## Tips for the CKAD Exam

- Use `kubectl explain <resource>.<field>` instead of memorising YAML structure
- Use `kubectl run`, `kubectl create`, and `--dry-run=client -o yaml` to generate boilerplate fast
- Use `kubectl label pod <name> key=value --overwrite` for quick label changes
- Export existing resources with `-o yaml > /tmp/file.yaml`, edit, delete original, then re-apply
- `kubectl rollout status`, `kubectl rollout history`, and `kubectl rollout undo` are your friends
- Always verify with `kubectl get`, `kubectl describe`, and `kubectl get endpoints`

Good luck! ⭐
