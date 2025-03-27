If you download this repo and gzip the two fastq files, you should be able to run

```
bash bioinfo_bwa_W.sh test
```
  
in a linux shell and generate a bunch of files. Still working on how to best interperet the .vcfs but
the general idea was to explore a parameter for bwa mem. I chose the -W parameter (bandWidth); I was more
interested in dynamically selecting values than the results, given that the files we
were working with were just some test data. Other parameters could have been explored
but I wanted to do something a little bit different with it.
