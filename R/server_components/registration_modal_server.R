


observeEvent(input$register_button_trigger, {
  # display a modal dialog with a header, textinput and action buttons
  showModal(modalDialog(id = "registration_modal",
    tags$h2('Please enter your information'),
    textInput('registration_modal_username', 'Username'),
    passwordInput('registration_modal_password', 'Password'),
    passwordInput('registration_modal_password_2', 'Retype Password'),
    footer=tagList(
      actionButton('user_registration_submit', 'Submit'),
      modalButton('cancel')
    )
  ))
})



observeEvent(input$user_registration_submit,{
  
  uname = 0
  p1 = 0
  p2 = 0
  reg = 0
  #reset
  runjs('document.getElementById("registration_modal_username-label").innerHTML = "Username";')
  runjs('document.getElementById("registration_modal_password-label").innerHTML = "Password";');
  
  
  if (input$registration_modal_username == ""){
    print ("Registration is null")
    runjs('document.getElementById("registration_modal_username-label").innerHTML = "Username <span style=\'color: red;\'>cannot be empty</span>";');
    uname = 1
  }
  
  
  if ( input$registration_modal_password == "" | input$registration_modal_password_2 == ""){
    print ("Registration is null")
    runjs('document.getElementById("registration_modal_password-label").innerHTML = "Password <span style=\'color: red;\'>cannot be empty</span>";');
    p1 = 1
    p2 = 1
  }
  
  
  if ( (input$registration_modal_password != "" & input$registration_modal_password_2 != "") &
       (input$registration_modal_password != input$registration_modal_password_2)
       
       ){
    print ("Registration is null")
    runjs('document.getElementById("registration_modal_password-label").innerHTML = "Password <span style=\'color: red;\'>need to macth</span>";');
    p1 = 1
    p2 = 1
  }
  
  
  
  if (uname + p1 + p2 == 0){
    db_query_registration_1 = sqlite_dql("SELECT * FROM users")
    db_query_registration_2 = sqlite_dql(paste0("SELECT * FROM users WHERE username = '",input$registration_modal_username,"'"))
    
    
    
    if (nrow(db_query_registration_1) == 0 | nrow(db_query_registration_2) == 0){
      sqlite_dml(
        paste0("INSERT INtO users VALUES ('",input$registration_modal_username,"','",input$registration_modal_password,"','user')")
      )
    } else {
      
      runjs('document.getElementById("registration_modal_username-label").innerHTML = "Username <span style=\'color: red;\'>already exists</span>";');
      reg = 1
    }
    
    
    #print ("Looks good")
  }
  
  
  if (sum(uname,p1,p2,reg) == 0){
    runjs('document.getElementById("registration_modal_username-label").innerHTML = "Username <span style=\'color: green;\'>&#x2705;</span>";');
    runjs('document.getElementById("registration_modal_password-label").innerHTML = "Password <span style=\'color: green;\'>&#x2705;</span>";');
    runjs('document.getElementById("registration_modal_password_2-label").innerHTML = "Password <span style=\'color: green;\'>&#x2705;</span>";');
    Sys.sleep(1.2)
    removeModal()
    runjs("window.location.reload()")
  }
  
  
  
})