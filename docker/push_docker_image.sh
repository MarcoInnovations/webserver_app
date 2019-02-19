#! /bin/bash
# Build and push docker image to repo (local and remote)
# 
# Run this script where your dockerfile is located for the 
#   docker image you want to create
#
# Used for 
#   * Region:  US-East-1
#   * Account: Transit account (090011926616)
#
# TODO:
#   * Add cmd-line argument for version to build (so ':latest' can be abandond)


if [ $# == 1 ]
then
    imagename=$1
else
    echo ""
    echo "Please provide image name"
    echo ""
    if [ -f last_used.txt ]; then cat last_used.txt; fi
    echo ""
    exit 1
fi

zz=0    # zz is used for counter
if [ -f dockerfile ]; then ((zz++)) ; fi    # https://stackoverflow.com/questions/8921441/sh-test-for-existence-of-files
if [ -f Dockerfile ]; then ((zz++)) ; fi    # https://askubuntu.com/questions/385528/how-to-increment-a-variable-in-bash
if [ -f DOCKERFILE ]; then ((zz++)) ; fi
if [ $zz = 0 ]; then 
  echo ""
  echo "No dockerfile found.  Check:"
  echo "  * Are you in the correct folder?"
  echo "  * Is there a docker project present?"
  echo "  * .....? "
  exit 1 
fi

var1=$(docker image ls |grep $imagename)
if [ -z "$var1" ]; then         # https://serverfault.com/questions/7503/how-to-determine-if-a-bash-variable-is-empty
    echo ""
    echo "$imagename is not known to local docker repo."
    read -p "Do you want to create a new repo? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

docker build --no-cache --pull -t $imagename .
rc=$?           # https://stackoverflow.com/questions/90418/exit-shell-script-based-on-process-exit-code
if [[ $rc != 0 ]]; then
    echo ""
    echo "  >>  Problem building docker image  <<"
    exit 1
fi
$(aws ecr get-login --no-include-email --region us-east-1 --profile devustransit)
docker tag $imagename:latest 090011926616.dkr.ecr.us-east-1.amazonaws.com/$imagename:latest
rc=$?
if [[ $rc != 0 ]]; then
    echo ""
    echo "  >>  Problem tagging docker image  <<"
    exit 1
fi
docker push 090011926616.dkr.ecr.us-east-1.amazonaws.com/$imagename:latest
rc=$?
if [[ $rc != 0 ]]; then
    echo ""
    echo " >>  Problem pushing image to amazon ECR  <<"
    exit 1
fi
echo ""
echo "$imagename is ready for deployment."
echo ""
echo "last used imagename:  $imagename" > last_used.txt