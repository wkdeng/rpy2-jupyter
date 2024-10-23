###
 # @author [Wankun Deng]
 # @email [dengwankun@gmail.com]
 # @create date 2023-04-10 10:22:42
 # @modify date 2024-10-17 07:44:06
 # @desc [description]
###


# pkgs <- c(
#   'HGNChelper',
#   'openxlsx',
#   'spacexr',
#   'zinbwave'
# )

# install.packages('BiocManager')
 
# pkgs <- unique(pkgs)
# ap.db <- available.packages(contrib.url(BiocManager::repositories()))
# ap <- rownames(ap.db)
# pkgs_to_install <- pkgs[pkgs %in% ap]

# BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE)
# devtools::install_github(repo = "theMILOlab/SPATA2")
# devtools::install_github('cole-trapnell-lab/monocle3')
# devtools::install_github("dmcable/spacexr", build_vignettes = FALSE)
# devtools::install_github('YingMa0107/CARD')
# devtools::install_github('ziyili20/TOAST')
# devtools::install_github('xuranw/MuSiC')

# install.packages("devtools")

## cran server outage, use github instead date: 2023-10-27
# BiocManager::install('clustermole', update=FALSE, ask=FALSE)
# devtools::install_version("crossmatch", version = "1.3.1", repos = "http://cran.us.r-project.org")
# devtools::install_version("multicross", version = "2.1.0", repos = "http://cran.us.r-project.org")

# devtools::install_github("igordot/clustermole")
# devtools::install_github("cran/crossmatch")
# devtools::install_github("cran/multicross")

# devtools::install_github("jackbibby1/SCPA")
devtools::install_github('satijalab/seurat-data')
remotes::install_github("mojaveazure/seurat-disk")
remotes::install_github("dynverse/dyno")
devtools::install_github("YiPeng-Gao/scDaPars")
# BiocManager::install('derfinder')
devtools::install_github("lcolladotor/derfinder")
devtools::install_github('bernatgel/regioneR')
devtools::install_github("BMILAB/scAPAtrap")

BiocManager::install("BSgenome",ask=F,update=F)
BiocManager::install("RBGL",ask=F,update=F)
BiocManager::install("OrganismDbi",ask=F,update=F)
BiocManager::install("ggbio",ask=F,update=F)
devtools::install_github("BMILAB/movAPA")
BiocManager::install('BSgenome.Hsapiens.UCSC.hg38',ask=F,update=F)
BiocManager::install('TxDb.Hsapiens.UCSC.hg38.knownGene',ask=F,update=F)
BiocManager::install('motifStack',ask=F,update=F)
BiocManager::install('bamsignals',ask=F,update=F)
devtools::install_github("BMILAB/vizAPA")

if (!is.null(warnings()))
{
  w <- capture.output(warnings())
  if (length(grep("is not available|had non-zero exit status", w))) quit(save="no", status=0L, runLast = FALSE) 
}

unlink(x = '/tmp/*', recursive=T)
