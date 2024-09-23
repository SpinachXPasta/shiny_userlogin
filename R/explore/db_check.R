

conn <- dbConnect(RSQLite::SQLite(), paste0("C:/Users/spachhai/OneDrive - Gilead Sciences/Desktop/Study/Biostatistics/Programming/FinalProj/main_app/spachhai_app/R/db/users.db"))

# Set the encryption key
dbExecute(conn, "PRAGMA key = 'defenceoftheancients';")

result = dbGetQuery(conn, "SELECT * FROM users")

print (result)

dbDisconnect(conn)






