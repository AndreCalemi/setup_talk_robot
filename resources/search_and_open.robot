*** Settings ***
Library    SeleniumLibrary


*** Variables ***
${browser}          Chrome


*** Keywords ***
Open Browser on "www.google.com"
    Open Browser    https://www.google.com/en      ${browser}


Search for "${value}" and Search
    Input Text    xpath://*[@title="Search"]    ${value}
    Press Keys     None      ENTER


Navigate to "${page}" Through The Search Page
    Click Element    //*/cite[contains(. , ${page})]