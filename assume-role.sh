#!/usr/bin/env bash
set -e
set -u

main() {
  local role="${AWS_ASSUME_ROLE_ARN}"
  local duration="${AWS_ASSUME_ROLE_DURATION:-3600}"
  local region="${AWS_ASSUME_ROLE_REGION:-""}"

  if [[ -n $role ]]; then
    echo "~~~ Assuming IAM role $role ..."
    local exports; exports="$(assume_role_credentials "$role" "$duration" | credentials_json_to_shell_exports)"
    eval "$exports"

    echo "Exported session credentials:"
    echo "  AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
    echo "  AWS_SECRET_ACCESS_KEY=(${#AWS_SECRET_ACCESS_KEY} chars)"
    echo "  AWS_SESSION_TOKEN=(${#AWS_SESSION_TOKEN} chars)"

    if [[ -n $region ]]; then
      export AWS_REGION="$region"
      export AWS_DEFAULT_REGION="$region"
      echo "  AWS_REGION=$AWS_REGION"
      echo "  AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"
    fi

  else
    echo >&2 "Missing AWS_ASSUME_ROLE_ROLE  or AWS_ASSUME_ROLE_ARN"
  fi
}

# Assume the IAM role $1, for duration $3, and allocate a session name derived from $2.
# output: the Credentials portion of the AWS response JSON;
#     {
#         "SecretAccessKey": "foo"
#         "SessionToken": "bar",
#         "Expiration": "...",
#         "AccessKeyId": "baz"
#     }
assume_role_credentials() {#!/usr/bin/env bash
set -e
set -u

main() {
  local role="${AWS_ASSUME_ROLE_ARN}"
  local duration="${AWS_ASSUME_ROLE_DURATION:-3600}"
  local region="${AWS_ASSUME_ROLE_REGION:-""}"

  if [[ -n $role ]]; then
    echo "~~~ Assuming IAM role $role ..."
    local exports; exports="$(assume_role_credentials "$role" "$duration" | credentials_json_to_shell_exports)"
    eval "$exports"

    echo "Exported session credentials:"
    echo "  AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
    echo "  AWS_SECRET_ACCESS_KEY=(${#AWS_SECRET_ACCESS_KEY} chars)"
    echo "  AWS_SESSION_TOKEN=(${#AWS_SESSION_TOKEN} chars)"

    if [[ -n $region ]]; then
      export AWS_REGION="$region"
      export AWS_DEFAULT_REGION="$region"
      echo "  AWS_REGION=$AWS_REGION"
      echo "  AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION"
    fi

  else
    echo >&2 "Missing AWS_ASSUME_ROLE_ROLE  or AWS_ASSUME_ROLE_ARN"
  fi
}

# Assume the IAM role $1, for duration $3, and allocate a session name derived from $2.
# output: the Credentials portion of the AWS response JSON;
#     {
#         "SecretAccessKey": "foo"
#         "SessionToken": "bar",
#         "Expiration": "...",
#         "AccessKeyId": "baz"
#     }
assume_role_credentials() {
  local role="$1"
  local duration="$2"
  aws sts assume-role \
    --role-arn "$role" \
    --role-session-name "aws-assume-role-${role}-${duration}" \
    --duration-seconds "$duration" \
    --query Credentials
}

# Convert credentials JSON to shell export statements using standard CLI tools
# input:
#     {
#         "SecretAccessKey": "foo"
#         "SessionToken": "bar",
#         "Expiration": "...",
#         "AccessKeyId": "baz"
#     }
# output:
#     export AWS_SECRET_ACCESS_KEY="foo"
#     export AWS_SESSION_TOKEN="bar"
#     export AWS_ACCESS_KEY_ID="baz"
credentials_json_to_shell_exports() {
  sed \
    -e 's/ *"\(.*\)": \(".*"\),*/\1=\2/g' \
    -e 's/^SecretAccessKey/export AWS_SECRET_ACCESS_KEY/' \
    -e 's/^AccessKeyId/export AWS_ACCESS_KEY_ID/' \
    -e 's/^SessionToken/export AWS_SESSION_TOKEN/' \
    | grep "^export AWS"
}

main
  local role="$1"
  local duration="$2"
  aws sts assume-role \
    --role-arn "$role" \
    --role-session-name "aws-assume-role-${role}-${duration}" \
    --duration-seconds "$duration" \
    --query Credentials
}

# Convert credentials JSON to shell export statements using standard CLI tools
# input:
#     {
#         "SecretAccessKey": "foo"
#         "SessionToken": "bar",
#         "Expiration": "...",
#         "AccessKeyId": "baz"
#     }
# output:
#     export AWS_SECRET_ACCESS_KEY="foo"
#     export AWS_SESSION_TOKEN="bar"
#     export AWS_ACCESS_KEY_ID="baz"
credentials_json_to_shell_exports() {
  sed \
    -e 's/ *"\(.*\)": \(".*"\),*/\1=\2/g' \
    -e 's/^SecretAccessKey/export AWS_SECRET_ACCESS_KEY/' \
    -e 's/^AccessKeyId/export AWS_ACCESS_KEY_ID/' \
    -e 's/^SessionToken/export AWS_SESSION_TOKEN/' \
    | grep "^export AWS"
}

main