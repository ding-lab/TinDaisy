Much of the CWL code here was developed using Rabix Composer.  However, there are changes
which need to be made to the code before it can be used in production Cromwell runs:

# Cromwell-specific changes
  Cromwell will not run on workflows directly from Composer and need to be edited slightly.
  This has to do with removing `-` symbol in the workflow CWL file: change something like 
```
outputs:
   - id: output_maf
     outputSource:
       - vcf_2_maf/output_maf
```
to
```
outputs:
  - id: output_maf
      outputSource:
        vcf_2_maf/output_maf
```

# Stylystic changes
 - for consistency and ease of editing, all sbg-specific fields are removed.  These include
    ``
    $namespaces:
      sbg: 'https://www.sevenbridges.com/'
    ```
    and all instances like this:
    ```
        'sbg:x': 247.28125
        'sbg:y': 1123.8125
    ```

