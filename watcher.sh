NS="sre"
DEPLOY="swype-app"
MAXNRORESTARTS=3

while true; do
  {
    NRORESTARTS=$(kubectl get pods -n ${NS} -l app=${DEPLOY} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
  } || {
    #only for start again the exercise
    echo "Starting swype app again"
    kubectl scale --replicas=1 deployment/${DEPLOY} -n ${NS}
  }

  echo "Current number of restarts: ${NRORESTARTS}"

  if (( NRORESTARTS > MAXNRORESTARTS )); then
    echo "Maximum number of restarts exceeded. Scaling down the deployment..."
    kubectl scale --replicas=0 deployment/${DEPLOY} -n ${NS}
    #break
  fi

  sleep 60
done