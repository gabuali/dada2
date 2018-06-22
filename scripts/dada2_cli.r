#!/usr/bin/env Rscript

## Collect arguments
args <- commandArgs(TRUE)

## Print help message when no arguments passed
if(length(args) < 1) {
  args <- c("--help")
}

## Help section
if("--help" %in% args) {
  cat("
      dada2_cli.r
      
      Arguments:
      --input_dir=path/to/dir     - (relative) path to directory containing raw input '.fastq' or '.fastq.gz' files
      --output_dir=path/to/dir    - (relative) path to output directory [default='output']
      --pool                      - logical, if provided then samples are pooled for analysis.
                                    Default setting is analysis of each sample independently [pool=FALSE].
      --help                      - print this text
      
      Example:
      ./dada2_cli.r --input_dir=input \n\n")
  
  q(save="no")
}

#args <- "--input_dir=input"  THIS line is for testing

# If sample pooling logical is not provided, then default to FALSE, i.e. for independent analysis of each sample.
# Otherwise, if set then TRUE for pooling samples.
if( any( grepl("--pool", args) ) ) {
  args <- gsub( "--pool", "--pool=TRUE", args)
} else {
  args <- c(args, "--pool=FALSE")
}
 
## Parse arguments (we expect the form --arg=value)
parseArgs <- function(x) strsplit(sub("^--", "", x), "=")
args.df <- as.data.frame(do.call("rbind", parseArgs(args)))

args.list <- as.list(as.character(args.df$V2))
names(args.list) <- args.df$V1

## Arg1 default
if(is.null(args.list$input_dir)) {
  stop("At least one argument must be supplied (input folder).\n", call.=FALSE)
}

# Print args list to STDOUT
for( i in names(args.list) ) {
  cat( i, "\t", args.list[[i]], "\n")
}

# print contents of folder
cat( grep( "*\\.fastq", list.files(args.list$input_dir), value=T ), sep = "\n" )

# these variables are passed to the workflow
input.path <- normalizePath( args.list$input_dir )
output.dir <- ifelse( is.null(args.list$output_dir), "output", args.list$output_dir )
pool.samples <- args.list$pool


# Run dada2 Rmarkdown workflow and output report using Rmarkdown
library(knitr)
rmarkdown::render("dada2_16S_paired-end.Rmd",
                  output_file = paste( output.dir, "/16Sreport_dada2_", Sys.Date(), ".pdf", sep='')
)


