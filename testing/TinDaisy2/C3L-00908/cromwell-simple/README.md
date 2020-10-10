# Run 1

Failed with error in
/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2.cwl/975a4e56-8a1b-4c43-a306-3f0831760a14/call-somatic_vaf_filter_strelka_indel/execution/stderr

```
[ Wed Oct 7 21:32:16 UTC 2020 ] Running: cat /cromwell-executions/tindaisy2.cwl/975a4e56-8a1b-4c43-a306-3f0831760a14/call-somatic_vaf_filter_strelka_indel/inputs/-525167129/somatic.indels.vcf.gz | /usr/local/bin/vcf_filter.py --local-script somatic_vaf_filter.py - somatic_vaf --tumor_name TUMOR --normal_name NORMAL --caller strelka --max_vaf_normal 0.02 --min_vaf_tumor 0.05 > somatic_vaf_filter.output.vcf
Traceback (most recent call last):
  File "/usr/local/bin/vcf_filter.py", line 168, in <module>
    if __name__ == '__main__': main()
  File "/usr/local/bin/vcf_filter.py", line 148, in main
    for record in inp:
  File "/usr/local/lib/python3.8/site-packages/vcf/parser.py", line 547, in __next__
    pos = int(row[1])
IndexError: list index out of range
[ Wed Oct 7 21:32:16 UTC 2020 ] run_somatic_vaf_filter.sh Fatal ERROR. Exiting.
```

Looking at /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2.cwl/975a4e56-8a1b-4c43-a306-3f0831760a14/call-somatic_vaf_filter_strelka_indel/inputs/-525167129/somatic.indels.vcf.gz

-> seems to be OK, not empty
-> doing zcat on a gz file fixes the run, so need to add gz file auto-detection

-> VLD_FilterVCF updated all filter scripts to detect and `zcat` compressed files.
    -> mwyczalkowski/vld_filter_vcf:20201009

# Run 2

Started 10/9/20
    /gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2.cwl/c8a7300c-082c-4e12-b746-a3253cc19973
{
  "outputs": {
    "tindaisy2.cwl.output_vcf": {
      "format": null,
      "location": "/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2.cwl/c8a7300c-082c-4e12-b746-a3253cc19973/call-canonical_filter/execution/output/H
otspotFiltered.vcf",
      "size": 360435,
      "secondaryFiles": [],
      "contents": null,
      "checksum": null,
      "class": "File"
    },
    "tindaisy2.cwl.output_maf": {
      "format": null,
      "location": "/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2.cwl/c8a7300c-082c-4e12-b746-a3253cc19973/call-vcf2maf/execution/result.maf",
      "size": 70177,
      "secondaryFiles": [],
      "contents": null,
      "checksum": null,
      "class": "File"
    }
  },
  "id": "c8a7300c-082c-4e12-b746-a3253cc19973"
} 

# Run 3

Run 3 is a restart of run 1, designed to more quickly run the entire workflow once initial calls are made.
-> developed new CWL file, tindaisy2-restart_postcall.cwl
   This is called by `2_run_C3L-00908.restart.sh`

```
BASE="/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2.cwl/975a4e56-8a1b-4c43-a306-3f0831760a14"

VARSCAN_INDEL=$BASE/call-run_varscan/execution/results/varscan/varscan_out/varscan.out.som_indel.vcf
VARSCAN_SNV=$BASE/call-run_varscan/execution/results/varscan/varscan_out/varscan.out.som_snv.vcf
STRELKA_INDEL=$BASE/call-run_strelka2/execution/results/strelka2/strelka_out/results/variants/somatic.indels.vcf.gz
STRELKA_SNV=$BASE/call-run_strelka2/execution/results/strelka2/strelka_out/results/variants/somatic.snvs.vcf.gz
PINDEL_RAW=$BASE/call-run_pindel/execution/results/pindel/pindel_out/pindel-raw.dat
MUTECT=$BASE/call-mutect/execution/mutect.vcf
```

{
  "outputs": {
    "tindaisy2-restart_postcall.cwl.output_maf": {
      "format": null,
      "location": "/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2-restart_postcall.cwl/eb17b2bb-206c-409b-8660-3b0c8cae1160/call-vcf2maf/execution/
result.maf",
      "size": 70177,
      "secondaryFiles": [],
      "contents": null,
      "checksum": null,
      "class": "File"
    },
    "tindaisy2-restart_postcall.cwl.output_vcf": {
      "format": null,
      "location": "/gscmnt/gc2541/cptac3_analysis/cromwell-workdir/cromwell-executions/tindaisy2-restart_postcall.cwl/eb17b2bb-206c-409b-8660-3b0c8cae1160/call-canonical_filter/e
xecution/output/HotspotFiltered.vcf",
      "size": 361009,
      "secondaryFiles": [],
      "contents": null,
      "checksum": null,
      "class": "File"
    }
  },
  "id": "eb17b2bb-206c-409b-8660-3b0c8cae1160"
}
