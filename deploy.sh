#!/bin/bash
set -e

service_name=backend   

deploy() {
  if [ -z "$1" ]; then
    read -r -p "Enter version you want to deploy: " version
  else
    version=$1
  fi

  if [ -z "$version" ]; then
    echo "You did not enter a version."
    exit 1
  fi

  export VERSION=$version

  echo "Start deploying backend...."
  old_container_id=$(docker ps -f name=$service_name -q | tail -n1)

  echo "Creating new container..."
  docker compose up -d --no-deps $service_name

  echo "Waiting for new container to be ready..."
  sleep 10 

  if [ ! -z "$old_container_id" ]; then
    echo "Stopping and removing old container..."
    docker stop $old_container_id
    docker rm $old_container_id
    echo "Old container removed"
  else
    echo "No old container found"
  fi

  echo "Backend deployed successfully!!!"

  echo "Cleaning up unused images..."
  docker image prune -a -f
}

deploy $1
