```text
┌──────────────────────────────────────────────────────┐
│                 Tier 1 – Presentation                │
│              React + TypeScript (Nginx :80)          │
└────────────────────────────┬─────────────────────────┘
                             ▼
┌──────────────────────────────────────────────────────┐
│                 Tier 2 – Application                 │
│              API Gateway (Node.js :3000)             │
│   ┌─────────────┬─────────────┬─────────────┬        |
│   ▼             ▼             ▼             ▼        │
│ User        Project        Task      Notification    │
│ Service     Service       Service      Service       │
│ Go:8001   Python:8002    Go:8003    Python:8004      │
└────┬──────────┬───────────┬───────────┬──────────────┘
     ▼          ▼           ▼           ▼
┌────────────────────────────────────────────────────────┐
│                    Tier 3 – Data                       │
│             AWS RDS PostgreSQL Instance                │
│  users_db | projects_db | tasks_db | notifications_db  │
└────────────────────────────────────────────────────────┘
```
