###
 # @author [Wankun Deng]
 # @email [dengwankun@gmail.com]
 # @create date 2023-04-10 10:22:42
 # @modify date 2023-06-22 14:50:09
 # @desc [description]
###

pkgs <- c(
  'HGNChelper',
  'openxlsx',
  'spacexr',
  'zinbwave'
)

install.packages('BiocManager')
 
pkgs <- unique(pkgs)
ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
pkgs_to_install <- pkgs[pkgs %in% ap]

BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE)
devtools::install_github(repo = "theMILOlab/SPATA2")
devtools::install_github('cole-trapnell-lab/monocle3')
devtools::install_github("dmcable/spacexr", build_vignettes = FALSE)
devtools::install_github('YingMa0107/CARD')
devtools::install_github('ziyili20/TOAST')
devtools::install_github('xuranw/MuSiC')

# install.packages("devtools")
devtools::install_version("crossmatch", version = "1.3.1", repos = "http://cran.us.r-project.org")
devtools::install_version("multicross", version = "2.1.0", repos = "http://cran.us.r-project.org")
devtools::install_github("jackbibby1/SCPA")

if (!is.null(warnings()))
{
  w <- capture.output(warnings())
  if (length(grep("is not available|had non-zero exit status", w))) quit(save="no", status=0L, runLast = FALSE)
}

unlink(x = '/tmp/*', recursive=T)
