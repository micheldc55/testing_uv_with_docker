#!/bin/bash

# you can change the number ofd experiments here:
num_experiments={1:-30}

dockerfile_pip="Dockerfile.pip"
dockerfile_uv="Dockerfile.uv"

image_name_pip="experiment_pip"
image_name_uv="experiment_uv"

# create a function to build a Docker image and record build time
build_image() {
    dockerfile=$1
    image_name=$2
    build_time_file=$3

    start_time=$(date +%s)
    docker build -f $dockerfile -t $image_name .
    end_time=$(date +%s)
    
    echo "Build time for $dockerfile: $((end_time - start_time)) seconds" | tee -a $build_time_file
    
    # remove image
    docker rmi $image_name
}

# experiment runs here
for i in $(seq 1 $num_experiments); do
    echo "Experiment $i for $dockerfile_pip"
    build_image $dockerfile_pip $image_name_pip "docker_build_times_pip.txt"
    
    echo "Experiment $i for $dockerfile_uv"
    build_image $dockerfile_uv $image_name_uv "docker_build_times_uv.txt"
done

echo "Experiment completed."
