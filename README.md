# containerized-bedrock-server

## Overview
This repository documents the deployment and operational hardening of a
Minecraft Bedrock Dedicated Server hosted on Ubuntu Linux and managed using
Docker Compose.

While the application itself is a game server, the focus of this project is
infrastructure reliability, automation, and maintainability. The goal was to
treat the service like a small production workload rather than a one-off
application.

---

## Architecture
- Host OS: Ubuntu Linux
- Container Runtime: Docker and Docker Compose
- Service: Minecraft Bedrock Dedicated Server
- Networking: UDP 19132 exposed via Docker
- Persistence: Host-mounted data volume
- Automation: Bash, cron, and systemd

World data, server configuration, and permissions are stored outside the
container to allow safe restarts and redeployments.

---

## Containerization Strategy
The server runs inside a Docker container with the following design goals:
- Automatic restart after crashes or host reboot
- Minimal manual intervention
- Clear separation between host OS and application runtime

Docker Compose defines the service, networking, restart policy, and environment
configuration. Persistent data is stored on the host to ensure world data
survives container recreation.

---

## Access Control
Administrative privileges are granted using Bedrock operator permissions.
Operators are able to:
- Modify gamerules
- Manage players
- Run server-side commands

Cheats are explicitly enabled at the server level to allow controlled
administrative actions. Authentication remains online-only using Microsoft /
Xbox identities.

---

## Automated Gamerule Enforcement
Some world settings are vulnerable to accidental or manual changes during
gameplay. To prevent configuration drift, a host-side automation script applies
a known-good set of gamerules after the server starts.

The script:
1. Waits for the containerized server to become ready
2. Applies predefined gamerules via console commands
3. Exits cleanly

This script is executed automatically at boot using systemd, ensuring
configuration consistency without manual intervention.

---

## Graceful Backup Strategy
Rather than stopping the server during backups, the project uses Bedrock’s
built-in save controls to perform live backups safely.

The backup process:
- Temporarily pauses world writes
- Confirms data has been flushed
- Archives persistent server data
- Resumes normal operation

Backups are timestamped and created automatically on a schedule using cron.
This approach minimizes player disruption and reduces the risk of data
corruption.

---

## Logging and Observability
Logs are handled through Docker’s logging system with rotation enabled to
prevent uncontrolled disk usage. Additional logs are generated for backup and
automation tasks to aid troubleshooting.

---

## Reliability Outcomes
The final system provides:
- Automatic recovery after crashes or reboots
- Safe, repeatable backups
- Predictable configuration enforcement
- Low operational overhead

From an operational perspective, the service behaves like a small, well-managed
Linux workload.

---

## Skills Demonstrated
- Linux system administration
- Docker and container lifecycle management
- Persistent storage handling
- Service automation with systemd and cron
- Backup design and validation
- Permission and access control
- Configuration drift mitigation

---

## Reflection
This project demonstrates how infrastructure principles apply even to small
services. Treating the server as a production-style workload reinforced best
practices around automation, resilience, and documentation, while providing a
practical environment for applying Linux and networking concepts.

---

This repository is provided for educational and portfolio purposes.
Scripts and configurations are intentionally simplified and sanitized.
