*** Variables ***
# cardMenu
${elementsCard}                 text=Elements
# elementCardMenu: TextBox
${textBoxMenu}                  text=Text Box
${textBox.fullnameInput}        id=userName
${textBox.emailInput}           id=userEmail
${textBox.currentAddress}       id=currentAddress
${textBox.permanentAddress}     id=permanentAddress
${submitButton}                 id=submit

# elementCardMenu: Buttons
${buttonsMenu}                  text=Buttons
${doubleClilckButton}           id=doubleClickBtn
${doubleClilckMessage}          id=doubleClickMessage

# Checkbox
${checkboxMenu}                 text=Check Box
${homeBox}                      xpath=//label[@for="tree-node-home"]//span[@class="rct-checkbox"]
${expandButton}                 css=#tree-node > div > button.rct-option.rct-option-expand-all
${checkboxElements}             xpath=(//span[@class="rct-checkbox"])
