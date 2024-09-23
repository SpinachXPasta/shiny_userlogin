library(dplyr)
library(shiny)
library(shinyauthr)
library(DBI)
library(RSQLite)
library("shiny.router")


# Create ADMIN user
# dataframe that holds usernames, passwords and other user data
#user_base <- tibble::tibble(
#  user = c("shiny_manager", "test_user_1"),
#  password = sapply(c("apple", "apple"), sodium::password_store),
#  permissions = c("admin", "standard"),
#  name = c("Shiny APP Admin", "Test User")
#)



#load modules for the server
source(file.path(fileLoc_runApp, "R/functions/db_functions.R"), local = FALSE)$value # Load Libraries
source(file.path(fileLoc_runApp, "R/functions/onclick_functions.R"), local = FALSE)$value # Load Libraries


shinyServer(function(input, output) {
  
  #creates a list of values that can store values in the server.
  workingMem = reactiveValues()
  
  source(file.path("server_components/debug_tab_server.R"), local = TRUE)$value # debug tab
  source(file.path("server_components/registration_modal_server.R"), local = TRUE)$value # registration modal tab
  source(file.path("server_components/admin_page_server.R"), local = TRUE)$value
  source(file.path("server_components/generic_user_page_server.R"), local = TRUE)$value
  
  #process inititializes database. source #R/functions/db_functions
  init_db()
  
  #create datframe with user info, source #R/functions/db_functions
  user_base <- create_user_base()
  
  #creates an authorization method using the user_base dataframe.
  credentials <- shinyauthr::loginServer(
    id = "login",
    data = user_base,
    user_col = user,
    pwd_col = password,
    sodium_hashed = TRUE,
    log_out = reactive(logout_init())
  )
  
  # Logout to hide
  logout_init <- shinyauthr::logoutServer(
    id = "logout",
    active = reactive(credentials()$user_auth)
  )
  
  
  #load the server component of the main page.
  source(file.path("server_components/main_server.R"), local = TRUE)$value # main page
  
  
  
  
  
  
})