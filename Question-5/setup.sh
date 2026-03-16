#!/bin/bash
# Question 5 – Build Container Image with Podman and Save as Tarball
# Sets up: /root/app-source directory with a valid Dockerfile

echo "[setup] Creating /root/app-source directory with a Dockerfile..."
mkdir -p /root/app-source

cat > /root/app-source/Dockerfile <<'EOF'
FROM busybox:latest
LABEL maintainer="ckad-practice"
RUN echo "App source build" > /app-info.txt
CMD ["cat", "/app-info.txt"]
EOF

echo "[setup] Dockerfile created at /root/app-source/Dockerfile"
cat /root/app-source/Dockerfile

echo ""
echo "[setup] Done! Your task:"
echo "  1. Build a container image named 'my-app:1.0' using /root/app-source as build context"
echo "     Use: podman build -t my-app:1.0 /root/app-source"
echo "       or: docker build  -t my-app:1.0 /root/app-source"
echo "  2. Save the image as a tarball to /root/my-app.tar"
echo "     Use: podman save -o /root/my-app.tar my-app:1.0"
echo "       or: docker save  -o /root/my-app.tar my-app:1.0"
