# HR Namespace

---

## 1. Overview

The `hr` namespace represents a simulated Human Resources department deployed inside a Kubernetes cluster as part of the Honex Honeynet research project.

This environment models a realistic enterprise HR infrastructure including backend services, isolated databases, and employee workstations designed for deception and attacker behavior analysis.

---

## 2. Architectural Overview

All components are deployed under:

```
Namespace: hr
```

This ensures:

* Logical isolation
* Resource containment
* Controlled monitoring
* Easy teardown

## Architecture Diagram
![HR Architecture](assets/architecture.png)
---

## 3. System Components

### 3.1 Backend Microservices

| Service            | Port | Database      | Purpose             |
| ------------------ | ---- | ------------- | ------------------- |
| employee-service   | 8081 | employee-db   | Employee profiles   |
| attendance-service | 8083 | attendance-db | Attendance tracking |
| payroll-service    | 8084 | payroll-db    | Salary processing   |

Each service is deployed as a Kubernetes Deployment and exposed internally via ClusterIP.

---

### 3.2 Database Layer

Each backend service uses:

* Dedicated MySQL StatefulSet
* 2Gi PersistentVolumeClaim
* Kubernetes Secret for credentials

### Security Design Principle

Workstations **never connect directly to databases**.
All communication flows through service APIs to mimic real enterprise architecture.

---

## 4. HR Workstations (Deception Layer)

Each employee workstation is deployed as a Pod but intentionally designed to appear as a real Linux endpoint.

### Base Image

```
honex/hr-workstation:v2
```

### Installed Tools

* curl
* ping
* traceroute
* netstat
* nmap
* tcpdump
* vim / nano
* htop
* samba
* cups
* rsyslog
* cron

Kubernetes or container tooling is intentionally excluded.

---

## 5. Workstation Roles

### HR Recruiter

* Username: alice.hr
* Hostname: HONEX-HR-REC-PC01
* Open Port: 3000
* Target Service: employee-service
* Artifacts:

  * CV files
  * Interview notes
  * HR email cache

---

### HR Clerk

* Username: mohamed.hr
* Hostname: HONEX-HR-CLK-PC07
* Open Port: 631 (Printer simulation)
* Target Service: attendance-service
* Artifacts:

  * Attendance CSV files
  * To-do notes
  * Manager reminders

---

### Payroll Officer

* Username: sara.hr
* Hostname: HONEX-HR-PAY-PC12
* Open Port: 445 (File sharing simulation)
* Target Service: payroll-service
* Artifacts:

  * Payroll previews
  * Finance notes
  * Credential hint files

---

## 6. Identity & Behavior Modeling

A single workstation image is reused across roles.

Behavioral uniqueness is defined via environment variables:

| Variable       | Purpose            |
| -------------- | ------------------ |
| USERNAME       | Employee identity  |
| ROLE           | HR role            |
| HOSTNAME       | Realistic hostname |
| OPEN_PORT      | Listening service  |
| TARGET_SERVICE | Backend API        |

Realism enhancements include:

* Role-specific `.bash_history`
* Randomized file timestamps
* Background processes (office-sync, outlook-cache, printer-agent)
* Periodic internal API traffic

---

## 7. Attacker Perspective

From an attacker’s viewpoint:

* Workstations behave like real endpoints
* Service discovery reveals internal APIs
* No visible Kubernetes artifacts
* Lateral movement is possible

The deception layer maintains realism while preserving isolation.

---

## 8. Deployment

From project root:

```bash
kubectl apply -f hr/k8s/
```

Verify:

```bash
kubectl get all -n hr
```

---

## 9. Conclusion

The HR namespace successfully simulates a high-value enterprise department inside Kubernetes while preserving deception principles and research integrity.

It balances:

* Realism
* Isolation
* Observability
* Expandability

