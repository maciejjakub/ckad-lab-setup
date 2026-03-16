#!/bin/bash
if [ -f "/tmp/local-app.tar" ]; then
  echo "✅ Image archive found at /tmp/local-app.tar."
else
  echo "❌ Image archive missing."
fi