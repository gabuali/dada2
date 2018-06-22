DADA2 R workflow for profiling 16S sequence reads
======


* This repo contains workflows for resolving sequence variants from 16S sequencing reads using the DADA2 algorithm (https://www.ncbi.nlm.nih.gov/pubmed/27214047).

DADA2 R workflow for profiling 16S sequence reads consists of these two scripts:
--------------------------------------------------------------------------------


#### 1. dada2_cli.r - This wrapper script parses arguments from the command line and passes them to and invokes the DADA2 workflow. A simple example execution will look like this:
```./dada2_cli.r --input_dir=input```

#### 2. dada2_16S_paired-end.Rmd - DADA2 workflow for resolving sequence variants from 16S amplicon reads. In addition to OTU picking and taxonomy assignment, it will also produce a QC folder with visuals and read counts (before/after). 
  NOTE: This workflow requires paired-end 16S rDNA gene amplicon reads.
  NOTE: This workflow will analyze each sample independently to be able to process any sample size.  The option to pool samples for resolving sequence variants will be added.
  NOTE: Currently, the wrapper script dada2_cli.r and the workflow dada2_16S_paired-end.Rmd need to be in the same directory (and not in the input directory).  
  
dada2_16S_single-end.Rmd - does NOT exist yet.  This workflow will perform the same tasks as dada2_16S_paired-end.Rmd but for single reads.

dada2_exploratory.Rmd -  does NOT exist yet.  This script will be the visualization part of the workflow.  It will take the output from the above script and generate exploratory plots, with or without metadata depending if it's supplied.

Taxonomy reference databases are stored on hutlab3 at this location.  
  Currently, this path needs to be hardcoded into the dada2_16S_paired-end.Rmd workflow.
  /n/huttenhower_lab/data/dada2_reference_databases



#### Installation of DADA2 from github; github has the latest version.
From within an R session:
```
install.packages("devtools") # unless it's already installed
library("devtools")
devtools::install_github("benjjneb/dada2")
```

#### Installation of FastTree if not available in your environment
http://www.microbesonline.org/fasttree/#Install

#### Installation of R biom latest version - not necessary for DADA2 workflow.
```library(devtools)
install_github("joey711/biom")
```


#### Running DADA2 on hutlab servers and Odyssey

```
# If logged in on a hutlab server, load the DADA2 module that contains all the dependencies, but not the DADA2 wrapper and workflow scripts. The wrapper and workflow scripts need to be in your working directory from which DADA2 is run.
hutlab load dada2-3.6

# DADA2 can now be run with this command:
./dada2_cli.r --input_dir=input

# DADA2 can also be run on Odyssey using the SLURM queue manager with the example script in the repo:
sbatch dada2_sbatch.sh 

# NOTE: Prior to running make sure to install DADA2 R package dependencies. 
# Follow this guide for installing R packages on Odyssey.
https://www.rc.fas.harvard.edu/resources/documentation/software-on-odyssey/r/
```



===
* If logged in on an Odyssey node then load the below dependencies in your environment but see NOTE below.  It's better to login through hutlab servers and load the dada2 module.
NOTE:  Running DADA2 from an Odyssey login node will generate all output except the workflow report PDF.  Because there is an issue with Pandoc not being able to find a "ifxetex.sty" latex style file.  Hence best to use the hutlab dada2 module when running on Odyssey as well.

# Source new module system to load R 3.4, pandoc, and fasttree.
$ source new-modules.sh

# Load R version 3.4 in environment.
$ module load R/3.4.2-fasrc01

# Load pandoc into your environment before running DADA2, make sure it's version 1.12.3 or higher.
$ module load pandoc/2.0.2-fasrc01

# Load fasttree for constructing phylogeny.
$ module load fasttree/2.1.9-fasrc01




#####
TODO:
* Add option for pooling samples for resolving sequence variants.
* Set default settings for trimming/filtering, threading, pooled processing etc.
** All these should be modifiable on the command line as arguments passed to wrapper script.
* Stop after filtering and trimming to assess filtering params and ratios of surviving reads, then either proceed where left of or adjust QC and repeat from beginning.

