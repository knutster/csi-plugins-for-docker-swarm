#!/bin/bash

ORG=public.ecr.aws/a0u6y2f5/swarm-csi-plugin
VERSION=1.11.4

sudo rm -rf rootfs
docker plugin disable aws-ebs-csi:latest
docker plugin rm aws-ebs-csi:latest
docker plugin disable $ORG/aws-ebs:v$VERSION
docker plugin rm $ORG/aws-ebs:v$VERSION
docker rm -vf rootfsimage

docker create --name rootfsimage public.ecr.aws/ebs-csi-driver/aws-ebs-csi-driver:v$VERSION
mkdir -p rootfs
docker export rootfsimage | tar -x -C rootfs
docker rm -vf rootfsimage

sudo docker plugin create $ORG/aws-ebs:v$VERSION .
docker plugin enable $ORG/aws-ebs:v$VERSION
docker plugin push $ORG/aws-ebs:v$VERSION
docker plugin disable $ORG/aws-ebs:v$VERSION
docker plugin rm $ORG/aws-ebs:v$VERSION
docker plugin install --alias aws-ebs-csi --grant-all-permissions $ORG/aws-ebs:v$VERSION
