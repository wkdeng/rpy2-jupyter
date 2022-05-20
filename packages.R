
pkgs <- c(
  'devtools',
  'ComplexHeatmap',
  # tidyverse suite
  'tidyverse',
  # 'multidplyr',
  'dplyr',
  # 'dtplyr',
  # 'dbplyr',
  'sparklyr',
  'devtools',
  # 'formatR',
  # 'remotes',
  # 'selectr',
  # 'tidymodels',
  'tiff',
  "Rgraphviz",
  "rmarkdown",
  'htmlwidgets',
  'webshot',
  'networkD3',
  # "httr",
  # "knitr",
  # Bioconductor packages
  # 'PCAtools',
  # "clusterProfiler",
  # "ReactomePA",
  # "org.Hs.eg.db",
  # "org.Mm.eg.db",
  # "DOSE",
  # "enrichplot",
  # "msigdbr",
  # "pathview",
  # "ggnewscale",
  # "BiocStyle",
  # "OrganismDbi",
  # "ExperimentHub",
  # "Biobase",
  # "BiocParallel",
  # "biomaRt",
  # "Biostrings",
  # "BSgenome",
  # "ShortRead",
  "IRanges",
  "GenomicRanges",
  "GenomicAlignments",
  "GenomicFeatures",

  # "SummarizedExperiment",
  # "VariantAnnotation",
  # "DelayedArray",
  # 'ComplexHeatmap',
  # "GSEABase",
  # "Gviz",
  # "graph",
  # "RBGL",
  # 'vsn',
  # "polyester",
  # "ffpe",
  # "BatchQC",

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
  'networkD3'
)

install.packages('BiocManager')

pkgs <- unique(pkgs)
ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
pkgs_to_install <- pkgs[pkgs %in% ap]

BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE)
# From github
# devtools::install_github(repo = "TillF/ppso", upgrade = 'always', force = TRUE)
# devtools::install_github('satijalab/seurat-data')

suppressWarnings(BiocManager::install(update=TRUE, ask=FALSE))
# Remove tmp directory

# just in case there were warnings, we want to see them
# without having to scroll up:
warnings()

if (!is.null(warnings()))
{
  w <- capture.output(warnings())
  if (length(grep("is not available|had non-zero exit status", w))) quit(save="no", status=0L, runLast = FALSE)
}

unlink(x = '/tmp/*', recursive=T)
