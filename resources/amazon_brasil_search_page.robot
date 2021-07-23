*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    String


*** Variables ***


*** Keywords ***

Search For "${product}" Using The Search Bar
    Input Text    xpath://*[@name="field-keywords"]    ${product}
    Press Keys     None      ENTER
    Wait Until Element Is Visible    xpath://*[@data-component-type="s-search-result" and @data-index="59"]


Count The Total List Of Found Products
    [Documentation]     Returns a list of all products as a dictionary, each dictionary contains the product description and price

    # this element match all products searched, so counting it will return the total of products
    ${number_of_products}   Get Element Count    xpath://*[@data-component-type="s-search-result"]

    # for loop to get all products description and price and append to @{list_of_products} as a dictionary
    @{list_of_products}    Create List
    FOR    ${counter}    IN RANGE    ${number_of_products}
        # get the product description
        ${product_name}            Get Text    xpath://*[@data-component-type="s-search-result" and @data-index="${counter}"]//*[@class="a-size-base-plus a-color-base a-text-normal"]

        #check if page is showing the price, if yes save the price, else set the price as -1
        ${status}   Run Keyword And Return Status    Element Should Be Visible      xpath://*[@data-component-type="s-search-result" and @data-index="${counter}"]//*[@class="a-price-whole"]
        IF    ${status}
            # get the integer part of the price
            ${product_price_separator}       Get Text    xpath://*[@data-component-type="s-search-result" and @data-index="${counter}"]//*[@class="a-price-whole"]

            # the thousands separator for Brazilian money is the period, so remove it is required
            ${product_price_int}       Remove String   ${product_price_separator}   .

            # get the decimal part of the price
            ${product_price_decimal}   Get Text    xpath://*[@data-component-type="s-search-result" and @data-index="${counter}"]//*[@class="a-price-fraction"]

            # convert the final string to number
            ${product_price_double}    Convert To Number    ${product_price_int}.${product_price_decimal}

        ELSE
            ${product_price_double}    Set Variable    -1
        END

        # for each product create a dictionary containing description and price
        &{product_dic}     Create Dictionary   name=${product_name}   price=${product_price_double}

        # Append the dictionary containing description and price to the list_of_products
        Append To List      ${list_of_products}    ${product_dic}
    END
    [Return]    @{list_of_products}


Count products for each group, start with and doesn't start with "${product_name}”
    [Documentation]     using keyword "Count The Total List Of Found Products" to get all products list and split to two lists, starting with product name and not starting with the product name

    # get list with all products containing description and price for each element
    @{list_of_products}       Count The Total List Of Found Products

    # for each element check if description starts with the product name, if yes append to start_with_list, else append to not_start_with_list
    @{start_with_list}          Create List
    @{not_start_with_list}      Create List
    FOR    ${product}    IN    @{list_of_products}
        # check if description starts if product name
        ${start_with}   Run Keyword And Return Status       Should Start With  ${product["name"]}         ${product_name}           ignore_case=True
        IF    ${start_with}
            Append To List    ${start_with_list}    ${product}
        ELSE
            Append To List    ${not_start_with_list}    ${product}
        END
    END

    [Return]    ${start_with_list}      ${not_start_with_list}


Find The More Expensive Item which its name "${condition}" with "${product_name}”
    [Documentation]     Returns the more expensive product from the given group. The group is set according to \${condition}, if equal to starts use start_with_list, else use not_start_with_list

    # get all products splited into two lists, starting with and not starting with the product name
    ${start_with_list}       ${not_start_with_list}       Count products for each group, start with and doesn't start with "${product_name}”

    # populate the product_list according to condition
    @{product_list}      Create List
    IF          "${condition}" == "starts"
        ${product_list}     Copy List    ${start_with_list}
    ELSE
        ${product_list}     Copy List    ${not_start_with_list}
    END

    # from all prics get the higher
    ${higher_price}      Set Variable    0
    FOR    ${product}    IN    @{product_list}
        IF   ${product["price"]} > ${higher_price}
             ${higher_price}     Set Variable    ${product["price"]}
        END
    END

    [Return]    ${higher_price}


Find The Less Expensive Item which its name "${condition}" with "${product_name}”
    [Documentation]     Returns the less expensive product from the given group. The group is set according to \${condition}, if equal to starts use start_with_list, else use not_start_with_list

    # get all products splited into two lists, starting with and not starting with the product name
    ${start_with_list}       ${not_start_with_list}       Count products for each group, start with and doesn't start with "${product_name}”

    # populate the product_list according to condition
    @{product_list}      Create List
    IF          "${condition}" == "starts"
        ${product_list}     Copy List    ${start_with_list}
        Log List    ${product_list}
    ELSE
        ${product_list}     Copy List    ${not_start_with_list}
    END

    # from all prices get the lower
    ${lower_price}      Set Variable    10000000000000
    FOR    ${product}    IN    @{product_list}
        IF   ${product["price"]} < ${lower_price} and ${product["price"]} != -1
             ${lower_price}     Set Variable    ${product["price"]}
        END
    END

    [Return]    ${lower_price}