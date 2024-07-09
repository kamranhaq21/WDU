*** Settings ***
Library  Autosphere.Browser
Library  Autosphere.HTTP
Library  Autosphere.Excel.Files
Library  Autosphere.PDF
Library  Autosphere.FileSystem

#*** Keywords ***
#Download The Excel file
#    Download    http://training.autosphere.ai/SalesData.xlsx      overwrite=True

*** Keywords ***
Open The Internet Website
    Open Available Browser     http://training.autosphere.ai/#/
    

*** Keywords ***
Log In
    Input Text    id=username  developer
    Input password   id=password  autosphere
    Submit Form
        Wait until page contains element  id=firstname

*** Keywords ***
Read from Excel file and fill the form for all users
        Open Workbook   SalesData.xlsx
        ${salesReps}=   Read Worksheet As Table   header=True
        Close Workbook
        FOR  ${salesRep}    IN    @{salesReps}
            Fill and Submit the form for a user  ${salesRep}
            
            END

*** Keywords ***
Fill and Submit the form for a user
    [Arguments]   ${salesRep}
    Input Text  firstname  ${salesRep}[First Name]
    Input Text  lastname  ${salesRep}[Last Name]
    Input Text  salesresult  ${salesRep}[Sales]
    ${target_as_string}=  Convert to string  ${salesRep}[Sales Target]
    Select From List By Value  salestarget   ${target_as_string}
    Click Button   Submit
    

*** Keywords ***
Taking screenshot of the results
    Capture element screenshot  css:div.sales-summary     C:/Users/LENOVO T480/Documents/workspace/Autosphere_Demo/Weekly_Data_Update/test.png

*** Keywords ***
Export the table as HTML
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute  id:sales-results   outerHTML
    Create File    ./Results/sales_results.template    ${sales_results_html}    overwrite=True

*** Keywords ***
Convert HTML to PDF
  Template Html To Pdf    ./Results/sales_results.template    ./Results/sales_results.pdf

*** Keywords ***
Log Out And Close The Browser
    Click Button    Log out
    Close Browser

*** Tasks ***

#Downloading the Source file
#    Download The Excel file
Inserting the sales data for the week
    Open The Internet Website
    log In
    Read from Excel file and fill the form for all users  
Collecting the results
    Taking screenshot of the results
Creating PDF of the results
    Export the table as HTML
    Convert HTML to PDF

    [Teardown]  Log Out And Close The Browser

    
    






