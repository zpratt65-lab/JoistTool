**Overview**
- **Project:** JoistAPI — a small API built for interview preparation.
- **Goal:** Mock parts of NewMill's Standard Joist Tools to demonstrate backend skills, packaging, and deployment.

**Purpose**
- This repository is being prepared for an interview for the Software Engineer role at New Millennium. The implementation focuses on providing a runnable API and a reproducible build using Docker.

**Job / Reference Links**
- Job posting: https://careers-newmillennium.icims.com/jobs/6725/software-engineer/job
- Tool being mocked: https://www.newmill.com/design-tools/tools/standard-joist-tools.html

**Quickstart (Windows)**
Prerequisites: Docker Desktop (running), Git installed, and PowerShell.

Build the Docker image (from `JoistAPI` folder):
```powershell
docker build -t joist-api .
```
Run the container (maps port 9000):
```powershell
docker run --rm -p 9000:9000 joist-api
```

If Docker cannot connect on Windows, ensure Docker Desktop is running and the daemon is available (WSL2 backend or Hyper-V). Use `docker info` to verify.

**Git / Local setup**
- If Git is not installed, install from https://git-scm.com/download/win or via `winget install --id Git.Git -e --source winget`.
- Set your identity before committing:
```powershell
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```
- If `git` is not on your PATH, add the Git folders to your user PATH (example): `C:\Program Files\Git\cmd` and `C:\Program Files\Git\mingw64\bin`.

**Notes about Dockerfile**
- The builder stage uses a Debian image and installs `fpc` and `boss` to compile the Pascal project (see [JoistAPI/Dockerfile](JoistAPI/Dockerfile)).
- The runtime is a slim Debian image with necessary runtime libraries.

**Next steps**
- Verify Docker builds locally: `docker build -t joist-api .`.
- If you want, I can add a small health-check endpoint and a minimal test harness.

