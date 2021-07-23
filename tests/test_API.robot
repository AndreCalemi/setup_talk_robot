*** Settings ***

Resource    ../resources/api's/reqres.robot


*** Variables ***


*** Test Cases ***
Scenario: name and last name should match given values
    [Template]  Validate name and last name for id

    # id    # name      # last name
    1       George      Bluth
    2       Janet       Weaver
    3       Emma        Wong
    4       Eve         Holt


*** Keywords ***
Validate name and last name for id
    [Arguments]     ${id_num}       ${name_from_input}    ${last_name_from_input}

    ${name_from_request}     ${last_name_from_request}    Get name and last name from reqres API for id "${id_num}"

    Should Be True    "${name_from_input}"=="${name_from_request}"
    Log     ${name_from_request}

    Should Be True    "${last_name_from_input}"=="${last_name_from_request}"
    Log     ${last_name_from_request}