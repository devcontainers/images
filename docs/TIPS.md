### Why do Dockerfiles in this repository use RUN statements with commands separated by &&?

Each `RUN` statement creates a Docker image "layer". If one `RUN` statement adds in temporary contents, these contents remain in this layer in the image even if they are deleted in a subsequent `RUN`. This means the image takes more storage locally and results in slower image download times if you publish the image to a registry.

So, in short, you want to clean up after you install or configure anything in the same `RUN` statement. To do this, you can either:

1. Use a string of commands that cleans up at the end. e.g.: 

    ```Dockerfile
    RUN apt-get update && apt-get -y install --no-install-recommends git && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
    ```

    ... or across multiple lines (note the `\` at the end escaping the newline):

    ```Dockerfile
    RUN apt-get update \
        && apt-get -y install git \
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*
    ```

2. Put the commands in a script, temporarily copy it into the container, then remove it. e.g.:

    ```Dockerfile
    COPY ./my-script.sh /tmp/my-script.sh
    RUN bash /tmp/my-script.sh \
        && rm -f /tmp/my-script.sh
    ```

Some other tips:

1. You'd be surprised [how big package lists](https://askubuntu.com/questions/179955/var-lib-apt-lists-is-huge) can get, so be sure to clean these up too. Most Docker images that use Debian / Ubuntu use the following command to clean these up:

    ```
    rm -rf /var/lib/apt/lists/*
    ```

    The only downside of doing this is that `apt-get update` has to be executed before you install a package. However, in most cases adding this package to a Dockerfile is a better choice anyway since this will survive a "rebuild" of the image and the creation of an updated container. 

2. In all cases, you'll want to pay attention to package caching since this can also take up image space. Typically there is an option for a package manager to not cache when installing that you can use to minimize the size of the image. For example, for Alpine Linux, there's `apk --no-cache`

3. Watch out for the installation of "recommended" packages you don't need. By default, Debian / Ubuntu's `apt-get` installs packages that are commonly used with the one you specified - which in many cases isn't required. You can use `apt-get -y install --no-install-recommends` to avoid this problem.
