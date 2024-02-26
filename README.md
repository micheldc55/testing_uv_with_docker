# Testing uv dependencies handler with Docker

The purpose of this repository is to test whether the uv library can speed up docker builds by a substantial amount.

## Project Structure:

This is a very simple an straightforward project. I just create a Dockerfile.pip and a Dockerfile.uv and build a small Docker image installing the libraries requested in the requirements.txt file in the main directory. There is also an app folder that contains a placeholder for a Python app that would be executed if the container was deployed. If you are using VS Code, and particularly the Dev Containers extension, there is also a .devcontainers folder which will hanlde the set up needed for you to test building this image directly using the "Reopen In Container" option in VS Code.

.
├── .devcontainer
│   └── devcontainer.json   --> Set up for using Dev Containers
├── Dockerfile.pip          --> Dockerfile using "pip"
├── Dockerfile.uv           --> Dockerfile using "uv"
├── README.md               
├── app                     
│   └── test_app.py         --> Placeholder for Python app
├── requirements.txt        --> Sets up the libraries needed
└── "certificate"           --> This should be provided by you

## Motivation

Docker is a fantastic tool for containarizing applications and it is in my opinion the best tool for development, as it can simulate the application's environment and can allow users to develop from inside the container. This solves two major issues with developing applications:

1) Solving dependencies for reproducibility: Most dependencies are developed in a very tight combination of library versions, which make it a nightmare to share environments. Docker allows environment reproducibility an a lot of different ways, provided that it's uses properly. This allows users to share the environment they are developing in, in a very portable and easy to share way.

2) Easy of deployment: In general, if an application works in a Docker container, it will work when deployed.

One problem I've encountered with Docker is how much it takes for container images to build. For simple applications, most of the building time is spent on the dependencies installation. This is annoying when you are trying to set up a project's dependencies, because you may need to rebuild the image a couple of times, and if you change dependencies you will loose the cache for that line, which means reinstalling again. While this may not sound like a terrible problem, it can slow down development and make you loose focus.

On the 23rd of Ferbruary (2024), I stumbled upon this `uv` library by (astral-sh)[https://astral.sh/] which implements a dependency solver in Rust. I immediately thought of the Docker build times and figured I should test this for myself. The link to the library repo can be found (here)[https://github.com/astral-sh/uv] and it's reported to install dependencies 10-100x faster. Benchmarks for cold and warm installation tests is also provided in their (benchmarks page)[https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md].

## Results


# Docker Build Time Experiment Guide

This guide outlines the steps to test the build times for our Docker images defined in `Dockerfile.pip` and `Dockerfile.uv`. The objective is to provide a robust methodology for measuring and comparing the build times of these Dockerfiles.

## Pre-requisites

- Docker installed on your machine.
- Clone the repository or ensure you have the latest version of the project.

## Experiment Setup

1. **Prepare Your Environment**:
    - Ensure Docker is running on your system.
    - Navigate to the project's root directory in your terminal.

2. **Define Build Commands**:
    - For `Dockerfile.pip`, we will use the tag `projectname-pip`:
        ```
        docker build -f Dockerfile.pip -t projectname-pip .
        ```
    - For `Dockerfile.uv`, we will use the tag `projectname-uv`:
        ```
        docker build -f Dockerfile.uv -t projectname-uv .
        ```

## Conducting the Experiment

1. **Clean Docker Cache (Optional)**:
    To ensure that the build times are not affected by Docker's cache, you can optionally clear the Docker cache before each build. Warning: This will remove all cached layers. Use the following command:
    ```
    docker system prune -a
    ```
    Confirm when prompted.

2. **Measure Build Time**:
    - To measure the build time accurately, prepend the build command with `time`. This works on most Unix-like systems. If you're using a platform where `time` is not available, you might need to use alternative timing methods.
    - For `Dockerfile.pip`:
        ```
        time docker build -f Dockerfile.pip -t projectname-pip .
        ```
    - For `Dockerfile.uv`:
        ```
        time docker build -f Dockerfile.uv -t projectname-uv .
        ```

3. **Record the Results**:
    - After each build, Docker will output the total time taken. Ensure you note this down.
    - For a more detailed time analysis, consider using Docker's `--progress=plain` option to get more granular build timing information.

4. **Repeat the Builds**:
    - To ensure accuracy, repeat the build process for each Dockerfile multiple times. Three to five times is a good range for getting a reliable measure.
    - Record all results and calculate the average build time for each Dockerfile.

## Analyzing the Results

- Compare the average build times of `Dockerfile.pip` and `Dockerfile.uv`.
- Analyze which stages of the build process take the most time and if there are any significant differences between the two Dockerfiles.
- Consider factors like base image size, the efficiency of caching layers, and specific commands used in each Dockerfile that might impact build times.

## Conclusion

- Document your findings and conclusions from the experiment.
- Discuss potential optimizations based on your analysis.

By following this guide, you should be able to perform a detailed and robust comparison of the build times for `Dockerfile.pip` and `Dockerfile.uv`.
