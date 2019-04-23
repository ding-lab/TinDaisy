GBM run of 42 cases starting 4/17/19

What's new:
* Using 20190416 version of dbSnP-COSMIC
* Writing to /gscmnt/gc2541/cptac3_analysis/cromwell-workdir
* Running 6 runs at a time

-> these failed because of database transfer issues

Restarted 4/18 with 6, 3 failed to instantiate.  3 succeeded

4/19/19: Restarting several runs, investigating whether parallel works as expected:

bash 2_run_tasks.sh -J 5 C3L-00365 C3L-00674 C3L-01040 C3L-01045 C3L-01046 C3L-01327 C3L-01887 C3L-02041 C3L-02465 C3L-02504

# 4/19/19 run

Start on 4/19/19 ended up dying because YAML file directory was moved
      1 Failed
     17 Succeeded
     24 Unknown

To proceed with running of remainder, follow model of cromwell.LB:
Ran the following:
    runLogger.sh
    logStash.sh -f
To log and stash runs.  


2. Run cromwell
```
cq | grep -v Succeeded | cut -f 1 | bash 2_start_runs.sh -J 10  -
```

3. Cleaning up and rerunning

All old runs were stashed.  We look at new batch of runs with, ` cq -T `

This indicates which runs we should add to log and stash:
    cq -T | grep Succeeded | cut -f 1 | runLogger.sh -
    cq -T | grep Succeeded | cut -f 1 | logStash.sh -

There were four runs which had status of Running but which were zombie based on analysis of logs.
These four corresponded to errors issued by `parallel`.  We'll return these from scratch, and just delete
their data directory and logs
