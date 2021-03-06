#!/bin/bash
# running an ec2 instance from the cli
# example assumes you already have a VPC, subnet and IDs setup

export AWS_DEFAULT_REGION="eu-west-1"
export subnetId="subnet-0600b8836a6d9a5ee"
export securityGroupId="sg-0cb09424b588f4ba9"
# aws linux 2, eu-west-1, 2020-12-02
export imageId="ami-0ce1e3f77cd41957e"
export instanceRole="ec2-for-ssm"
export serverName="jujhar-soc-demo-${RANDOM}"
export keyName="jujhar-id-rsa"

echo "Creating ${serverName} in ${AWS_DEFAULT_REGION}"

aws ec2 run-instances \
    --subnet-id "${subnetId}" \
    --instance-type c5.large \
    --count 1 \
    --security-group-ids "${securityGroupId}" \
    --associate-public-ip-address \
    --image-id "${imageId}" \
    --key-name "${keyName}" \
    --iam-instance-profile Name="${instanceRole}" \
    --tag-specifications ResourceType=instance,Tags="[{Key=Name,Value=${serverName}}]" \
    --user-data $"#!/bin/bash
                    # install node js
                    curl --silent --location https://rpm.nodesource.com/setup_14.x | bash -
                    yum -y install nodejs
                    # install our "app"
                    (cd / && curl -O https://raw.githubusercontent.com/jujhars13/birmingham-school-of-code-aws-day/main/server/index.js)
                    # run our app on port 80 (only works as root )
                    port=80 node /index.js
                    "
