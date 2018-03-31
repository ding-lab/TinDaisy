TinDaisy is development directory for CWL-wrapped SomaticWrapper version.  

GitHub: https://github.com/ding-lab/tin-daisy

The name TinDaisy was generated with a [random name generator][1]

[1]: http://www.codenamegenerator.com/

## Goals

* Developing `cwl` branch of somaticwrapper.
* Focus is StrelkaDemo dataset for testing
* Goal is to develop complete workflow of SomaticWrapper and validate StrelkaDemo
    * First locally
    * Next on platform
    * Using Rabix Composer and Executor
* Currently this project has been successfully executed on epazote (Mac OS laptop) and Seven Bridges CGC platform.

## StrelkaDemo details

Data from `/Users/mwyczalk/Data/SomaticWrapper/data/StrelkaDemo`

Tumor: /Users/mwyczalk/Data/SomaticWrapper/import/StrelkaDemoCase.T.bam
Normal: /Users/mwyczalk/Data/SomaticWrapper/import/StrelkaDemoCase.N.bam

# Configuration parameters
Based on /Users/mwyczalk/Data/SomaticWrapper/data/StrelkaDemo/config/StrelkaDemoCase.WXS.config
Modifed so all paths relative to host
Paths to files in image are excluded (they are defaults)

All output will go in ./results

```
reference_dict = $HOME/Data/SomaticWrapper/image/A_Reference/demo20.dict
* use_vep_db = 1
* assembly = GRCh37
* output_vep = 1
pindel_config = somaticwrapper/params/pindel.WES.ini
sw_data = results
varscan_config = somaticwrapper/params/varscan.WES.ini
dbsnp_db = $HOME/Data/SomaticWrapper/image/B_Filter/dbsnp-StrelkaDemo.noCOSMIC.vcf.gz
normal_bam = $HOME/Data/SomaticWrapper/import/StrelkaDemoCase.N.bam
tumor_bam = $HOME/Data/SomaticWrapper/import/StrelkaDemoCase.T.bam
reference_fasta = $HOME/Data/SomaticWrapper/image/A_Reference/demo20.fa
annotate_intermediate = 1
sample_name = StrelkaDemoCase.WXS.CWL
strelka_config = somaticwrapper/params/strelka.WES.ini
```

## CWL-specific modifications

* All steps need to have input data passed as an argument
  * in cases where a tool writes its output to the same directory as input data (`pindel_filter` and `varscan` do this)
    in order to control where output goes, we create a link to the input data in the output directory
* One of the steps in `parse_pindel`, the `grep ChrID` step, was moved to `pindel_run`
* All references of `genomevip_label` were removed, simplifying internal data file structure

### `run_vep`

The script `run_vep` has been replaced by a more CWL-friendly version, `annotate_vep`.  The latter
takes one VCF file as input and writes an annotated VCF (or VEP) file. As such, this "step" may be used
to process any number of files by placing it in their workflow

## Run testing

There are four levels at which the code can be tested:

1. Direct command line invocation of SomaticWrapper
2. Executing SomaticWrapper from within a docker container
3. Executing CWL-wrapped SomaticWrapper tool using Rabix Executor
4. Executing a CWL workflow containing 1 or more SomaticWrapper tools

For development and debugging, make sure all prior steps work.

### Command line invocation

*Not demonstrating it here for now.*  This requires installation of SomaticWrapper cwl branch here with,
```
git clone --branch cwl https://github.com/ding-lab/somaticwrapper
```

Note that code is available here: `../SomaticWrapper.d2/somaticwrapper`

### Docker testing and development

The Docker image `cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl` incorporates the CWL branch
of SomaticWrapper, and is the image used for all work here.

#### Docker useful hints and tips

To start a docker container,
```
docker run -it cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl bash
```
To open another terminal in a running container (with container ID `03e59caeeb98`):
```
docker exec -it 03e59caeeb98 bash
```
Use `docker ps -a` and `docker start` to discover and restart stopped containers

Editing SomaticWrapper within the docker image is very helpful for development and debugging.  It requires at least
one terminal running in the container.  Once edits are made in the container,
```
docker commit 03e59caeeb98 cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl
```
will incorporate them into the image.  Such edits will then be available the next time the image runs.
These can be pushed to cgc-images with,  
```
docker push cgc-images.sbgenomics.com/m_wyczalkowski/somatic-wrapper:cwl
```

A preferred alternative (to maintain reproducibility) is to `git push` to the
repository from within the container, then re-generate the image using
`1_docker_build.sh` and `2_push_docker.sh` in `somaticwrapper/docker`, which 
clones the github repository.


### Rabix invocation

## Documentation

Workflow is visually described here: /Users/mwyczalk/Projects/PipelineVisualization/GermlineWrapper 

## Additional work

TODO: simply this workflow by,
* get rid of `genomevip_label` steps - these are not necessary
* simplify internal names



# Details about centromere BED files distributed in StrelkaDemo.dat

*Create BED files defining centromeres and other featues*

A centromere BED file is used for Pindel to define regions to be excluded
from analysis.  While optional, it is used for performance purposes.

Three such files are distributed:
* pindel-centromere-exclude.bed  -  this file is for GRCh37, and was used for internal development purposes.  It has an unknown provenance.
* ucsc-centromere.GRCh37.bed - Data generated from UCSC Table Browser for GRCh37 assembly as described below
* ucsc-centromere.GRCh38.bed - Data generated from UCSC Table Browser for GRCh38 assembly as described below

There is no reason in most cases to do anything in this directory, but instructions of how to manually obtain UCSC data are below.

## ucsc-centromere.GRCh37.bed

Table is obtained manually from [UCSC Table Browser](http://genome.ucsc.edu/cgi-bin/hgTables)
* *Assembly:* GRCh37
* *Group:* All Tables
* *Table:* Gap
* *Filter:* Type matches "centromere"
* *Output format:* BED
* *Output File:* ucsc-centromere.GRCh37.bed
* Defaults for *Output gap as BED*


## ucsc-centromere.GRCh38.bed

Table is obtained manually from [UCSC Table Browser](http://genome.ucsc.edu/cgi-bin/hgTables).  Note that GRCh38 treats centromeres differently than GRCh37, as described [here](https://groups.google.com/a/soe.ucsc.edu/forum/#!topic/genome/SaR2y4UNrWg).
* *Assembly:* GRCh38
* *Group:* All Tables
* *Table:* Centromeres
* *Output format:* BED
* *Output File:* ucsc-centromere.GRCh38.bed
* Defaults for *Output gap as BED*
