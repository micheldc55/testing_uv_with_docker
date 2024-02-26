# Testing uv dependencies handler with Docker

The purpose of this repository is to test whether the uv library can speed up docker builds by a substantial amount.

## Project Structure:

This is a very simple an straightforward project. I just create a Dockerfile.pip and a Dockerfile.uv and build a small Docker image installing the libraries requested in the requirements.txt file in the main directory. There is also an app folder that contains a placeholder for a Python app that would be executed if the container was deployed. If you are using VS Code, and particularly the Dev Containers extension, there is also a .devcontainers folder which will hanlde the set up needed for you to test building this image directly using the "Reopen In Container" option in VS Code.

```bash
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
```

## Motivation

Docker is a fantastic tool for containarizing applications and it is in my opinion the best tool for development, as it can simulate the application's environment and can allow users to develop from inside the container. This solves two major issues with developing applications:

1) Solving dependencies for reproducibility: Most dependencies are developed in a very tight combination of library versions, which make it a nightmare to share environments. Docker allows environment reproducibility an a lot of different ways, provided that it's uses properly. This allows users to share the environment they are developing in, in a very portable and easy to share way.

2) Easy of deployment: In general, if an application works in a Docker container, it will work when deployed.

One problem I've encountered with Docker is how much it takes for container images to build. For simple applications, most of the building time is spent on the dependencies installation. This is annoying when you are trying to set up a project's dependencies, because you may need to rebuild the image a couple of times, and if you change dependencies you will loose the cache for that line, which means reinstalling again. While this may not sound like a terrible problem, it can slow down development and make you loose focus.

On the 23rd of Ferbruary (2024), I stumbled upon this `uv` library by (astral-sh)[https://astral.sh/] which implements a dependency solver in Rust. I immediately thought of the Docker build times and figured I should test this for myself. The link to the library repo can be found (here)[https://github.com/astral-sh/uv] and it's reported to install dependencies 10-100x faster. Benchmarks for cold and warm installation tests is also provided in their (benchmarks page)[https://github.com/astral-sh/uv/blob/main/BENCHMARKS.md].


## Docker Build Time Experiment Guide

This guide outlines steps to conduct a quick experiment for measuring the build times of Docker images using Dockerfile.pip and Dockerfile.uv. The experiment is automated using a Bash script, running multiple build iterations for each Dockerfile to gather reliable timing data. You can change the number of experiments to have a more robust estimate of the time.

### Prerequisites
- Docker installed and running on your machine.
- Bash shell (Linux/MacOS) or WSL (Windows).

### Experiment Setup
Prepare Your Environment: Ensure your Docker environment is set up and that you have a Bash shell available for running the script. Next, open a Bash terminal.

Download the Experiment Script: Make the project bash script executable by running:

```bash
chmod +x run_docker_build_experiment.sh
```

Now, we just have to select the right number of experiments and run the tests. From a statistical standpoint, you should at least select 20-30 samples from each (using pip and uv) to make a more robust conclusion. I used 30 and dropped the first one because it seemed to be an outlier (see the files included in the analysis).

You can run the file by simply executing this in your terminal (this will run 30 experiments):

```bash
./run_docker_build_experiment.sh
```

You can alternatively pass the number of experiments you want to run, by substituting the "num_experiments" value for any integer in the following command:

```bash
./run_docker_build_experiment.sh num_experiments
```

If you run "./run_docker_build_experiment.sh 50" you would run 50 experiments. The results will be saved to a file in the main directory of the project.

## Results

The results can be visualized for the 29 examples I sampled for both categories in the analysis/parse_results.html file. This was generated from the parse_results.ipynb notebook located in the same directory.

### Mean build times:

!(mean_build_hist)[/images/docker_build_times_pip_vs_uv.png]