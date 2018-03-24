
# Remember, need to login first.  Read the README, 
# Be sure docker is running
# docker login cgc-images.sbgenomics.com
# Username: m_wyczalkowski
# Password: this is a token obtained from https://cgc.sbgenomics.com/developer#token, which requies login via ERA Commons

RABIX="/Users/mwyczalk/src/rabix-cli-1.0.4/rabix"
CWL="s2_run_varscan.cwl"

# try to have all output go to output_dir
OUTD="results"
mkdir -p $OUTD
RABIX_ARGS="--basedir $OUTD"

$RABIX $RABIX_ARGS $CWL -- " \
--tumor_bam /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/StrelkaDemoCase.T.bam \
--normal_bam /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/StrelkaDemoCase.N.bam \
--reference_fasta /Users/mwyczalk/Projects/SomaticWrapper.StrelkaDemo/StrelkaDemo.dat/demo20.fa \
--varscan_config /Users/mwyczalk/Projects/Rabix/SomaticWrapper.d2/somaticwrapper/params/varscan.WES.ini"
