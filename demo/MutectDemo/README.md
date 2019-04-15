Running MutectDemo in both Rabix and Cromwell execution engines

MutectDemo is a test dataset which exercises all parts of workflow, but yields empty results
It is designed to quickly test for failure of downstream steps

Before running, be sure to uncompress reference in `../demo_data/MutectDemo-data` with
    tar -xvjf Homo_sapiens_assembly19.COST16011_region.fa.tar.bz2

Note that this dies on Cromwell with a python library not found error at conclusion of mutect run.
  This occurs only for MutectDemo, so may have something to do with running test data on MGI
