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
