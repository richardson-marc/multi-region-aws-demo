#!/bin/bash
for region in `aws ec2 describe-regions --output text |cut -f3`; do aws ec2 describe-instances --region $region --query 'Reservations[*].Instances[*].[InstanceId,LaunchTime,InstanceType,Tags[?Key==`Name`].Value|[0],State.Name,PublicIpAddress,Placement.AvailabilityZone]' --output text | column -t|grep ovp; done
