# Tabular and graphical summaries of hourly data to support QA/QC

# Add code for the following
# 
# 'azmet-shiny-template.html': <!-- Google tag (gtag.js) -->


# UI --------------------

ui <- 
  htmltools::htmlTemplate(
    "azmet-shiny-template.html",
    
    pageDataViewerHourly = bslib::page(
      title = NULL,
      theme = theme, # `scr##_theme.R`
      #lang = "en",
      
      bslib::layout_sidebar(
        sidebar = pageSidebar, # `scr##_slsSidebar.R`
        navsetCardTab
      ),
      
      shiny::htmlOutput(outputId = "pageBottomText") # Common, regardless of card tab
    )
  )


# Server --------------------

server <- function(input, output, session) {
  shinyjs::useShinyjs(html = TRUE)
  shinyjs::hideElement("timeseriesAccordion")
  shinyjs::hideElement("pageBottomText")
  
  
  # Observables -----
  
  shiny::observeEvent(input$retrieveHourlyData, {
    if (input$startDate > input$endDate) {
      shiny::showModal(datepickerErrorModal) # `scr06_datepickerErrorModal.R`
    }
  })
  
  shiny::observeEvent(hourlyData(), {
    shinyjs::showElement("timeseriesAccordion")
    shinyjs::showElement("pageBottomText")
    
    shiny::updateSelectInput(
      inputId = "stationGroup",
      label = "Station Group",
      choices = sort(unique(hourlyData()$meta_station_group)),
      selected = sort(unique(hourlyData()$meta_station_group))[1]
    )
    
    shiny::updateSelectInput(
      inputId = "stationVariable",
      label = "Station Variable",
      choices = c(hourlyVarsMeasured, hourlyVarsDerived),
      selected = c(hourlyVarsMeasured, hourlyVarsDerived)[1]
    )
  })
  
  
  # Reactives -----
  
  hourlyData <- shiny::eventReactive(input$retrieveHourlyData, {
    idRetrievingHourlyData <- shiny::showNotification(
      ui = "Retrieving hourly data . . .",
      action = NULL,
      duration = NULL,
      closeButton = FALSE,
      id = "idRetrievingHourlyData",
      type = "message"
    )
    
    on.exit(
      shiny::removeNotification(id = idRetrievingHourlyData), 
      add = TRUE
    )
    
    fxn_hourlyData(
      azmetStation = NULL,
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
  
  # Outputs -----
  
  output$table <- renderTable({
    hourlyData()
  })
  
  output$pageBottomText <- shiny::renderUI({
    #shiny::req(hourlyData())
    fxn_pageBottomText()
  })
  
  output$timeseriesGraph <- plotly::renderPlotly({
    fxn_timeseriesGraph(
      inData = hourlyData(),
      stationGroup = input$stationGroup,
      stationVariable = input$stationVariable
    )
  })
  
  output$timeseriesGraphFooter <- shiny::renderUI({
    shiny::req(hourlyData())
    fxn_timeseriesGraphFooter()
  })
  
  output$timeseriesGraphHelpText <- shiny::renderUI({
    shiny::req(hourlyData())
    fxn_timeseriesGraphHelpText()
  })
  
  output$timeseriesGraphTitle <- shiny::renderUI({
    shiny::req(hourlyData())
    fxn_timeseriesGraphTitle(
      startDate = input$startDate,
      endDate = input$endDate
    )
  })
  
  output$stationGroupsTable <- reactable::renderReactable({
    stationGroupsTable
  })
}


# Run --------------------

shinyApp(ui = ui, server = server)
