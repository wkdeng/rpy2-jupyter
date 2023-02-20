##############################
# author [Wankun Deng]
# email [dengwankun@hotmail.com]
# create date 2023-02-15 18:35:29
# modify date 2023-02-15 18:35:29
# desc [description]
#############################

pkgs <- c(
  'devtools',
  'ComplexHeatmap',
  'tidyverse',
  'dplyr',
  'sparklyr',
  'tiff',
  "Rgraphviz",
  "rmarkdown",
  'htmlwidgets',
  'webshot',
  'networkD3',
  'psycModel',
  'rlist',
  'WGCNA',
  'RUVSeq',
  "IRanges",
  "GenomicRanges",
  "GenomicAlignments",
  "GenomicFeatures",
  'tximport',
  'rhdf5',
  'DESeq2',
  'DESeq',
  'sf',

  # single cell
  'Seurat',
  'ggthemes',
  'SeuratData',
  'Signac',
  'EnsDb.Hsapiens.v86',
  'cowplot',
  'multtest',
  'metap',
  'celldex',
  'scRNAseq',
  'ggplot2',
  'colorspace',
  'circlize',
  'Hmisc',
  'scales',
  'Rtsne',
  'corrplot',
  'preprocessCore',
  'locfdr',
  'dendextend',
  'ggpubr',
  'MASS',
  'reshape2',
  'ggseqlogo',
  'stringr',
  'RColorBrewer',
  'Cooccur',
  'plyr',
  'networkD3',
  'IRkernel',

  ##
  'BiocGenerics', 
  'DelayedArray', 
  'DelayedMatrixStats',
  'limma', 
  'lme4', 
  'S4Vectors', 
  'SingleCellExperiment',
  'SummarizedExperiment', 
  'batchelor', 
  'HDF5Array',
  'terra', 
  'ggrastr',
  'Matrix.utils',
  'EBImage'
)

install.packages('BiocManager')

pkgs <- unique(pkgs)
ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
pkgs_to_install <- pkgs[pkgs %in% ap]

BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE)
# From github
devtools::install_github(repo = "kueckelj/confuns")
devtools::install_github(repo = "theMILOlab/SPATA2")

# if you want to use monocle3 related wrappers 
devtools::install_github('cole-trapnell-lab/leidenbase')
devtools::install_github('cole-trapnell-lab/monocle3')
suppressWarnings(BiocManager::install(update=TRUE, ask=FALSE))
# Remove tmp directory
packageurl <- "https://cran.r-project.org/src/contrib/Archive/kohonen/kohonen_2.0.19.tar.gz"
install.packages(packageurl, repos = NULL, type = "source")
# just in case there were warnings, we want to see them
# without having to scroll up:
warnings()
IRkernel::installspec(user = FALSE)
update.packages(ask = FALSE)


if (!is.null(warnings()))
{
  w <- capture.output(warnings())
  if (length(grep("is not available|had non-zero exit status", w))) quit(save="no", status=0L, runLast = FALSE)
}

unlink(x = '/tmp/*', recursive=T)
