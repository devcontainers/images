# Development Containers Images

<table style="width: 100%; border-style: none;"><tr>
<td style="width: 140px; text-align: center;"><a href="https://github.com/devcontainers"><img width="128px" src="https://raw.githubusercontent.com/microsoft/fluentui-system-icons/78c9587b995299d5bfc007a0077773556ecb0994/assets/Cube/SVG/ic_fluent_cube_32_filled.svg" alt="devcontainers organization logo"/></a></td>
<td>
<strong>Development Container Images</strong><br />
Published docker images for use as development containers
</td>
</tr></table>


A **development container** is a running [Docker](https://www.docker.com) container with a well-defined tool/runtime stack and its prerequisites. It allows you to use a container as a full-featured development environment which can be used to run an application, to separate tools, libraries, or runtimes needed for working with a codebase, and to aid in continuous integration and testing.

This repository contains a set of **dev container images** which are Docker images built with [dev container features](https://github.com/devcontainers/features).

## Contents
 
- [`src`](src) - Contains reusable dev container images.

## Common Questions
### How does this repo relate to the dev container spec? What is the dev container specification?

The Development Containers Specification seeks to find ways to enrich existing formats with common development specific settings, tools, and configuration while still providing a simplified, un-orchestrated single container option – so that they can be used as coding environments or for continuous integration and testing. You may review the spec and learn more about it in the [devcontainers/spec](https://github.com/devcontainers/spec) repo and [containers.dev](https://containers.dev/).

This repository supplies images that may be used in dev container configurations that follow the spec.
### What is the goal of `devcontainer.json`?

A `devcontainer.json` file is similar to `launch.json` for debugging, but designed to launch (or attach to) a development container instead. At its simplest, all you need is a `.devcontainer/devcontainer.json` file in your project that references an image, `Dockerfile`, or `docker-compose.yml`, and a few properties.

### Why do Dockerfiles in this repo use `RUN` statements with commands separated by `&&`?

Each `RUN` statement creates a Docker image "layer". If one `RUN` statement adds temporary contents, these contents remain in this layer in the image even if they are deleted in a subsequent `RUN`. This means the image takes more storage locally and results in slower image download times if you publish the image to a registry. You can resolve this problem by using a `RUN` statement that includes any clean up steps (separated by `&&`) after a given operation. You can find more tips [here](./docs/TIPS.md/#why-do-dockerfiles-in-this-repository-use-run-statements-with-commands-separated-by).

### How can I contribute?

If you want to create your own image or add functionality on top of the images available in this repository, then see [How to write Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) and the [dev container features reference](https://containers.dev/implementors/features/). 

This repository contains a select set of images, and we encourage the community to host and share additional images, and features rather than adding them here. You may learn more about this process in [the guidance](https://containers.dev/implementors/features-distribution/) in our spec repo. You may also check out the [features](https://github.com/devcontainers/features) repo for additional customizations you may adopt or modify for your dev containers.

## Feedback

Issues related to these images can be reported in [an issue](https://github.com/devcontainers/images/issues) in this repository.

# License
Copyright (c) Microsoft Corporation. All rights reserved. <br />
Licensed under the MIT License. See [LICENSE](LICENSE).

For images generated from this repository, see [LICENSE](https://github.com/microsoft/containerregistry/blob/main/legal/Container-Images-Legal-Notice.md) and [NOTICE.txt](NOTICE.txt).
