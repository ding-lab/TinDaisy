Demonstration of hg19 YAML run on katmai

Test dataset is C3L-01032, which is part of CPTAC3 PDA8 core / bulk test.
Will analyze for now bulk tumor vs. blood normal.
Goal is to do a preliminary run of mutect branch on real dataset

From /home/mwyczalk_test/Projects/CPTAC3/CPTAC3.catalog/katmai.BamMap.dat,

C3L-01032.WXS.N C3L-01032   C3L-01032   WXS blood_normal    /diskmnt/Projects/cptac_downloads_6/GDC_import/data/6f5110f3-ee1b-4870-846a-e4a07daaf8c7/CPT0167270002.WholeExome.RP-1303.bam   29254406550 BAM hg19    6f5110f3-ee1b-4870-846a-e4a07daaf8c7    katmai
C3L-01032.WXS.T-bulk    C3L-01032   C3L-01032   WXS tumor   /diskmnt/Projects/cptac_downloads_6/GDC_import/data/b37b103a-d2b2-45a4-86f2-b26464796cfb/CPT0170510026.WholeExome.RP-1303.bam   45869354525 BAM hg19    b37b103a-d2b2-45a4-86f2-b26464796cfb    katmai

This stops, and is restarted in the ./restart directory
