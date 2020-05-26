*** Settings ***
Resource            ../resources/keywords.robot
Suite Setup          Setup Browser
Suite Teardown       End suite
Test Teardown        CheckCart



*** Test Cases ***

DSS: Place order, new user
    [tags]          newuser
	Appstate       	Login
	HoverText       COMPUTERS
    ClickText       Microsoft
    HoverText       Microsoft Surface Book 2
    ClickText       Add to Cart
    VerifyText      Qty: 1
    ClickItem       head-search
    TypeText        Enter keywords to search...   tablet
    ClickText       Microsoft Surface Pro (201807195)
    VerifyText      SKU: 201807195
    ClickItem       plus
    ClickText       Add to Cart
    VerifyText      Qty: 2
    ClickText       VIEW AND EDIT CART
    VerifyTexts     $5,097.00, $ 3.02, $288.69, $5,100.0
    TypeText        Part #              201807196
    VerifyText      Microsoft Surface Pen
    ClickItem       plus
    ClickItem       Add to Cart
    VerifyTexts     Product ID: 201807201, Product ID: 201807195, Product ID: 201807196
    VerifyTexts     $2,499.00, $2,598.00, $ 199.98
    VerifyTexts     $5,296.98, $ 3.02, $300.01, $5,300.00
    ClickText       Proceed To Checkout
    VerifyText      Express Checkout

    Log             Checkout:

    ClickText       Invoice
    TypeText        E-mail                  robot@qentinel.com
    Dropdown        Country                 Finland
    # For attributes in labels between
    # "Company Name and City" are all connected to email -input
    # instead of their own
    TypeText        shipping_CompanyName    Qentinel    delay=2
    TypeText        shipping_FirstName      QRobot
    TypeText        shipping_LastName       Qentinel
    TypeText        shipping_Address1       Bertel Jungin aukio 7
    TypeText        shipping_City           Espoo
    TypeText        ZIP/Postal Code         02600
    # Note! Scandic letters are visually "broken":
    Dropdown        State/Province          Etelä-Suomen lääni
    # Note! Phone label for is connected to Email -input instead on Phone
    TypeText        shipping_PhoneHome      +358401234567       delay=2
    ClickText       My billing and shipping are the same
    ClickCheckbox   Terms and Conditions    on
    ClickText       Place Order Now
    VerifyText      Thank you for your Order!
    # Pick ordernro just in case. Verify Invoice Address and Order Summary
    ${ORDER}        GetText                 order-document-number  tag=strong
    VerifyTexts     Qentinel, QRobot Qentinel, Bertel Jungin aukio 7
    VerifyTexts     Espoo 02600, Finland, +358401234567, robot@qentinel.com
    VerifyTexts     $5,296.98, $ 51.44, $302.74, $5,348.42

DSS: Place order, existing user
    [tags]          existinguser
    Appstate        MainPage
    ClickText       Login
    TypeText        email                   bboldner@test.intershop.de
    TypeSecret      password                ${USER_PASS}
    ClickText       SIGN IN
    VerifyText      Hi, Bernhard Boldner (Bio Tech)

    Log             Place order via order templates:

    ClickText       Order Templates
    ClickItem       Add to Order             2
    VerifyTexts     Product ID: 5981602, Product ID: 2006125, Product ID: 1791958
    VerifyTexts     106.30, 80.26, 142.78
    VerifyTexts     329.34, 5.20, 63.55, 398.09
    HoverText       QUICK ORDER
    TypeText        Part #                  123
    ClickText       107267
    TypeText        Part #                  345     index=2
    ClickText       3458754
    TypeText        Part #                  111     index=3
    ClickText       11103587
    ClickText       Add to Cart
    VerifyTexts     106.30, 80.26, 142.78, 71.01, 82.35, 37.61
    VerifyTexts     520.31, 5.21, 99.82, 625.34
    ClickText       Apply Discount Code
    TypeText        Enter discount code     DIASPromo1
    ClickText       APPLY DISCOUNT
    VerifyText      Your Promotion Discount has been applied
    VerifyText      DIAS $10 Off
    VerifyTexts     520.31, -8.40, 5.21, 98.22, 615.34
    ClickText       Proceed To Checkout     delay=1
    VerifyText      Express checkout

    Log             Checkout:

    ClickItem       checkout-quantity-up-arrow cart-add-btn-4 quantity-right-plus fa-1x
    VerifyText      142.02
    # Note! Changed to dropdown 18052020
    # ClickText       Select A Different Address
    # ClickText       Al Goro, Main Street 12, Heidelberg
    DropDown        ShippingAddressID    Al Goro, Main Street 12, Heidelberg
    VerifyTexts     Bio Tech, Al Goro, Main Street 12, 53268 Heidelberg, Germany
    ClickText       ISH Demo Credit Card
    TypeText        Card Number             ${CREDIT_CARD}   check=false     clear_key={NULL}
    DropDown        Card Type               Visa
    TypeText        Expiration Date         12/25
    ClickCheckBox   Save this information   off
    ClickCheckBox   Terms and Conditions    on
    ClickText       Place Order Now
    VerifyTexts     Total Order Value, $ 699.84, inTRONICS B2B Demo, VISA xxxxxxxxxxxx1111
    ClickText       Continue
    VerifyTexts     Bio Tech, Bernhard Boldner, bboldner@test.intershop.de, Taxation ID: MST MXA 90L01
    VerifyTexts     Bio Tech, Al Goro, Main Street 12, 53268 Heidelberg, Germany
    VerifyTexts     591.32, -8.40, 5.19, 111.73, 699.84
    ClickText       Logout
