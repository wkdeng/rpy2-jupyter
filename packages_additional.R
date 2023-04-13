###
 # @author [Wankun Deng]
 # @email [dengwankun@gmail.com]
 # @create date 2023-04-10 10:22:42
 # @modify date 2023-04-10 10:22:42
 # @desc [description]
###

pkgs <- c(
  'HGNChelper',
  'openxlsx',
  'spacexr'
)

install.packages('BiocManager')

pkgs <- unique(pkgs)
ap.db <- available.packages(contrib.url(BiocManager::repositories()))
ap <- rownames(ap.db)
pkgs_to_install <- pkgs[pkgs %in% ap]

BiocManager::install(pkgs_to_install, update=FALSE, ask=FALSE)
devtools::install_github(repo = "theMILOlab/SPATA2")
devtools::install_github('cole-trapnell-lab/monocle3')

if (!is.null(warnings()))
{
  w <- capture.output(warnings())
  if (length(grep("is not available|had non-zero exit status", w))) quit(save="no", status=0L, runLast = FALSE)
}

unlink(x = '/tmp/*', recursive=T)
