# usage: 'source ./assume_role.sh' from command prompt

assume_role=$(aws sts assume-role --role-arn arn:aws:iam::595052274509:role/fgam6-mgmt_cross_account_role --role-session-name temp3-session)

export AWS_ACCESS_KEY_ID=$(echo $assume_role | jq -r .Credentials.AccessKeyId) && export AWS_SECRET_ACCESS_KEY=$(echo $assume_role | jq -r .Credentials.SecretAccessKey) && export AWS_SESSION_TOKEN=$(echo $assume_role | jq -r .Credentials.SessionToken)

