Workflow for restarting past runs is based on work here:
/gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/MMRF_WXS_restart

To implement new strategy, restarted at the merge step.  Restart of ~950 MMRF runs originally perfomed on:
/gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/MMRF_WXS_20190425


# `RESTART_MAP`

`RESTART_MAP="dat/MMRF-20190925.map.dat"`

```
$ rl MMRF-20190925.map.dat
/gscmnt/gc2737/ding/fernanda/Somatic_MMY/MMRF/MMRF_WXS_restart/dat/MMRF-20190925.map.dat

$ head MMRF-20190925.map.dat
MMRF_1016   2c210004-7e16-49cf-8c0c-7dcee82ace2f
MMRF_1020   42bd11f4-6f55-45ef-bfbf-14044550cab6
```

`RESTART_MAP` is used by `runplan`.  From the documentation there,
```

-R RESTART_MAP: file listing workflow IDs for each case when restarting runs.  Requires RESTART_ROOT in PARAMS

Restarting of runs is supported by making available RESTART_D variable in YAML
template, which provides path to root directory of prior run.
RESTART_D="RESTART_ROOT/UUID", with RESTART_ROOT defined in PARAMS (mandatory),
and UUID obtained from RESTART_MAP file (TSV with CASE and UUID, `cq | cut -f 1-2` will work)
```

In future development, might be better to pass analysis_summary file

