Configuration steps

See directions in README.md in base directory.

# Detailed notes

TinDaisy-template.yaml must be should be evaluated for new projects. The following parameters
are replaced when the template is parsed:
    * NORMAL_BAM
    * TUMOR_BAM
    * REF
    * TD_ROOT
    * DBSNP_DB
    * VEP_CACHE_GZ

The values of these specitric parameters are obtained from `project_config.sh`

Step 1 will write one YAML file per case to ./yaml directory.  It will also generate
a pre-summary file which lists inputs for each step

Run: bash 2_run_tasks.sh -J4

Might add -e flag to watch on stderr what is happening
