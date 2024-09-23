

output$sidebarpanel <- renderUI({
  
  # Show only when authenticated
  req(credentials()$user_auth)
  
  tagList(
  
    column(width = 4,
           p(paste("You have", credentials()$info[["permissions"]],"permission"))
    )
  )
  
})

# Login UI / switch between admin and user UI.
output$placeholder_1 <- renderUI({
  
  # Show plot only when authenticated
  req(credentials()$user_auth)
  
  
  
  
  div(
    #show white spaces in the table output
    #https://forum.posit.co/t/render-dt-show-whitespace/70161
    #tags$style("#diffTable { white-space:pre; padding-top: 10%}"),
    tabsetPanel(fluidRow(
            div(id = "user_table_admin",
             dataTableOutput("user_table"))
              ),
            
            div(id = "general_user_div",
                uiOutput("generic_page")
              
            )
    
      )
    )
  
})








output$main_sub_ui_1 <- renderUI({
  
  #Once signed in update tab
  req(credentials()$user_auth)
  runjs('document.getElementById("main_tab_text").innerText = "Main Tab";');
  runjs('document.getElementById("main_tab_icon").classList.remove("fa-solid", "fa-arrow-right-to-bracket");');
  runjs('document.getElementById("main_tab_icon").classList.add("fa", "fa-file");');
  
  div(
  # Sidebar to show user info after login
  uiOutput("sidebarpanel"),
  
  # Plot to show user info after login
  uiOutput("placeholder_1")#,
  )
})



# Run custom code on logout
observeEvent(logout_init(), {
  if (!credentials()$user_auth) {
    # Your custom code here
    runjs('document.getElementById("main_tab_text").innerText = "Login";');
    runjs('document.getElementById("main_tab_icon").classList.remove("fa", "fa-file");');
    runjs('document.getElementById("main_tab_icon").classList.add("fa-solid", "fa-arrow-right-to-bracket");');
    runjs("window.location.reload()")
    print("User has logged out")
  }
})







