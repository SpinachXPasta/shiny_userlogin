library("dplyr")


#The purpose of this function is to generate the path of the current script.
getCurrentFileLocation <-  function()
{
  this_file <- commandArgs() %>% 
    tibble::enframe(name = NULL) %>%
    tidyr::separate(col=value, into=c("key", "value"), sep="=", fill='right') %>%
    dplyr::filter(key == "--file") %>%
    dplyr::pull(value)
  if (length(this_file)==0)
  {
    this_file <- rstudioapi::getSourceEditorContext()$path
  }
  return(dirname(this_file))
}

#Save the current location of the runApp script to be used by other scripts.
fileLoc_runApp = getCurrentFileLocation()

#load required packages.
source(file.path(fileLoc_runApp,"R/functions/load_libs.R"), local = FALSE)$value # Load Libraries



library("shiny")
runApp(paste0(fileLoc_runApp,"/R"), launch.browser = TRUE)
#https://github.com/rstudio/rstudio/issues/5334
#force restrat to update css using ctr+f5