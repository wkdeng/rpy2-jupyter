#!/bin/sh
#SBATCH --signal=USR2
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=300G
#SBATCH --time=720:00:00
#SBATCH --output=/home/%u/scr/tmp/errout/jpt.job.%j
#SBATCH --job-name=jpt_svr
# customize --output path as appropriate (to a directory readable only by the user!)

# Create temporary directory to be populated with directories to bind-mount in the container
# where writable file systems are necessary. Adjust path as appropriate for your computing environment.
export SINGULARITY_BIND="/scr1/users/dengw1/notebooks:/scr1/users/dengw1/notebooks,\
/mnt/isilon/xing_lab/dengw1/mouse_lowinput:/mnt/isilon/xing_lab/dengw1/mouse_lowinput,\
/mnt/isilon/xing_lab/dengw1/snakerun:/mnt/isilon/xing_lab/dengw1/snakerun,/cm/shared/apps_chop"

export SINGULARITYENV_USER=$(id -un)
export SINGULARITYENV_PASSWORD="sirius123"
export SINGULARITY_TMPDIR=/scr1/users/dengw1/software/.singularity/tmp
export SINGULARITY_CACHEDIR=/scr1/users/dengw1/software/.singularity/cache
# get unused socket per https://unix.stackexchange.com/a/132524
# tiny race condition between the python & singularity commands
readonly PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()')
cat 1>&2 <<END
1. SSH tunnel from your workstation using the following command:

   For connection from vscode-remote to jupyter notebook on login node, use http://${HOSTNAME}:${PORT} as jupyter server in vscode
   For connection from local browser:
      ssh -N -L ${PORT}:${HOSTNAME}:${PORT} ${SINGULARITYENV_USER}@dengw1-hpc.research.chop.edu
      and point your web browser to http://localhost:${PORT}

2. log in to jupyter server using the following credentials:

   user: ${SINGULARITYENV_USER}
   password: ${SINGULARITYENV_PASSWORD}

When done using Server, terminate the job by:

1. Exit the jupyter Session ("power" button in the top right corner of the window)
2. Issue the following command on the login node:

      scancel -f ${SLURM_JOB_ID}
END

singularity exec --cleanenv ${HOME}/scr/software/docker_img/bioinfo_env_jpt_svr.sif \
   jupyter notebook --ip=0.0.0.0 --no-browser --port=${PORT} --notebook-dir=/home/dengw1/scr/notebooks

printf 'jupyter notebook exited' 1>&2