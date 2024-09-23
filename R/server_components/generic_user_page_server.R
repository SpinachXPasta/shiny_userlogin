output$generic_page = renderUI({
  req(credentials()$user_auth)
  req(credentials()$info[["permissions"]] != "admin")
  HTML("Generic User Section")})