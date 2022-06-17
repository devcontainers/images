# Development Containers

A **development container** is a running [Docker](https://www.docker.com) container with a well-defined tool/runtime stack and its prerequisites. It allows you to use a container as a full-featured development environment which can be used to run an application, to separate tools, libraries, or runtimes needed for working with a codebase, and to aid in continuous integration and testing.

This repository contains a set of **dev container definitions** to help get you up and running with a containerized environment. The definitions describe the appropriate container image, and runtime arguments for starting the container which are built with [dev container features](https://github.com/devcontainers/features). Each provides a container configuration file (`.devcontainer.json`) and other needed files that you can drop into any existing folder as a starting point for containerizing your project.

## Contents
 
- [`src`](src) - Contains reusable dev container definitions.

## Common Questions

### What is the goal of `.devcontainer.json`?

A `.devcontainer.json` file is similar to `launch.json` for debugging, but designed to launch (or attach to) a development container instead. At its simplest, all you need is a `.devcontainer.json` file in your project that references an image, `Dockerfile`, or `docker-compose.yml`, and a few properties.

### Why do Dockerfiles in this repo use `RUN` statements with commands separated by `&&`?

Each `RUN` statement creates a Docker image "layer". If one `RUN` statement adds temporary contents, these contents remain in this layer in the image even if they are deleted in a subsequent `RUN`. This means the image takes more storage locally and results in slower image download times if you publish the image to a registry. You can resolve this problem by using a `RUN` statement that includes any clean up steps (separated by `&&`) after a given operation. See [CONTRIBUTING.md](./CONTRIBUTING.md#why-do-dockerfiles-in-this-repository-use-run-statements-with-commands-separated-by-) for more tips.

### How can I contribute?

If you want to create your own image or add functionality on top of the image definitions available in this repository, then see [How to write Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) and [How to use dev container features](https://github.com/devcontainers/features). However, we won't add them to an offical repository as this repository is a limited set of selected images. Check out the [templates](https://github.com/devcontainers/templates) and [features](https://github.com/devcontainers/features) repos for more customizations and information on contributions.

## Feedback

Issues related to dev container definitions can be reported in the [devcontainers/images](https://github.com/devcontainers/images) repository.

# License

License for this repository:

Copyright © Microsoft Corporation All rights reserved.<br />
Creative Commons Attribution 4.0 License (International): https://creativecommons.org/licenses/by/4.0/legalcode
