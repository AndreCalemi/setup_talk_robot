*** Settings ***
Resource    ../resources/search_and_open.robot
Resource    ../resources/amazon_brasil_search_page.robot
Resource    ../resources/api's/alphavantage.robot


Suite Setup     Run Keywords
                ...     Open Browser on "www.google.com"
                ...     Search for "Amazon Brasil" and Search
                ...     Navigate to "www.amazon.com.br" Through The Search Page
                ...     Search For "${product_name}" Using The Search Bar

Suite Teardown  Close All Browsers


*** Variables ***


${product_name}     Iphone


*** Test Cases ***


15% Of Shown Products Should Be Exclusively The Searched Product (Starts With )

    ${start_with_list}       ${not_start_with_list}     Count products for each group, start with and doesn't start with "${product_name}”

	Make Sure At Least the given percentage of Items Found has its name starting with the product name     15    ${start_with_list}       ${not_start_with_list}


The Higher Price In The First Page Can't Be Greater Than EUR$2000

	${higher_price}      Find The More Expensive Item which its name "starts" with "${product_name}”

	${converted_value}   Convert Its Value   ${higher_price}    BRL   EUR

	Make Sure The Value Is Not Greater Than    ${converted_value}        2000


Products Different Than The Searched Product Should Be Cheaper Than The Searched Product

	${lower_price_start_with}           Find The Less Expensive Item which its name "starts" with "${product_name}”

	${higher_price_not_start_with}      Find The More Expensive Item which its name "doesn’t starts" with "${product_name}”

	Make Sure All Found Products Are Cheaper Than The Cheapest Item which its name starts with product name     ${lower_price_start_with}       ${higher_price_not_start_with}


*** Keywords ***


Make Sure At Least the given percentage of Items Found has its name starting with the product name
    [Arguments]         ${percentage}     ${start_with_list}       ${not_start_with_list}

    ${num_start_with}   Get Length    ${start_with_list}
    ${num_not_start_with}   Get Length    ${not_start_with_list}

    ${result}   Evaluate    ${num_start_with}*100/${num_not_start_with}

    Should Be True    ${result} >= ${percentage}


Make Sure The Value Is Not Greater Than
    [Arguments]         ${lower_value}      ${higher_value}

    Should Be True      ${higher_value} > ${lower_value}

Make Sure All Found Products Are Cheaper Than The Cheapest Item which its name starts with product name
    [Arguments]         ${lower_price_start_with}       ${higher_price_not_start_with}

    Should Be True      ${higher_price_not_start_with} < ${lower_price_start_with}