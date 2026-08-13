# ⚙️ Service Management (`systemctl`)

A reference guide for managing, inspecting, and troubleshooting `systemd` services in production environments.

---

## 🚀 Essential Service Control Commands

| Action | Command | Use Case / Context |
| :--- | :--- | :--- |
| **Check Status** | `sudo systemctl status <service>` | View current state, PID, memory usage, and recent log snippets. |
| **Restart** | `sudo systemctl restart <service>` | Completely stops and starts the service (causes brief downtime). |
| **Graceful Reload** | `sudo systemctl reload <service>` | Reloads configuration without dropping active connections (e.g., Nginx). |
| **Enable Auto-start** | `sudo systemctl enable <service>` | Ensures the service starts automatically upon server reboot. |
| **Disable Auto-start** | `sudo systemctl disable <service>` | Prevents the service from starting automatically on boot. |

---

## 🔍 Inspection & Diagnostics

```bash
# Verify if a service is actively running (returns 'active' or 'inactive')
systemctl is-active nginx

# Check if a service is set to launch on boot (returns 'enabled' or 'disabled')
systemctl is-enabled nginx

# List all failed services across the system
systemctl --failed

# View the full unit file configuration (useful for checking environment variables and paths)
systemctl cat nginx

# Mask a service to completely prevent it from being started manually or automatically
sudo systemctl mask apache2

⚠️ Rule #1 of Incident Response:

Never blindly run systemctl restart on a failing service in production. Always inspect journalctl or log files first to diagnose the root cause—restarting without checking can erase temporary state evidence or create cascading failures.