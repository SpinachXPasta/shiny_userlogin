#Function to intialize the database.
init_db <- function(){
  #Initialize the users table
  conn <- dbConnect(RSQLite::SQLite(), paste0(fileLoc_runApp,"/R/db/users.db"))
  
  
  print ("Databse Initialized")
  
  # Set the encryption key
  dbExecute(conn, "PRAGMA key = 'defenceoftheancients';")
  
  #create the users schema if not already created.
  dbExecute(conn, "
    CREATE TABLE IF NOT EXISTS users (
    username TEXT NOT NULL PRIMARY KEY,
    password TEXT NOT NULL,
    role TEXT NOT NULL CHECK(role IN ('admin', 'user'))
    );
  ")
  
  #create the manager user and test user, if they don't exists when starting the app.
  dbExecute(conn, "
    INSERT OR IGNORE INTO users (username, password, role)
    VALUES 
        ('shiny_manager', 'apple', 'admin'),
        ('test_user_1', 'apple', 'user');
")
  
  #disconnect app
  dbDisconnect(conn)
}


#This function returns SQL query as a table. Input is a SQL query string
sqlite_dql  <- function(dql){
  #Initialize the users table
  conn <- dbConnect(RSQLite::SQLite(), paste0(fileLoc_runApp,"/R/db/users.db"))
  
  # Set the encryption key
  dbExecute(conn, "PRAGMA key = 'defenceoftheancients';")
  
  result = dbGetQuery(conn, dql)
  
  dbDisconnect(conn)
  
  return (result)
}





#This function is to define schemas, input is a SQL command string
sqlite_ddl <- function(ddl){
  #Initialize the users table
  conn <- dbConnect(RSQLite::SQLite(), paste0(fileLoc_runApp,"/R/db/users.db"))
  
  # Set the encryption key
  dbExecute(conn, "PRAGMA key = 'defenceoftheancients';")
  
  dbExecute(conn, ddl)
  
  
  dbDisconnect(conn)
}


#This functions modifies a table, takes in a SQL command string.
sqlite_dml <- function(dml){
  #Initialize the users table
  conn <- dbConnect(RSQLite::SQLite(), paste0(fileLoc_runApp,"/R/db/users.db"))
  
  # Set the encryption key
  dbExecute(conn, "PRAGMA key = 'defenceoftheancients';")
  
  dbExecute(conn, dml)
  
  
  dbDisconnect(conn)
}


#This function will return a dataframe of active users, password and role.
create_user_base <- function(){
  
  
  conn <- dbConnect(RSQLite::SQLite(), paste0(fileLoc_runApp,"/R/db/users.db"))
  
  # Set the encryption key
  dbExecute(conn, "PRAGMA key = 'defenceoftheancients';")
  
  result = dbGetQuery(conn, "SELECT * FROM users")
  
  
  dbDisconnect(conn)
  
  
  
  user_base <- tibble::tibble(
    user = result$username,
    password = sapply(result$password, sodium::password_store),
    permissions = result$role
  )
  
  
  return (user_base)
  
  
}






