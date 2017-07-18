#!/usr/bin/env bash

phpVersion=${1:-"71"}
project=${2:-"symfony"}

declare skeletonPath="php-docker-skeleton"

function fetchSkeleton() {
    rm -rf "${skeletonPath}" || true
    git clone --depth 1 https://github.com/PGSSoft/php-docker-skeleton "${skeletonPath}"
}

function prepareProject()
{
    repoUrl=$1
    projectName=$2
    rm -rf "${projectName}" || true
    git clone --depth 1 "${repoUrl}" "${projectName}"

    filesToCopy=(docker docker.sh docker-compose.local.yml docker-compose.yml)

    for file in "${filesToCopy[@]}"; do
        cp -r "${skeletonPath}/${file}" "${projectName}"
    done

    cp "${projectName}.build.xml" "${projectName}/build.xml"
}

function build() {
    projectName=$1
    cd "$projectName"
    ./docker.sh build "${phpVersion}" false
}

function symfony() {
    prepareProject "https://github.com/symfony/symfony-demo.git" "symfony-demo"
    build "symfony-demo"
}

fetchSkeleton
eval "${project}"
