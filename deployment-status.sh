if ! kubectl get ns sidi-gassama; then
    kubectl create ns sidi-gassama
fi

if ! kubectl rollout status deployment sample-spring-boot -n sidi-gassama; then
    kubectl apply -f kubernetes.yml
fi