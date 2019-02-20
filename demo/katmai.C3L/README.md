Isolating katmai-specific development

All configuration is via YAML

By order of development

* C3L-01032
  * Demonstration of hg19 YAML run on katmai
  * Test dataset is C3L-01032 bulk tumor vs. blood normal, which is part of CPTAC3 PDA8 core / bulk test.
* C3L-01032/restart
  * This is extension of previous run, which died early because of misconfiguration
  * Developing / debugging here
* C3N-00560 
  * Test dataset is WXS hg38 LUAD C3L-00560
  * Goal is to evaluate against SomaticWrapper v1.3.  
* C3N-00560/restart
  * restarting above after dbsnp_filter step
