'******registry_task*******'
function init()
  Registry = CreateObject("roRegistry")
  ' RegSec = createObject("roRegistrySection")
  m.port = createobject("roMessagePort")
  m.top.observefield("request", m.port)
  m.top.functionName = "mainThread"
end function

function mainThread()
    while true
        msg = wait(0, m.port)
        mt = type(msg)
        regInput(msg.getData())
    end while
end function

function regInput(context as Object)
    context = m.top.request.context
    parameters = context.parameters
    command = parameters.command
    if command = "read"
        ? "< Reading key: " parameters.key " in " parameters.section
        context.response = {"regVal" : RegRead(parameters.key, parameters.section) }
    else if command = "write"
        ? "< Writing (" parameters.key " , " parameters.value ") in " parameters.section
        RegWrite(parameters.key, parameters.value, parameters.section)
    else if command = "delete"
        RegDelete(parameters.key, parameters.section)
    else if command = "deleteRegistry"
        ? "< Deleting the entire sample registry section"
        deleteRegistry()
    end if
end function

'******************************************************
'Registry Helper Functions
'******************************************************
Function RegRead(key as String, section as String) as String
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    if sec.Exists(key) then
        ? "< Key read is " sec.read(key)
        return sec.Read(key)
    end if
    return "invalid"
End Function

Function RegWrite(key as String, val as String, section as String) as void
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Write(key, val)
    if sec.Flush() then
        ? "< Write success!"
        ? sec.getKeyList()
    else
        ? "< Write failed!"
    end if

End Function

Function RegDelete(key as String, section=invalid) as Void
    if section = invalid then section = "Default"
    sec = CreateObject("roRegistrySection", section)
    sec.Delete(key)
    sec.Flush() ' commit it
End Function

' use with care
sub deleteRegistry()
  ? "Exisiting sections ..."

  reg = CreateObject("roRegistry")
  sections = reg.GetSectionList()
  exist = false
  for each section in sections
      ? "      detected section " + section
      if section = "sample" then exist = true
  next
  if exist
      reg.Delete("sample")
      reg.Flush()
      ? ""
      ? "!-------------------d e l e t e-------------------!"
      ? ""
      ? "Checking sections ... "
      sections = reg.GetSectionList()
      for each section in sections
          ? "      detected section " + section
      next
      ? "Confirmed delete"
  else
      ? "Sample section doesn't exist yet, not deleting anything"
  end if
  ? ""
end sub
