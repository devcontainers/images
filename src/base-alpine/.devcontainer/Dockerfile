# [Choice] Alpine version: 3.18, 3.17, 3.16, 3.15
ARG VARIANT=3.18
FROM alpine:${VARIANT}

ARG VARIANT

# Temporary: Upgrade packages due to mentioned CVEs
RUN if [[ "$VARIANT" == "3.15" ]]; then \
        apk update \
        # https://security.alpinelinux.org/vuln/CVE-2023-27320
        && apk add sudo>=1.9.12-r1 --repository https://dl-cdn.alpinelinux.org/alpine/latest-stable/community ; \
    fi
