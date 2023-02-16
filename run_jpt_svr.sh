##############################
 # @author [Wankun Deng]
 # @email [dengwankun@hotmail.com]
 # @create date 2023-02-15 18:35:40
 # @modify date 2023-02-15 18:35:40
 # @desc [description]
#############################
cd /home/dengw1/scr/software/docker_img
rm bioinfo_env_jpt_svr.sif.bak
mv bioinfo_env_jpt_svr.sif bioinfo_env_jpt_svr.sif.bak
singularity pull --docker-login docker://dengwankun/bioinfo_env:jpt_svr
cd /home/dengw1/scr/docker_prj/rpy2-jupyter
id=`sbatch sbatch.jpt.sh | awk '{print $4}'`
sleep 10
cat ../../tmp/errout/jpt.job.$id