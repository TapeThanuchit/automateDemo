*** Variables ***
${page}                         id=app
# cardMenu
${elementsCard}                 css:#app > div > div > div.home-body > div > div:nth-child(1)
${elementsCardText}             xpath=//*[text()="Elements"]
# elementCardMenu: TextBox
${textBoxMenu}                  xpath=//*[contains(text(), "Text Box")]
${textBox.fullnameInput}        id=userName
${textBox.emailInput}           id=userEmail
${textBox.currentAddress}       id=currentAddress
${textBox.permanentAddress}     id=permanentAddress
${submitButton}                 id=submit

# elementCardMenu: Buttons
${buttonsMenu}                  xpath=//*[contains(text(), "Buttons")]
${doubleClilckButton}           id=doubleClickBtn
${doubleClilckMessage}          id=doubleClickMessage
