*** Settings ***
Library             QWeb
Library             String


*** Variables ***
${BROWSER}          chrome
#Poista ja anna Pacesta!



*** Keywords ***
Setup Browser
    Open Browser    about:blank    ${BROWSER}
    SetConfig       CheckInputValue     True
    SetConfig       DefaultTimeout      20
    SetConfig       LineBreak           None
    SetConfig       SearchMode          draw
    
	
End suite
    Close All Browsers
    Sleep    2

Appstate
	[Documentation]   Appstate handler
	[Arguments]       ${state}
	${state}          Convert To Lowercase    ${state}
	Run Keyword If    '${state}' == 'login'
	...               Login
	Run Keyword If    '${state}' == 'mainpage'
	...               MainPage

Login
	GoTo            https://dssdemo710152b2x.intershopsandbox.com/INTERSHOP/web/WFS/inSPIRED-inTRONICS_B2B_Demo-Site/en_US/-/USD/ViewHomepage-Start
    VerifyText      Username
    # Note! Possible bug in html. For attribute in text label
    # "Username or Email Address" points to submit button instead of email
    TypeSecret      email           ${USER}
	TypeSecret      Password        ${PASS}
	ClickText      	Log In
	VerifyText     	Featured Categories

MainPage
    run keyword and ignore error   ClickItem   Logo   timeout=1     delay=1
    ${STATUS}       RunKeywordAndReturnStatus
    ...             VerifyText     	Featured Categories     timeout=15
    RunKeywordIf    '${STATUS}' == 'False'
    ...             Login

CheckCart
    ClickItem       minicart-link
    ${STATUS}       RunKeywordAndReturnStatus
    ...             VerifyText     	Your cart is currently empty     timeout=2
    RunKeywordIf    '${STATUS}' == 'False'
    ...             RemoveItems
    run keyword and ignore error   ClickText  CLOSE

RemoveItems
    ClickText       VIEW AND EDIT CART
    SkimClick       X               interval=5      timeout=45