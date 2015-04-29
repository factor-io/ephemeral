[![Code Climate](https://codeclimate.com/github/factor-io/ephemeral.png)](https://codeclimate.com/github/factor-io/ephemeral)
[![Coverage Status](https://coveralls.io/repos/factor-io/ephemeral/badge.svg)](https://coveralls.io/r/factor-io/ephemeral)
[![Dependency Status](https://gemnasium.com/factor-io/ephemeral.svg)](https://gemnasium.com/factor-io/ephemeral)
[![Build Status](https://travis-ci.org/factor-io/ephemeral.svg)](https://travis-ci.org/factor-io/ephemeral)

Ephemeral.io
=========

Ephemeral.io is a Docker-based micro-PaaS for short-lived work.

## Why?
At [Factor.io](https://factor.io) sometimes we need to run builds, tests, and scripts on behalf of our customers in our hosted environment. In such a case we need to spin-up a Docker instance with an isolated environment with the necessary environment to run the operations. For example, running an Ansible script, building an app, running a Jekyll build, etc.

## How does it work?
There are three core components: CLI-tool, API Service, and Worker. To perform work you use the CLI tool (`eph run`), which POSTs the files and commands to the API Service. The API Service puts the request in a queue. The worker pulls the requests, spins up a new Docker image and container, performs the work, and pushes live logs to the API. The status is available via the API. When the work is performed you can pull out generated files.
