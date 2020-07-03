#!/usr/bin/env bash

jupyter lab --ip $(hostname) --LabApp.base_url=/proxy/$OAR_JOB_ID --no-browser --LabApp.token='' --LabApp.password='' &

#
# build OAR.job_id.proxy.json
# 
JUPYTER_PID=$!
echo JUPYTER_PID $JUPYTER_PID

nb_lines=0

# wait jupyter is ready and build OAR.job_id.proxy.json
until [ $nb_lines -gt 0 ]
do      
    jupyter notebook list --json | jq -c "select( .pid | contains($JUPYTER_PID) )" > OAR.$OAR_JOB_ID.proxy.json
    nb_lines=$(< OAR.$OAR_JOB_ID.proxy.json wc -l)
    sleep 1
done

wait $JUPYTER_PID
