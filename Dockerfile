# syntax=docker/dockerfile:1

FROM ubuntu:22.04

WORKDIR /site

RUN groupadd --system user && useradd --create-home --system -g user user

# Install System Dependencies

RUN <<-EOF
        apt-get update
        apt-get install -y --no-install-recommends \
          ca-certificates \
          wget
        rm -rf /var/lib/apt/lists/*
EOF

# Install Hugo

ARG HUGO_VERSION=0.118.2

RUN <<-EOF
        hugo_base_url="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}"
        hugo_release="hugo_extended_${HUGO_VERSION}_linux-amd64.deb"
        hugo_checksums="hugo_${HUGO_VERSION}_checksums.txt"

        wget "${hugo_base_url}/${hugo_release}"
        wget "${hugo_base_url}/${hugo_checksums}"
        grep " ${hugo_release}\$" ${hugo_checksums} | sha256sum -c --strict -
        dpkg --install "${hugo_release}"
        rm -rf "${hugo_release}" "${hugo_checksums}"
        hugo version
EOF

# Install Quarto

ARG QUARTO_VERSION=1.3.450

RUN <<-EOF
        quarto_base_url="https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}"
        quarto_release="quarto-${QUARTO_VERSION}-linux-amd64.deb"
        quarto_checksums="quarto-${QUARTO_VERSION}-checksums.txt"

        wget "${quarto_base_url}/${quarto_release}"
        wget "${quarto_base_url}/${quarto_checksums}"
        grep " ${quarto_release}\$" ${quarto_checksums} | sha256sum -c --strict -
        dpkg --install "${quarto_release}"
        rm -rf "${quarto_release}" "${quarto_checksums}"
        quarto --version
EOF

USER user
