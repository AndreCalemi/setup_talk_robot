*** Settings ***
Library           RequestsLibrary
Library    SeleniumLibrary


*** Variables ***


*** Keywords ***

Get name and last name from reqres API for id "${id_num}"

    ${URL}          Set Variable    https://reqres.in/api/users?page=1
    ${response}     GET             ${URL}
    
    ${id_num}       Evaluate    ${id_num} - 1
    
    ${name}         Set Variable    ${response.json()["data"][${id_num}]["first_name"]}
    ${last_name}    Set Variable    ${response.json()["data"][${id_num}]["last_name"]}

    [Return]    ${name}     ${last_name}

Get rate
    [Documentation]  Returns the rate between from_currency and to_currency
    [Arguments]     ${from_currency}   ${to_currency}

    ${URL}          Set Variable    ${base_url}function=CURRENCY_EXCHANGE_RATE&from_currency=${from_currency}&to_currency=${to_currency}&apikey=${api_key}
    ${response}     GET    ${URL}

    [Return]        ${response.json()}

Convert Its Value
    [Documentation]  Returns converted_value FROM from_currency TO to_currency
    [Arguments]     ${value}    ${from_currency}   ${to_currency}

    ${response}   Get rate    ${from_currency}   ${to_currency}

    ${converted_value}  Evaluate    ${response['Realtime Currency Exchange Rate']['5. Exchange Rate']}*${value}

    [Return]    ${converted_value}