# <App description>

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->
# 'azmet-shiny-template.html': <!-- CSS specific to this AZMet Shiny app -->

# Edit the following [in square brackets]:
# 
# 'azmet-shiny-template.html': <span class="lm-az"></span>
# 'azmet-shiny-template.html': <h1 class="mt-4 d-inline">[Web Tool Name]</h1>
# 'azmet-shiny-template.html': <h4 class="mb-0 mt-2">[High-level text summary]</h4>


# Libraries
# library(azmetr)
# library(dplyr)
# library(htmltools)
# library(lubridate)
# library(shiny)
# library(vroom)

# Functions
#source("./R/fxnABC.R", local = TRUE)

# Scripts
#source("./R/scr##DEF.R", local = TRUE)


# UI --------------------

ui <- htmltools::htmlTemplate(
  
  "azmet-shiny-template.html",
  
  
) # htmltools::htmlTemplate()


# Server --------------------

server <- function(input, output, session) {
  
  # Observables -----
  
  # Reactives -----
  
  # Outputs -----
  
}


# Run --------------------

shinyApp(ui = ui, server = server)
