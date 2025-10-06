#!/usr/bin/env bats

setup_file() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=$(mktemp -d -t ddev-alfresco-test.XXXX)
  export DDEV_NON_INTERACTIVE=true
  cd ${TESTDIR}
  ddev config --project-name=test-alfresco --default-container-timeout=600
  echo "# Installing addon from ${DIR}"
  ddev add-on get ${DIR}
  ddev start -y
  ddev alfresco-wait
}

teardown_file() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "Unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy test-alfresco
  rm -rf ${TESTDIR}
}

setup() {
  cd ${TESTDIR}
}

@test "alfresco service is running" {
  run ddev exec -s alfresco echo "OK"
  [ "$status" -eq 0 ]
}

@test "postgres-alfresco service is running" {
  run ddev exec -s postgres-alfresco psql -U alfresco -c "SELECT 1"
  [ "$status" -eq 0 ]
}

@test "alfresco API is accessible" {
  run curl -k -s -f https://test-alfresco.ddev.site:8081/alfresco/s/api/server
  [ "$status" -eq 0 ]
  [[ "$output" == *"Alfresco"* ]]
}


@test "alfresco status command works" {
  run ddev alfresco-status
  [ "$status" -eq 0 ]
  [[ "$output" == *"Alfresco is running and ready"* ]]
}

@test "alfresco command defaults to bash" {
  run ddev alfresco pwd
  [ "$status" -eq 0 ]
  [[ "$output" == *"/usr/local/tomcat"* ]]
}

@test "alfresco logs are accessible" {
  run ddev logs -s alfresco
  [ "$status" -eq 0 ]
  [[ -n "$output" ]]
}
