#!/bin/bash

container_id=$(docker ps -a | grep opnfv/functest | awk '{print $1}' | head -1)
if [ -z $container_id ]; then
    echo "Functest container not found"
    exit 1
fi

global_ret_val=0

tests=($(echo $FUNCTEST_SUITE_NAME | tr "," "\n"))
for test in ${tests[@]}; do
    cmd="python /home/opnfv/repos/functest/functest/ci/run_tests.py -t $test"
    docker exec $container_id $cmd
    let global_ret_val+=$?
done

exit $global_ret_val
