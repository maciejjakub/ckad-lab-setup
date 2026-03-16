#!/bin/bash
CAN_I=$(kubectl auth can-i list services --as=system:serviceaccount:auth:default -n auth)
if [[ "$CAN_I" == "yes" ]]; then
  echo "✅ Permissions fixed."
else
  echo "❌ Still unable to list services."
fi