#!/bin/sh
set -x

NODE_ID=$(cat /node_hostname)
/usr/bin/aws-ebs-csi-driver \
  -v=5 \
  --drivername=aws-ebs-csi-driver \
  --nodeid=${NODE_ID} \
  --endpoint="unix:///run/docker/plugins/csi-aws-ebs.sock"
