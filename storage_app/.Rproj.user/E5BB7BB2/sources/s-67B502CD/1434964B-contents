
library(shiny)
library(leaflet)
library(DT)
library(RMySQL)
#library(odbc)
library(DBI)
library(bslib)
library(dplyr)

host = 'database-test-aaron.ctbo7gbl6fdf.eu-west-1.rds.amazonaws.com'
user = 'admin'
password = 'Ireland2'
port=3306

get_remote_data <- function() {
  con <- 
    DBI::dbConnect(
    MySQL(),  
    host=host,
    #host="127.0.0.1",
    user=user,
    password=password,
    db='mydatabase',#'mydb',
    port=port#,
    )
  
  remote_df <- dbGetQuery(con,'SELECT who, lat, lng, `when` 
           FROM maps')
  
  dbDisconnect(con)
  
  return(remote_df)
}

remote_data <- get_remote_data()

# Define UI for application that draws a histogram
ui <- fluidPage(theme = bslib::bs_theme(bootswatch = 'paper'),
                
                tags$head( includeScript("gomap.js"),
                tags$style(HTML("table.dataTable.hover tbody tr:hover, table.dataTable.display tbody tr:hover {
                                  background-color: orange !important;
                                  }
                                  ")),
        tags$style(HTML(".dataTables_wrapper .dataTables_length, .dataTables_wrapper .dataTables_filter, .dataTables_wrapper .dataTables_info, .dataTables_wrapper .dataTables_processing,.dataTables_wrapper .dataTables_paginate .paginate_button, .dataTables_wrapper .dataTables_paginate .paginate_button.disabled {
            color: black !important;
        }"))),
                    #bs_theme(primary = "#dd2020") ,
               #  tags$head(
               # tags$style(type = 'text/css', 
               #            HTML('.tab-panel{ background-color: red; color: white}
               #                 .navbar-default .navbar-nav > .active > a, 
               #                 .navbar-default .navbar-nav > .active > a:focus, 
               #                 .navbar-default .navbar-nav > .active > a:hover {
               #                 color: #555;
               #                 background-color: green;
               #                 }')
               #            )
               #            ),
br(),br(),
    # Application title
    #titlePanel("Where do you want to go ?"),br(),br(),
    navbarPage(title = "Where do you want to go ?",selected = 'map', br(),br(),
        tabPanel('map',
    fluidRow(
        column(5,br(),
           fillRow(height=50,
                   actionButton('submit','Submit'),
                   textInput(inputId = 'name','Name')),
           br(),
           leafletOutput('map'),
           br(),br(),
           
          textOutput('map_click_output')
           
    ),
    column(5,
           DTOutput('table'),
           actionButton('send','SEND to Database'))
    )
    ),
    tabPanel('Introduction',
             h3('Intro'),
             tags$li('hello'),
             tags$li('This app demonstrates among other things,
             persistent storage using a mysql database hosted on AWS'),
             tags$li('It leverages good practice in database communication and
             read write permissions'),
             tags$li('It utilises reactive programming paradigms to fully engage
             in server side rending in responsive to users interaction with the 
             User Interface'),
             h3('TODO'),
             tags$li('Host on AWS EC2/lightsail/fargate'),
             tags$li('Secure using aws best principles, VPC, subnets, 
             internet gateways, Network access control lists'),
             tags$li('Secure login entry routes usign AWS cognito'),
             )
),
    tags$span(icon("tag"), style = "display: none;")
)


# Define server logic required to draw a histogram
server <- function(input, output,session) {

    output$map <- renderLeaflet({
        leaflet()%>%
            leaflet::addTiles()
    })
    
    new_table_contents <- reactiveVal({
        NULL
    })
    
    current_table_contents <- reactiveVal({
        remote_data%>%
        mutate(across(c('lat','lng'),as.numeric))%>%
                      mutate(action = paste('<a class="go-map" href= ""data-lat="', lat, '"data-lng="', lng, '"data-where="', row_number(),'">','jump to ',row_number(),'</a>', sep=""))%>%
                      mutate(action=ifelse(row_number()==1,NA,action))
        })
    
    tbl <- dataTableProxy('table')
    
    observeEvent(input$submit,{
        
        req(input$map_click,input$name,cancelOutput = TRUE)
      
        leaf%>%removeMarker(layerId = 'mark')

        time <- Sys.time()
        
        x <- data.frame(who=input$name,
                                 lat=round(as.numeric(input$map_click$lat),2),
                                 lng=round(as.numeric(input$map_click$lng),2),
                                 when=Sys.time())%>%
            mutate(action = paste('<a class="go-map" href="" data-lat="', lat, '" data-lng="', lng, '" data-where="', nrow(.)+1,'">','jump to ',row_number(),'</a>', sep=""))
#                                  <a class="go-map" href="" data-lat="42.1423208764301" data-long="-72.7718053330646"><i class="fa fa-car" role="presentation" aria-label="car icon"></i></a>
        print(paste('x',x))
        
        tbl%>%addRow(data = x )
        
        if(is.null( new_table_contents())){

        new_table_contents(x%>%select(-action))
        }else{
        new_table_contents(rbind(new_table_contents(),x%>%select(-action)))

          }
        
        y <- rbind(current_table_contents(),x)
        
        current_table_contents(y)
        #new_table_contents(y)
                       
        
        })
    
    observeEvent(input$send,{
      
       if(is.null( new_table_contents())){
         return()}else{
        con <-
            DBI::dbConnect(
                RMySQL::MySQL(),
                host = host,
                #host="127.0.0.1",
                user = user,
                password = password,
                db = 'mydatabase',
                #'mydb',
                port = port#,
            )
        
        print(new_table_contents())
        
        
        DBI::dbWriteTable(
            con,
            #database = 'mydatabase',
            name = "maps",
            value = new_table_contents(),
            append = TRUE,
            row.names = FALSE
        )
        
            dbDisconnect(con)
            
            new_table_contents(NULL)
}
    })
    
    
    
    leaf <- leafletProxy('map')
    
    table_clicked <- reactive({
        input$table_rows_selected
        })
    
    observeEvent(table_clicked(),{
        print(table_clicked())
        leaf%>%leaflet::clearGroup('previous')
        #removeMarker(layerId = 'previous')
        
        x <- rbind(current_table_contents())[input$table_rows_selected,]
        print(x)
        x <- x%>%mutate(across(c(lng,lat),as.numeric))
        print(x)
        print(x$lng)
        leaf%>%
            addCircleMarkers(stroke = FALSE,
                             popup = lapply(htmltools::HTML,X = 
                                 paste0('<strong>',x$who,'</strong>','</br>',x$when)),
                             fill = TRUE,
                             fillColor = 'orange',fillOpacity = 0.7,
                             data=
                           rbind(remote_data,new_table_contents())[input$table_rows_selected,]%>%
                           mutate(across(c(lng,lat),as.numeric)),
                       group = 'previous'
                          #lng =  x$lng,lat=x$lat,
                          #layerId = paste('previous',1:nrow(x))
                       )
        })
    
    map_click_event <- observe({
        validate(need(input$map_click,message='select'))
        leaf%>%removeMarker(layerId = 'mark')
            leaf%>%
            addMarkers(lng = input$map_click$lng,
                       lat = input$map_click$lat,
                       layerId = 'mark')
            
        print(input$map_click)
        # leaf%>%leaflet::removeMarker()
        # leaf%>%addMarkers()
        
    })
    
    output$map_click_output <- renderText({
        validate(need(input$map_click,
             message = 'Click above to start'))
        paste('You have selected lat: ',round(input$map_click$lat,3),'
        lng: ',round(input$map_click$lng,3))
        })
    

    output$table <- renderDT(server = T,{
            df <- remote_data%>%
                      mutate(across(c('lat','lng'),as.numeric))%>%
                      mutate(action = paste0('<a class="go-map" href="" data-lat="', lat, '" data-lng="', lng, '" data-where="',row_number(),'">',icon('map-marker'),' jump to ',row_number(),'</a>', sep=""))%>%#
                                            #<a class="go-map" href="" data-lat="36.3"      data-lng="-94.57"    data-where="12"><i class="fa fa-car" role="presentation" aria-label="car icon"></i></a>
                                            #<a class="go-map" href="" data-lat="42.1"     data-long="-72.7">          <i class="fa fa-car" role="presentation" aria-label="car icon"></i></a>
                      mutate(action=ifelse(row_number()==1,NA,action))#%>%
              #mutate(icon='<i class="fa fa-crosshairs"></i>')
            
    action <- DT::dataTableAjax(session = session, data = df,rownames = FALSE)
    print(action)
    #print(df)
    
    # must have server is false for proxy to work
    DT::datatable(rownames = F,
                  selection = 'multiple', 
                  options = list(ajax = list(url = action)),
                  escape = F,#target='row',
                  data = df)
    }
)
    
    observeEvent(input$goto,{
         print('#--------')
         print(input$goto)
         print('#--------')

        x <- current_table_contents()[input$goto$where,]%>%
            mutate(across(c(lng,lat),as.numeric))
                             
      dist <- 2.5

      lat <- input$goto$lat
      lng <- input$goto$lng
      leaf %>% flyToBounds(lng - dist, lat - dist, lng + dist, lat + dist)

      leaf %>%
          clearPopups()%>%
          leaflet::clearGroup('previous')
      leaf%>%

          addPopups(data=x,
                    layerId = 'pop',
                    popup = lapply(htmltools::HTML,X =
                                 paste0('<strong>',x$who,'</strong>','</br>',x$when)))
      
      x <- rbind(remote_data,new_table_contents())[input$table_rows_selected,]
        print(x)
        x <- x%>%mutate(across(c(lng,lat),as.numeric))
        print(x)
        print(x$lng)
        leaf%>%
            addCircleMarkers(stroke = FALSE,
                             popup = lapply(htmltools::HTML,X = 
                                 paste0('<strong>',x$who,'</strong>','</br>',x$when)),
                             fill = TRUE,
                             fillColor = 'orange',fillOpacity = 0.7,
                             data=
                           rbind(remote_data,new_table_contents())[input$table_rows_selected,]%>%
                           mutate(across(c(lng,lat),as.numeric)),
                       group = 'previous'
                          #lng =  x$lng,lat=x$lat,
                          #layerId = paste('previous',1:nrow(x))
                       )

     })
    
    # '<a class="go-map" 
    # href="" data-lat="', 
    # Lat, '" data-long="', 
    # Long, '"><i class="fa fa-marker"></i></a>'
                      # data.frame(
                      # who='Select your name',
                      # lat='Latitude',lng='Longitude',when='Time stamp')
                  
        
    
    # DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
    
}

# Run the application 
shinyApp(ui = ui, server = server)
