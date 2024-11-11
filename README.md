# Binwalk Docker

[![Published](https://github.com/kapdap/docker-binwalk/actions/workflows/publish.yaml/badge.svg)](https://github.com/kapdap/docker-binwalk/actions/workflows/publish.yaml)
[![GitHub](https://img.shields.io/badge/GitHub-grey)](https://github.com/kapdap/docker-binwalk)
[![GitHub](https://img.shields.io/badge/Docker_Hub-blue)](https://hub.docker.com/r/kapdap/binwalk)

This repository contains a Docker image for [Binwalk (v2)](https://github.com/ReFirmLabs/binwalk) based on the [OSPG fork](https://github.com/OSPG/binwalk).

## Quickstart

```sh
echo 'docker run --rm -v "$(pwd):/app" -e U_ID=$(id -u) -e G_ID=$(id -g) -it kapdap/binwalk:latest "$@"' > binwalk
chmod +x ./binwalk
./binwalk -e firmware.bin
```