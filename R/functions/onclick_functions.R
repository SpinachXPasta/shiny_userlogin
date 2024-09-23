onclick_to_event_id <- function(trigger_id) {
  return(paste0("onClick = '((ev) => {
  
                Shiny.setInputValue(\"", trigger_id  ,"\", ev.target.id, {priority: \"event\"});
            
            
            })(event)'"))
}