### 1. Configure kubectl

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name TaskFlow-App-Cluster
```

---

### 1. Deploy Kubernetes Resources

```bash
kubectl apply -f kubernetes/
```

---

### 3. Install AWS Load Balancer Controller

```bash
helm repo add eks https://aws.github.io/eks-charts

helm repo update

helm install aws-load-balancer-controller \
  eks/aws-load-balancer-controller \
  -n kube-system
```

---

### 4. Install ArgoCD

```bash
kubectl create namespace argocd

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
