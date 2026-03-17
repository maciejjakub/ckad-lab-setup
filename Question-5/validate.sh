#!/bin/bash
# Question 5 – Validate: Build Container Image and Save as Tarball
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
echo " Validating Question 5"
echo "=============================="
 
check "Dockerfile exists at /root/app-source/Dockerfile" \
  "test -f /root/app-source/Dockerfile"
 
check "Tarball /root/my-app.tar exists" \
  "test -f /root/my-app.tar"
 
check "Tarball /root/my-app.tar is non-empty" \
  "test -s /root/my-app.tar"
 
# Check image exists via podman or docker.
# Podman tags images with 'localhost/' prefix by default (e.g. localhost/my-app:1.0),
# so we check both the short name and the fully-prefixed name.
if command -v podman &>/dev/null; then
  if podman image exists my-app:1.0 2>/dev/null || podman image exists localhost/my-app:1.0 2>/dev/null; then
    echo "  [PASS] Image 'my-app:1.0' exists in podman (may be stored as localhost/my-app:1.0)"
    ((PASS++))
  else
    echo "  [FAIL] Image 'my-app:1.0' not found in podman (checked both my-app:1.0 and localhost/my-app:1.0)"
    ((FAIL++))
  fi
elif command -v docker &>/dev/null; then
  check "Image 'my-app:1.0' exists in docker" \
    "docker image inspect my-app:1.0"
else
  echo "  [SKIP] Neither podman nor docker found – skipping image existence check"
fi
 
# Validate tarball contains expected image name.
# 'podman save' stores the manifest as JSON inside the tar — grep for my-app in it.
check "Tarball references 'my-app'" \
  "tar -xOf /root/my-app.tar 2>/dev/null | grep -q 'my-app' || strings /root/my-app.tar 2>/dev/null | grep -q 'my-app'"
 
echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
 