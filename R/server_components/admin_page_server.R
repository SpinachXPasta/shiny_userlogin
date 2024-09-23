##admin
output$user_table <- renderDataTable({
  
  req(credentials()$user_auth)
  req(credentials()$info[["permissions"]] == "admin")
  
  users = sqlite_dql("SELECT * FROM users")
  
  users["modify"] = paste0("<button id = ",users$username,"_modify class='shiny-bound-input action-button'",onclick_to_event_id("admin_modify_trigger"),", style = 'font-weight: 700; cursor: pointer;'>Modify</button>") #when the modify button is triggered the button id is assigned to the value of trigger
  users["delete"] = paste0("<button id = ",users$username,"_delete class='shiny-bound-input action-button'",onclick_to_event_id("admin_delete_trigger"),", style = 'font-weight: 700; cursor: pointer;'>Delete</button>") 
  
  users  = users %>%
    mutate(delete = if_else(role == "admin", "", delete))
  
  #https://stackoverflow.com/questions/62794827/r-shiny-run-js-after-htmlwidget-renders
  data.table::data.table(users)
  
  
},escape = FALSE,  options = list(dom = 't', ordering=FALSE),
class = list(stripe = FALSE), colnames = c("User Name", "Password", "Role", "",""), selection = "none")


observeEvent(input$admin_modify_trigger, {
  
  
  
  #show which button triggered modal
  #req(input$admin_modify_trigger)
  x = input$admin_modify_trigger #this apoints the value of the button that triggered the event
  
  
  user = sqlite_dql(paste0("SELECT * FROM users where username = '",str_split(x, "_modify")[[1]][1],"'"))
  
  print (user)
  
  runjs(paste0("Shiny.setInputValue('admin_modify_selected_username','",user$username,"')"))
  
  showModal(modalDialog(id = paste0("admin_modify_modal","_",str_split(x, "_modify")[[1]][1]),
                        HTML(paste0("<span User style = 'font-weight:700;color:blue;'>","User: ", user$username, "</span></br></br>")),
                        textInput('admin_modify_modal_password', 'Password', value = user$password),
                        footer=tagList(
                          actionButton('admin_modify_submit', 'Submit'),
                          modalButton('cancel')
                        )
  ))
})




observeEvent(input$admin_delete_trigger, {
  
  #create id's for rows
  # index 1 is the which holds the username
  runjs("document.querySelectorAll('#user_table_admin table tbody tr').forEach(row => {
               const secondTdText = row.querySelectorAll('td')[1].textContent;
               row.id = secondTdText + '_row_id';
             });")
  
  #show which button triggered modal
  #req(input$admin_modify_trigger)
  x = input$admin_delete_trigger #this apoints the value of the button that triggered the event
  
  user_0 = str_split(x, "_delete")[[1]][1]
  
  sqlite_dml(paste0("DELETE FROM users WHERE username =  '",user_0,"'"))
  
  removeUI(paste0("#",user_0,"_row_id"))
  
  print (paste0(user_0, " has been delated."))
  
  
})




#when the admin modifies password etc.
observeEvent(input$admin_modify_submit,{
  

  p1 = 0
  reg = 0
  

  
  runjs('document.getElementById("admin_modify_modal_password-label").innerHTML = "Password";');
  
  
  if ( input$admin_modify_modal_password == ""){
    print ("Registration is null")
    runjs('document.getElementById("admin_modify_modal_password-label").innerHTML = "Password <span style=\'color: red;\'>cannot be empty</span>";');
    p1 = 1
  }
  
  

  
  if (p1 == 0){
    runjs(paste0("
          
          const firstnode = document.querySelector('[id^=\"admin_modify_modal\"]');
          const username_admin_mod = firstnode.id.split(\"admin_modify_modal_\")[1]
          
          
          document.querySelectorAll('#user_table_admin table tbody tr').forEach(row => {
               const secondTdText = row.querySelectorAll('td')[1].textContent;
               row.id = secondTdText + '_row_id';
             });
             
          const row_username_id = username_admin_mod +'_row_id';
          
          
          document.querySelectorAll(`#${row_username_id}`).forEach(row => {
               row.querySelectorAll('td')[2].innerText = '",input$admin_modify_modal_password,"';
             });
          
          "))
    
    sqlite_dml(paste0("UPDATE users
        SET password = '",input$admin_modify_modal_password,"'
        WHERE username = '",input$admin_modify_selected_username,"';
                      "))
    
    removeModal()
    
  }
  
  
  
})






##