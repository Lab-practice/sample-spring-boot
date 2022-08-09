if ! kubectl get ns sidi_gassama; then
    kubectl create ns sidi_gassama
fi

if ! kubectl rollout status deployment sample-spring-boot -n sidi_gassama; then
    kubectl apply -f kubernetes.yml
fi