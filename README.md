# TaskFlow: Production-Ready Microservices Application on AWS EKS

TaskFlow is a highly scalable, fault-tolerant, 3-Tier microservices application designed for task and project management.

The entire infrastructure is provisioned using Infrastructure as Code (IaC) via Terraform, deployed onto AWS EKS (Elastic Kubernetes Service), and managed using GitOps best practices with ArgoCD.

---

## System Architecture

The application is split into three decoupled tiers to ensure high availability, independent scaling, and security isolation.

```text
┌─────────────────────────────────────────────────────────┐
│                 Tier 1 – Presentation                  │
│              React + TypeScript (Nginx :80)            │
└────────────────────────────┬────────────────────────────┘
                             │
                          /api/*
                             │
                             ▼
                    AWS ALB via Ingress
                             │
                             ▼
┌─────────────────────────────────────────────────────────┐
│                 Tier 2 – Application                   │
│                                                        │
│              API Gateway (Node.js :3000)              │
│                                                        │
│   ┌─────────────┬─────────────┬─────────────┬────────┐ │
│   ▼             ▼             ▼             ▼        │ │
│ User        Project        Task      Notification    │ │
│ Service     Service       Service      Service       │ │
│ Go:8001   Python:8002    Go:8003    Python:8004      │ │
└────┬──────────┬───────────┬───────────┬──────────────┘
     │          │           │           │
     ▼          ▼           ▼           ▼

┌─────────────────────────────────────────────────────────┐
│                    Tier 3 – Data                       │
│             AWS RDS PostgreSQL Instance                │
│                                                        │
│  users_db | projects_db | tasks_db | notifications_db │
└─────────────────────────────────────────────────────────┘
```

### Component Breakdown

#### Frontend Tier

* React
* TypeScript
* Nginx
* Port 80

#### API Gateway

* Node.js
* Reverse Proxy
* Port 3000

#### Microservices

##### User Service

* Language: Go
* Port: 8001
* Responsibility: Authentication & User Management

##### Project Service

* Language: Python
* Port: 8002
* Responsibility: Project Management

##### Task Service

* Language: Go
* Port: 8003
* Responsibility: Task Lifecycle Management

##### Notification Service

* Language: Python
* Port: 8004
* Responsibility: Notifications & Alerts

#### Database Tier

AWS RDS PostgreSQL hosting isolated databases:

* users_db
* projects_db
* tasks_db
* notifications_db

---

## Tech Stack & Infrastructure

### Infrastructure

* Terraform
* AWS VPC
* AWS EKS
* IAM Roles

### Container Registry

* Amazon ECR

### Kubernetes

* EKS
* AWS Load Balancer Controller
* ALB Ingress

### CI/CD

* GitHub Actions
* ArgoCD

---

## CI/CD Pipeline & GitOps Workflow

### Continuous Integration (GitHub Actions)

On every push to the `main` branch:

1. Linting & Code Quality Checks
2. Unit Testing
3. Docker Image Build
4. AWS Authentication
5. Push Images to Amazon ECR

### Continuous Delivery (ArgoCD)

ArgoCD continuously monitors the desired state stored in Git and synchronizes the cluster automatically.

---

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│
├── terraform/
│   ├── modules/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── kubernetes/
│   ├── frontend/
│   ├── api-gateway-svc/
│   ├── user-svc/
│   ├── project-svc/
│   ├── task-svc/
│   ├── notification-svc/
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── jwt-secret.yaml
│   ├── ingress.yaml
│   └── db-job.yaml
│
├── frontend/
├── api-gateway/
├── user-service/
├── project-service/
├── task-service/
└── notification-service/
```

---

## Production Notes

### Database Connectivity

AWS RDS PostgreSQL is used as the primary database layer.

Each microservice owns its dedicated database schema to maintain loose coupling and service independence.

### Networking

The AWS Load Balancer Controller provisions an Application Load Balancer (ALB) automatically.

Traffic flow:

```text
Internet --->  AWS ALB ---> Ingress ---> Frontend / API Gateway ---> Microservices ---> RDS PostgreSQL
```

---

## Deployment Guide

### Prerequisites

* AWS CLI
* Terraform >= 1.5
* kubectl
* Helm
* Docker

---

### 1. Provision Infrastructure

```bash
cd terraform

terraform init

terraform plan

terraform apply
```

---

### 2. Configure kubectl

```bash
aws eks update-kubeconfig \
  --region us-east-1 \
  --name TaskFlow-App-Cluster
```

---

### 3. Deploy Kubernetes Resources

```bash
kubectl apply -f kubernetes/
```

---

### 4. Install AWS Load Balancer Controller

```bash
helm repo add eks https://aws.github.io/eks-charts

helm repo update

helm install aws-load-balancer-controller \
  eks/aws-load-balancer-controller \
  -n kube-system
```

---

### 5. Install ArgoCD

```bash
kubectl create namespace argocd

kubectl apply -n argocd \
-f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

