# <img src="docs/TinDaisy.v1.2.png" width="64"/> TinDaisy

[TinDaisy](https://github.com/ding-lab/tin-daisy) is a CWL pipeline for calling
somatic variants fronm tumor and normal exome data.  TinDaisy implements
functionality from [TinDaisy-Core](https://github.com/ding-lab/TinDaisy-Core)
to obtain variant calls, merge and filter them; other CWL tools outside of
TinDaisy-Core are also integrated into the TinDaisy pipeline.  

See [CromwellRunner](https://github.com/ding-lab/CromwellRunner.git) for a simple workflow manager to allow for command-line driven management
of jobs in a Cromwell workflow engine environment.

# Overview

Callers used:

* [Strelka2](https://github.com/Illumina/strelka.git)
* [VarScan.v2.3.8](http://varscan.sourceforge.net/)
* [Pindel](https://github.com/ding-lab/pindel.git)
* [mutect-1.1.7](https://github.com/broadinstitute/mutect)

SNV calls from Strelka2, Varscan, Mutect. Indel calls from Stralka2, Varscan, and Pindel.
[CWL Mutect Tool](https://github.com/mwyczalkowski/mutect-tool) is used for CWL Mutect calls

Filters applied (details in VCF output)
* For indels, require length < 100
* Require normal VAF <= 0.020000, tumor VAF >= 0.050000 for all variants
* Require read depth in tumor > 14 and normal > 8 for all variants 
* All variants must be called by 2 or more callers
* Require Allele Frequency < 0.005000 (as determined by vep)
* Retain exonic calls
* Exclude calls which are in dbSnP but not in COSMIC
* Two or more sequential SNPs on same haplotype merged into MNPs using [DNP_Filter](https://github.com/ding-lab/dnp_filter)

Majority of above processing is implemented in
[TinDaisy-Core](https://github.com/ding-lab/TinDaisy-Core), which was developed
from [SomaticWrapper](https://github.com/ding-lab/somaticwrapper) and
[GenomeVIP](https://genomevip.readthedocs.io/) projects.  [DNP_Filter](https://github.com/ding-lab/dnp_filter) is
implemented as a separate project and CWL tool.

![TinDaisy CWL implementation](docs/tindaisy.cwl.20191116.png)

overview of TinDaisy CWL as visualized with [Rabix Composer](http://docs.rabix.io/rabix-composer-home)

# TODO

* Separate out CromwellRunner discussion below to CromwellRunner
* Describe Demo direcotry structure and use


## Changelog

*TODO* complete this

Note there are two readers of Changelog: users and scientists.  For the latter be clear about
algorithms used and any changes to data formats or results.  Former will be interested
in workflow management

* List TinDaisy commits or tags which are associated with a data release
    *  Indicate any differences which may result in changes to processed data

* 


# Getting Started

## Simple example

TODO: show example of running cromwell directly


# Installation
TinDaisy can be obtained from GitHub with,
```
git clone https://github.com/ding-lab/tin-daisy
```

## Unnecessary
[TinDaisy-Core](https://github.com/ding-lab/TinDaisy-Core) code, which performs
the bulk of processing, can be obtained for inspection with,
``` 
git clone https://github.com/ding-lab/TinDaisy-Core
```
and (DNP_Filter)[https://github.com/ding-lab/dnp_filter] can be obtained similarly.  Note that for CWL runs the
TinDaisy-Core code is distributed in a docker image such as `mwyczalkowski/tindaisy-core:20191108`.
See development notes below for details about modifying such code.

[Cromwell]() server needs to be available.  Currently, this has been developed exclusively on MGI
Cromwell implementation.



# Data prep

## Index BAMs
BAM files and reference need to be indexed.  This is frequently done prior to analysis
```
samtools index BAM
java -jar picard.jar CreateSequenceDictionary R=REF.fa O=REF.dict
```
where for instance `REF="all_sequences"`

## dbSnP-COSMIC
TODO: describe this in more detail.

dbSnP-COSMIC VCF needs to have chromosome names which match the reference, otherwise it will
silently not match anything.  Note that dbSnP-COSMIC.GRCh38.d1.vd1.20190416.vcf.gz has chrom names like `chr1`

## chrlist

This is a list of all chromosomes of interest, used for pindel.  Can be created from the reference's .fai file, retaining
only the names of the chromosomes of interest (typically 1-Y)

## Confirm YAML file

It might be good to quickly check the existence of all files in YAML file with the following,
```
grep path $YAML | cut -f 2 -d : | xargs ls -l
```


# Development notes

This needs to be updated.  Demo directory layout and logic are based on [SomaticSV](https://github.com/mwyczalkowski/somatic_sv_workflow)
and [BICSEQ2](https://github.com/mwyczalkowski/BICSEQ2)

TinDaisy has been tested with `cwltool`, `rabix composer`, and `cromwell` CWL engines.

Explain how to incorporate code into TinDaisy-Core, as well as TinDaisy

# Development details

## Configuration files

YAML files supercede `project_config.sh` files to define variables for runs, since YAML can be used for both
Cromwell and Rabix executions.

Currently, `--vep_cache_dir` is not supported as a way to share VEP cache with `vep_annotation` and `vcf_2_maf` steps
because Rabix does not stage directories.  VEP cache must be passed as a `.tar.gz` file and defined with `vep_cache_gz`


## StrelkaDemo details

`StrelkaDemo` data consists of two small (50Kb) tumor and normal BAM files.  These are [distributed with
Strelka](https://github.com/Illumina/strelka/tree/master/src/demo/data) (hence the name), as well as
in the `./StrelkaDemo.dat` directory.  These are used for quickly testing workflow steps, and are described
in more detail in [docs/README.strelka_demo.md](docs/README.strelka_demo.md)

