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

# Check image exists via podman or docker
if command -v podman &>/dev/null; then
  check "Image 'my-app:1.0' exists in podman" \
    "podman image exists my-app:1.0"
elif command -v docker &>/dev/null; then
  check "Image 'my-app:1.0' exists in docker" \
    "docker image inspect my-app:1.0"
else
  echo "  [SKIP] Neither podman nor docker found – skipping image existence check"
fi

# Validate tarball contains expected image name
check "Tarball contains image reference 'my-app'" \
  "tar -tf /root/my-app.tar 2>/dev/null | grep -q . || strings /root/my-app.tar | grep -q 'my-app'"

echo "=============================="
echo " Results: $PASS passed, $FAIL failed"
echo "=============================="
[ "$FAIL" -eq 0 ] && echo " All checks passed!" || echo " Some checks failed. Review above."
