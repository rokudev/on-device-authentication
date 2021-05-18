sub init()
  m.top.observeField("setup", "setupSignUpPage")
  m.signUpButton = m.top.findNode("signUpButton")
  m.emailField = m.top.findNode("signupEmail")
  m.keyboardDialog = m.top.findNode("signupKeyboard")
  m.keyboardDialog.observeFieldScoped("buttonSelected", "dismissDialog")
  m.keyboardDialog.observeFieldScoped("text", "handleTextEdit")

  m.signUpButton.observeField("buttonSelected","onSignUpButtonSelected")

  ' initialize selectedObj to email'
  m.selectedObj = "email"
end sub

sub setupSignUpPage(msg)
  ? "call setupSignUpPage()"
  m.emailField.text = m.top.email
  m.selectedObj = "email"
  m.emailField.setFocus(true)
end sub

sub setUpEditEmail()
  m.keyboardDialog.textEditBox.secureMode = false
  m.keyboardDialog.keyboardDomain = "email"
  m.keyboardDialog.title = "Email entry"
  m.keyboardDialog.message = ["It is easier to share email using RFI"]
  m.keyboardDialog.buttons = ["OK"]
  m.keyboardDialog.textEditBox.hintText = "Enter a valid email address..."
  m.keyboardDialog.text = m.emailField.text
end sub

sub handleTextEdit(msg)
  m.emailField.text = m.keyboardDialog.text
end sub

sub dismissDialog()
  print "called dismissDialog"
  m.keyboardDialog.close=true
  'Revert focus'
  m.emailField.setFocus(true)
  m.keyboardDialog.visible=false
end sub

function onSignUpButtonSelected()
  ' return to main scene and check email/password'
  hashedPass = hashThePassword("<ASSIGNED_PASSWORD>")
  responseAA = {type:"signup", email:m.emailField.text, password:hashedPass}
  returnToMainScene(responseAA)
end function

sub returnToMainScene(ret)
  scene = m.top.getScene()
  scene.response = ret    ' responseAA'
  m.top.visible = false
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    ? "signuppage key= "; key; " press= "; press
    if press then
        if key = "back" then
            returnToMainScene("")
        else if key = "down"
          if m.selectedObj = "email"
            m.emailField.active=false
            m.signUpButton.setFocus(true)
            m.selectedObj = "button"
          end if
          print "selectedObj= "; m.selectedObj
        else if key = "up"
          if m.selectedObj = "button"
            m.emailField.active=true
            m.emailField.setFocus(true)
            m.selectedObj = "email"
          end if
          print "selectedObj= "; m.selectedObj
        else if key = "OK"
          if m.selectedObj = "email"
            setupEditEmail()
          end if
          m.keyboardDialog.visible=true
          m.keyboardDialog.setFocus(true)
          print "selectedObj= "; m.selectedObj
        end if
    end if
    return handled
end function
