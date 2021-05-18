sub init()
  m.top.observeField("setup", "setupSignInPage")
  m.signInButton = m.top.findNode("signInButton")
  m.emailField = m.top.findNode("signinEmail")
  m.passwordField = m.top.findNode("signinPassword")
  m.signInTips = m.top.findNode("signInTips")
  m.keyboardDialog = m.top.findNode("signinKeyboard")
  m.keyboardDialog.observeFieldScoped("buttonSelected", "dismissDialog")
  m.keyboardDialog.observeFieldScoped("text", "handleTextEdit")

  'm.doneButton = m.top.findNode("signinDoneButton")

  m.signInButton.observeField("buttonSelected","onSignInButtonSelected")

  ' initialize selectedObj to password'
  m.selectedObj = "password"
end sub

sub setupSignInPage(msg)
  ? "call setupSignInPage()"
  m.emailField.text = m.top.email
  if m.emailField.text = ""
      m.selectedObj = "email"
      m.signInTips.text = "Press OK to enter email, then press Down key"
      m.emailField.setFocus(true)
  else
      m.passwordField.setFocus(true)
  end if
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

sub setupEditPassword()
  m.keyboardDialog.keyboardDomain = "password"
  'm.top.textEditBox.voiceEntryType = "password"
  m.keyboardDialog.textEditBox.secureMode = true

  m.keyboardDialog.title = "Password entry"
  m.keyboardDialog.message = ["The password is 8 or more characters"]
  m.keyboardDialog.buttons = ["OK"]
  m.keyboardDialog.textEditBox.hintText = "Create or enter a password..."
  m.keyboardDialog.text = m.passwordField.text
end sub

sub handleTextEdit(msg)
  if m.selectedObj = "password"
      m.passwordField.text = m.keyboardDialog.text
  else if m.selectedObj = "email"
      m.emailField.text = m.keyboardDialog.text
  end if
end sub

sub dismissDialog()
  print "called dismissDialog"
  m.keyboardDialog.close=true
  'Revert focus'
  if m.selectedObj = "password"
      m.passwordField.setFocus(true)
  else if m.selectedObj = "email"
      m.emailField.setFocus(true)
  end if
  m.keyboardDialog.visible=false
end sub

function onSignInButtonSelected()
  ' return to main scene and check email/password'
  hashedPass = hashThePassword(m.passwordField.text)
  responseAA = {type:"signin", email:m.emailField.text, password:hashedPass}
  returnToMainScene(responseAA)
end function

sub returnToMainScene(ret)
  scene = m.top.getScene()
  scene.response = ret    ' responseAA'
  m.top.visible = false
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    handled = false
    ? "signinpage key= "; key; " press= "; press
    if press then
        if key = "back" then
            returnToMainScene("")
        else if key = "down"
          if m.selectedObj = "email"
            m.emailField.active=false
            m.passwordField.setFocus(true)
            m.passwordField.active=true
            m.selectedObj = "password"
            m.signInTips.text = "Press OK to enter password, then press Down key"
          else if m.selectedObj = "password"
            m.passwordField.active=false
            m.signInButton.setFocus(true)
            m.selectedObj = "button"
            m.signInTips.text = "Press OK to sign in"
          end if
          print "selectedObj= "; m.selectedObj
        else if key = "up"
          if m.selectedObj = "password"
            m.passwordField.active=false
            m.emailField.setFocus(true)
            m.emailField.active=true
            m.selectedObj = "email"
            m.signInTips.text = "Press OK to enter email, then press Down key"
          else if m.selectedObj = "button"
            m.passwordField.setFocus(true)
            m.passwordField.active=true
            m.selectedObj = "password"
            m.signInTips.text = "Press OK to enter password, then press Down key"
          end if
          print "selectedObj= "; m.selectedObj
        else if key = "OK"
          if m.selectedObj = "password"
            setupEditPassword()
          else if m.selectedObj = "email"
            setupEditEmail()
          end if
          m.keyboardDialog.visible=true
          m.keyboardDialog.setFocus(true)
          print "selectedObj= "; m.selectedObj
        end if
    end if
    return handled
end function
