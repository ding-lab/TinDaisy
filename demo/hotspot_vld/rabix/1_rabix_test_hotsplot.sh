CWL="../../../cwl/workflows/hotspot_vld.cwl"
YAML="cwl-yaml/hotspot-vld.yaml"

mkdir -p results
RABIX_ARGS="--basedir results"

rabix $RABIX_ARGS $CWL $YAML

