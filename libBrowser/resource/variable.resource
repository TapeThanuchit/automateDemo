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
${outputFrom}                   id=output
${outputName}                   id=name
${outputEmail}                  id=email
${outputCurrentAddress}         xpath=//p[@id="currentAddress"]
${outputPermanentAddress}       xpath=//p[@id="permanentAddress"]

# elementCardMenu: Buttons
${buttonsMenu}                  text=Buttons
${doubleClilckButton}           id=doubleClickBtn
${doubleClilckMessage}          id=doubleClickMessage
${rightClickButton}             id=rightClickBtn
${rightClickMessage}            id=rightClickMessage
${defaultClickButton}           xpath=//*[text()="Click Me"]
${defaultClickMessage}          id=dynamicClickMessage

# Checkbox
${checkboxMenu}                 text=Check Box
${homeBox}                      xpath=//label[@for="tree-node-home"]//span[@class="rct-checkbox"]
${expandButton}                 css=#tree-node > div > button.rct-option.rct-option-expand-all
${collapseButton}               css=#tree-node > div > button.rct-option.rct-option-collapse-all
${checkboxElements}             xpath=(//span[@class="rct-checkbox"])

#Radio Button
${radioButtonsMenu}             text=Radio Button
${yesRadioButton}               text=Yes     #id=yesRadio
${impressiveRadioButon}         id=impressiveRadio
${noRadioButton}                id=noRadio
${messageRetuenRadioCheck}      xpath=//p[@class="mt-3"]

#Web Tables
${webTablesMenu}                text=Web Tables
${addNewRecordButton}           id=addNewRecordButton
${firstnameInput}               id=firstName
${lastnameInput}                id=lastName
${emailIput}                    id=userEmail
${ageInput}                     id=age
${salaryInput}                  id=salary
${departmentInput}              id=department
${rowsData}                     xpath=(//div[@class="rt-tr-group"])
