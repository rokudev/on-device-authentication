
' NOTE: this is not a Roku recommended way to hash a password'
'       it is just a demonstration of hashing in the sign up or sign in flow'
function hashThePassword(password) as String
  ba = CreateObject("roByteArray")
  passWithSalt = password + "THESALT"
  ba.FromAsciiString(passWithSalt)
  digest = CreateObject("roEVPDigest")
  digest.Setup("sha256")
  result = digest.Process(ba)
  return result
end function

