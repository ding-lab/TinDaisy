# Launch docker environment at MGI before running cromwell.

# May want to modify .bashrc and .profile as described in "How to get a clean and modern bash environment without any MGI flavor?" section here:
# https://confluence.ris.wustl.edu/pages/viewpage.action?spaceKey=DL&title=How+to+run+Docker+on+MGI

# currently, using gsub, which tends to point to recent cromwell versions
/gscmnt/gc2560/core/env/v1/bin/gsub -m 32
