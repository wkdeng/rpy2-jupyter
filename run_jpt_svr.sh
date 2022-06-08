cd /home/dengw1/scr/software/docker_img
rm bioinfo_env_jpt_svr.sif
singularity pull --docker-login docker://dengwankun/bioinfo_env:jpt_svr
cd /home/dengw1/scr/docker_prj/rpy2-jupyter
id=`sbatch sbatch.jpt.sh | awk '{print $4}'`
cat ../../tmp/errout/jpt.job.$id