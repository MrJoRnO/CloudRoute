# URL Shortener DevOps Project

## Sub-task 1: Repository and Branching Strategy
- **Branching Model:** We use a simplified Trunk-based development.
- **Main Branch:** Production-ready code.
- **Feature Branches:** `feature/name-of-feature` for all development.
- **Deployment Flow:** Code is merged to `main` via Pull Request after passing CI checks.

## Sub-task 2: Containerization
- **Dockerfile:** Multi-stage build for a small footprint.
- **Security:** Running as a non-root user (`appuser`).
- **Base Image:** `python:3.9-slim`.

