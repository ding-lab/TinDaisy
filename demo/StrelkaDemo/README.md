
Goal here is to run StrelkaDemo dataset using Rabix

For developing / debugging, sometimes cwltools is easier:

pushd ../..; cwltool cwl/workflows/tindaisy.cwl demo/StrelkaDemo/project_config.StrelkaDemo.yaml
