*** Settings ***
Library           RequestsLibrary


*** Variables ***
${api_key}      5F7H9VGYXQJHASFS
${base_url}     https://www.alphavantage.co/query?


*** Keywords ***
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