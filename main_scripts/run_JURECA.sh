#!/bin/bash

######################################################################
# run.sh - Script for submitting and executing MPI-based jobs on SLURM.
#
# This script is designed to launch MPI-based programs with specified
# configurations on clusters using the SLURM workload manager. It allows the
# user to specify the number of tasks, executable, MPI geometry, and parameter
# file, and ensures compatibility with the cluster environment by loading
# necessary modules.
#
# Usage: ./run.sh <number_of_tasks> <main_program_executable> <mpi_geometry>
#   <parameters_file>
#
# Positional Arguments: <number_of_tasks>         Number of MPI tasks to launch.
#   <main_program_executable> Path to the executable file of the main program.
#   <mpi_geometry>            MPI geometry (e.g., 4,4,4) defining the process
#   layout. <parameters_file>         Path to the parameter file used by the
#   main program.
#
# Additional Notes:
# - Ensure the required modules are available on the cluster.
# - The script dynamically queries and prints the partition if applicable.
# - Adjust `--map-by` and `--bind-to` settings in the `mpirun` command to fit
#   your specific hardware and performance needs.
######################################################################

# ADDITIONAL SBATCH OPTIONS

#SBATCH --cpus-per-task=16            # CPUs (threads) per MPI task
#SBATCH --account=overlapreloaded
#SBATCH --partition=dc-cpu

# DEPENDENCIES
# Load modules on compute node
module load Stages/2025
module load GCC/13.3.0
module load ParaStationMPI/5.11.0-1-mt
module load sympy/1.13.3
module load GSL/2.8

# POSITIONAL ARGUMENTS PASSED TO SCRIPT

number_of_tasks=$1
main_program_executable=$2
mpi_geometry=$3
parameters_file=$4

# MAIN EXECUTION BLOCK

# Retrieve and display the SLURM partition if applicable
partition=$(
    scontrol show job $SLURM_JOB_ID 2>/dev/null | grep -oP 'Partition=\K\w+')
# Print the partition only if it's non-empty
if [[ -n $partition ]]; then
    echo " Partition: $partition"
fi
echo " Number of nodes: $SLURM_JOB_NUM_NODES"

# Run the MPI-based program with the provided arguments
srun -n ${number_of_tasks} ${main_program_executable} geom=${mpi_geometry} ${parameters_file}
