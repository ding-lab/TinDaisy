# launch a simple docker environment.  Used for quickly starting full shell when logged into ssh-jump
 
# This is a good general-purpose image built for MGI
# see e.g., /Users/mwyczalk/Projects/CPTAC3/importGDC.CPTAC3.b1/importGDC/docker

# setting this as false will remove /gsc/bin/bash problems

#export LSF_DOCKER_PRESERVE_ENVIRONMENT="false"  

#IMAGE="mwyczalkowski/importgdc:latest"
#IMAGE="lbwang/dailybox"
IMAGE="mgibio/cle"
#IMAGE="cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl"
#IMAGE="registry.gsc.wustl.edu/genome/genome_perl_environment:latest"
bsub -Is -q research-hpc -a "docker($IMAGE)" /bin/bash

#bsub -Is -q research-hpc -a "docker(registry.gsc.wustl.edu/genome/genome_perl_environment)" /bin/bash

# This one has a newer version of git
#bsub -Is -q research-hpc -a "docker(lbwang/dailybox)" /bin/bash
