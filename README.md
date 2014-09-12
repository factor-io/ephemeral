Ephemeral.io
=========

Ephemeral.io is a Docker-based micro-PaaS

Ephermal is a PaaS for short-lived execution, ideal for running builds, tests and scripts.

## Why?
At [Factor.io](https://factor.io) sometimes we need to run builds, tests, and scripts on behalf of our customers in our hosted environment. For example, a customer may create a workflow which listens for merged pull requests in Github, then automatically run Ansible. This means we need to stand up an isolated docker instance where their Ansible resources are placed along with SSH keys. When Ansible is done, we want to annihilate everything. Each of these builds usualy takes no longer than 10 minutes.

## How does it work?
There are three core components: CLI-tool, API Service, and Worker. To perform work you use the CLI tool (`eph run`), which POSTs the files and commands to the API Service. The API Service puts the request in a queue. The worker pulls the requests, spins up a new Docker image and container, performs the work, and pushes live logs to the API. The status is available via the API. When the work is performed you can pull out generated files.
