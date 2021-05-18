Sub init()
    m.RowList = m.top.findNode("RowList")
    m.Title = m.top.findNode("Title")
    m.Description = m.top.findNode("Description")
    m.Overhang = m.top.findNode("Overhang")
    'm.Poster = m.top.findNode("Poster")
    m.RowList.setFocus(true)
    m.LoadTask = CreateObject("roSGNode", "FeedParser")  'Create XML parsing node task

    m.LoadTask.observeField("content", "rowListContentChanged")
    m.LoadTask.observeField("mediaIndex","indexloaded")
    m.LoadTask.control = "RUN"  'Run the task node

    m.RowList.observeField("rowItemFocused", "changeContent")

    m.Video = m.top.findNode("Video")
    m.Video.observeField("state", "onVideoStateChanged")
    'm.Video.observeField("position", "onVideoPositionChanged")
    m.VideoContent = createObject("roSGNode", "ContentNode")
    m.RowList.observeField("rowItemSelected", "playVideo")

    ' so we can use next video in playlist'
    m.Video.contentIsPlaylist = true
End Sub

sub indexloaded(msg as Object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "mediaIndex"
        m.mediaIndex = msg.getData()
        ? "m.mediaIndex= "; m.mediaIndex
    end if
    ' signal app launch completed beacon
    if m.global.version >= "910"
      m.top.setField("beacon", "AppLaunchComplete")
    end if
    ''? "after set beacon field"
    handleDeepLink(m.global.deeplink)
    'get run time deeplink updates'
    'm.global.observeField("deeplink", handleRuntimeDeepLink)
end sub

Function handleDeepLink(deeplink as object)
  if validateDeepLink(deeplink)
    playVideo(m.mediaIndex[deeplink.id].url)
  else
    print "deeplink not validated"
  end if
end Function

function validateDeepLink(deeplink as Object) as Boolean
  mediatypes={movie:"movie",episode:"episode",season:"season",series:"series"}
  if deeplink <> Invalid
      ? "mediaType = "; deeplink.mediaType
      ? "contentId = "; deeplink.id
      ? "content= "; m.mediaIndex[deeplink.id]
      if deeplink.mediaType <> invalid then
        if mediatypes[deeplink.mediaType]<> invalid
          if m.mediaIndex[deeplink.id] <> invalid
            if m.mediaIndex[deeplink.id].url <> invalid
              return true
            else
                print "invalid deep link url"
            end if
          else
            print "bad deep link contentId"
          end if
        else
          print "unknown media type"
        end if
      else
        print "deeplink.type string is invalid"
      end if
  end if
  return false
end function

Sub rowListContentChanged(msg as Object)
    if type(msg) = "roSGNodeEvent" and msg.getField() = "content"
        m.RowList.content = msg.getData()
    end if
end Sub

Sub changeContent()  'Changes info to be displayed on the overhang
    contentItem = m.RowList.content.getChild(m.RowList.rowItemFocused[0]).getChild(m.RowList.rowItemFocused[1])
    'contentItem is a variable that points to (rowItemFocused[0]) which is the row, and rowItemFocused[1] which is the item index in the row

    'm.top.getScene().backgroundUri = contentItem.HDPOSTERURL  'Sets Scene background to the image of the focused item
    'm.Poster.uri = contentItem.HDPOSTERURL  'Sets overhang image to the image of the focused item
    m.Title.text = contentItem.TITLE  'Sets overhang title to the title of the focused item
    m.Description.text = contentItem.DESCRIPTION  'Sets overhang description to the description of the focused item
    ''? "row= "; m.RowList.rowItemFocused[0]
    ''? "column= "; m.RowList.rowItemFocused[1]
End Sub

Sub playVideo(url = invalid)
    ? "url= "; url
    if type(url) = "roSGNodeEvent"   ' passed from observe callback'
        m.videoContent = m.RowList.content.getChild(m.RowList.rowItemFocused[0])
        'rowItemFocused[0] is the row and rowItemFocused[1] is the item index in the row
    else
        m.videoContent.url = url
    end if

    m.videoContent.streamFormat = "mp4"
    keepPlaying = false

    m.Video.content = m.videoContent

    m.Video.visible = "true"
    m.Video.control = "play"
    column = m.RowList.rowItemFocused[1]
    ' avoid double loading bar if it is first item'
    if column > 0
      m.video.nextContentIndex = column
      m.Video.control = "skipcontent"
    end if

    m.Video.setFocus(true)

    'm.vector2danimation = m.top.FindNode("moveOverhangPanelUp")
    'm.vector2danimation.repeat = false
    'm.vector2danimation.control = "start"
    m.Overhang.visible = false
End Sub

Function returnToUIPage()
    ? "m.Video.pauseBufferStart= "; m.Video.pauseBufferStart
    m.Video.visible = "false" 'Hide video
    m.Video.control = "stop"  'Stop video from playing
    m.RowList.setFocus(true)

    'm.vector2danimation = m.top.FindNode("moveOverhangPanelDown")
    'm.vector2danimation.repeat = false
    'm.vector2danimation.control = "start"
    m.Overhang.visible = true
end Function

Function onVideoStateChanged(msg as Object)
  if type(msg) = "roSGNodeEvent" and msg.getField() = "state"
      state = msg.getData()
      ? "onVideoStateChanged() state= "; state
      if state = "finished"
          returnToUIPage()
      end if
  end if
end Function

Function onVideoPositionChanged(msg as Object)
  if type(msg) = "roSGNodeEvent" and msg.getField() = "position"
      position = msg.getData()
      ''? "contentIndex = "; m.video.contentIndex
      ''? "nextcontentIndex= "; m.video.nextcontentindex
      ''? "onVideoPositionChanged() position= "; position
  end if
end Function

Function onKeyEvent(key as String, press as Boolean) as Boolean  'Maps back button to leave video
    if press
      print "pressed key="; key
        if key = "back"  'If the back button is pressed
            if m.Video.visible
                returnToUIPage()
                return true
            else
                return false
            end if
        end if
    end if
end Function
