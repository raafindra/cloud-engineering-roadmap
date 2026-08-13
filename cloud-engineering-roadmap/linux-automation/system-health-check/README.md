# Linux Automation: System Health Check Script

An automated, production-ready Bash script designed to perform multi-component health checks on a Linux server. The script evaluates system resources and essential services, logs timestamped results to a dedicated log file, prints a clean summary report, and returns appropriate exit codes for seamless integration with downstream automation and monitoring tools.

---

## Project Overview

Maintaining server reliability requires continuous oversight of system resources and daemon status. This project provides a lightweight, dependency-free Bash automation tool that checks critical system health indicators—including disk usage, memory availability, and systemd services. 

It is engineered with a **collect-all-results** approach, meaning it executes all checks to completion even if one or more components fail.

---

## Objectives

* **Automate Monitoring:** Periodically assess core system parameters without manual intervention.
* **Enable Downstream Automation:** Return deterministic exit codes (`0` for Healthy, `1` for Unhealthy) to trigger alerting or self-healing pipelines.
* **Ensure Portability:** Dynamically resolve log paths relative to the script location, avoiding hardcoded personal paths.
* **Maintain Traceability:** Produce timestamped, hostname-tagged logs for historical auditing and troubleshooting.

---

## Architecture

The execution flow follows a sequential check-and-aggregate model:

[ START ]│├── set -u (Fail on unset variables)│├── Initialize Variables & Resolve Paths│     ├── HEALTH_STATUS=0│     ├── HOSTNAME=$(hostname)
│     └── LOG_FILE="${SCRIPT_DIR}/log/system_health_check.log"│├── check_disk()          ────────┐├── check_memory()        ────────┼──> Collect results in RESULTS array│                                 │    & update HEALTH_STATUS on failure└── Loop SERVICES         ────────┘├── check_service("ssh")├── check_service("cron")└── check_service("docker")│├── Print Summary Report (Formatted stdout)│└── Log Final Status & Exit (HEALTH_STATUS)
---

## Features

* **Modular Functions:** Reusable checking functions (e.g., `check_service()`) to maintain DRY (Don't Repeat Yourself) principles.
* **Loop Iteration:** Dynamically iterates through service arrays for scalable component checks.
* **Structured Logging:** Standardized log entries with timestamp, log level (`INFO`/`ERROR`/`WARN`), and system hostname.
* **Fallback & Warning Handling:** Emits explicit stderr warnings if writing to the log file fails instead of failing silently.
* **Cron-Safe Execution:** Uses absolute path resolution for portable, non-interactive execution via Cron.

---

## Health Check Criteria

| Component | Metric / Condition | Healthy Threshold | Unhealthy Condition |
| :--- | :--- | :--- | :--- |
| **Disk Usage** | Root Partition (`/`) Usage | $\le 90\%$ | $> 90\%$ |
| **Memory** | Available RAM Ratio | $\ge 70\%$ free | $< 70\%$ free |
| **SSH Service** | `sshd` / `ssh` status | `active (running)` | `inactive` / not found |
| **Cron Service** | `crond` / `cron` status | `active (running)` | `inactive` / not found |
| **Docker Service** | `docker` daemon status | `active (running)` | `inactive` / not found |

---

## Exit Code

The script uses standard POSIX exit codes to communicate the overall state to the calling shell or automation system:

| Exit Code | Status | Description |
| :---: | :--- | :--- |
| `0` | **HEALTHY** | All checks passed successfully. |
| `1` | **UNHEALTHY** | One or more checks failed (e.g., service down, low memory, or high disk usage). |

---

## Installation & Cron Configuration

### 1. Clone & Set Permissions

git clone [https://github.com/your-username/linux-automation.git](https://github.com/your-username/linux-automation.git)
cd linux-automation
chmod +x system_health_check.sh

### 2. Manual ExecutionBash# Standard execution (Displays output & logs to file)

# Standard execution (Displays output & logs to file)
./system_health_check.sh

# Quiet mode / Redirecting stderr & stdout
./system_health_check.sh >/dev/null 2>&1

### 3. Automated Cron Execution
To run the health check automatically every 15 minutes, add an entry to your crontab using absolute paths:

crontab -e

Add the following line:

*/15 * * * * /home/username/linux-automation/system_health_check.sh >/dev/null 2>&1

(Optional: For testing every 2 minutes, use */2 * * * *)

To verify that the job is registered:

crontab -l

Testing Scenarios
1. All Systems Healthy Test:
    - Ensure Docker, SSH, and Cron services are running.
    - Run ./system_health_check.sh.
    - Expected Result: Exit Code 0, Overall Status HEALTHY.

2. Single Service Failure Test (Fail-Collect-All):
    - Stop the Docker service temporarily: sudo systemctl stop docker
    - Run ./system_health_check.sh.
    - Expected Result: All other checks complete, Docker reports FAILED, Exit Code 1, Overall Status UNHEALTHY.
    - Restart Docker: sudo systemctl start docker

3. Log Permission Failure Test:
    - Remove write permissions from the log directory: chmod -w log/
    - Run ./system_health_check.sh.
    - Expected Result: Warning emitted to stderr ([WARN] Logging failed...), script execution finishes without crashing.

1. Sample Output
    - Terminal Output

    2026-08-10 10:40:01 [INFO] [srv-prod-01] Starting health check
    2026-08-10 10:40:01 [INFO] [srv-prod-01] Checking Disk Usage...
    2026-08-10 10:40:01 [INFO] [srv-prod-01] Disk usage is OK (42%)
    2026-08-10 10:40:01 [INFO] [srv-prod-01] Checking Memory Usage...
    2026-08-10 10:40:01 [INFO] [srv-prod-01] Memory availability is OK (78% free)
    2026-08-10 10:40:01 [INFO] [srv-prod-01] Checking ssh service...
    2026-08-10 10:40:01 [INFO] [srv-prod-01] ssh is running
    2026-08-10 10:40:01 [INFO] [srv-prod-01] Checking cron service...
    2026-08-10 10:40:01 [INFO] [srv-prod-01] cron is running
    2026-08-10 10:40:01 [INFO] [srv-prod-01] Checking docker service...
    2026-08-10 10:40:01 [ERROR] [srv-prod-01] docker is not running

    ========================================
                SUMMARY REPORT              
    ========================================
    Disk        : OK (42%)
    Memory      : OK (78% free)
    ssh         : OK
    cron        : OK
    docker      : FAILED
    ----------------------------------------
    2026-08-10 10:40:01 [ERROR] [srv-prod-01] Health check completed - OVERALL STATUS: UNHEALTHY
    ========================================


Lessons Learned
    - Fail-Fast vs. Collecting Results: Collecting all status metrics before exiting is crucial for health monitoring because operations teams need a full status overview, whereas fail-fast is better suited for linear deployment pipelines.
    - Cron Environment Isolation: Cron executes scripts with a minimal $PATH and an isolated working directory. Utilizing dynamic absolute paths ($(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)) ensures high portability across environments.
    - Nested Quote Pitfalls in Bash: Using associative array keys inside double-quoted parameter expansions (e.g., "${RESULTS["key"]}") causes parser syntax errors. Using unquoted keys (${RESULTS[key]}) avoids syntax ambiguity and unexpected EOF errors.
    -Explicit Error Handling: Replacing silent fallbacks (|| true) with stderr alerts provides visibility into infrastructure issues (e.g., log partition permission errors) without disrupting primary monitoring execution.