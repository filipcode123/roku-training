sub init()
    m.button_group_1 = m.top.findNode("button_group_1")
    m.row_list = m.top.findNode("row_list_1")
    m.video = m.top.FindNode("video_1")

    m.top.backgroundURI = ""
    setBackgroundColor("0x035C78ff")

    ' m.button_group_1.observeField("buttonFocused","onButtonGroupFocused")

    m.row_list.content = CreateObject("roSGNode","RowListData")
    m.row_list.observeField("itemSelected","onRowListSelected")
    m.row_list.observeField("itemFocused","onRowListFocused")
    
    m.button_group_1.setFocus(True)
end sub

sub setBackgroundColor(colour as String)
    m.top.backgroundColor = colour
end sub

sub onRowListSelected()
    rowItemSelected = m.row_list.rowItemSelected
    rowListContent = m.row_list.content
    selectedRow = rowListContent.getChild(rowItemSelected.getEntry(0))
    selectedItem = selectedRow.getChild(rowItemSelected.getEntry(1))
    video_title = selectedItem.TITLE
    playVideo(video_title)
end sub

sub playVideo(video_title)
    video_content = CreateObject("ROSGNode", "ContentNode")
    video_content.title = video_title
    video_content.streamformat = "mp4"
    video_content.url = "http://video.ted.com/talks/podcast/DanGilbert_2004_480.mp4"
    m.video.content = video_content
    m.video.visible = "true"
    m.video.control = "play"
    m.video.setFocus(true)
end sub

sub onRowListFocused()
    rowListFocusedItem = m.row_list.itemFocused
    if rowListFocusedItem <> invalid then
        setCurrentChannelName(rowListFocusedItem)
    else
        print "invalid row list item selected"
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean  
    handled = false
    if press = true then
        if key = "right" and m.button_group_1.isInFocusChain() then
            m.row_list.jumpToItem = m.button_group_1.buttonFocused
            m.row_list.setFocus(True)
            onRowListFocused()
            handled = true
        else if key = "left" and m.row_list.rowItemFocused.GetEntry(1) = 0 then
            m.button_group_1.setFocus(True)
            handled = true
        else if key = "back" and m.video.hasFocus() then
            print "start"
            m.video.control = "stop"
            m.video.visible = "false"
            m.row_list.setFocus(True)
            print "end"
            handled = true
        end if
    end if
    return handled
end function

sub setCurrentChannelName(index as Integer)
    channel_label = m.top.findNode("channel_label")
    channel_label.text = indexToChannelName(index)
end sub

function indexToChannelName(index as Integer) as String
    if index = 0 then
        return "Channel 1"
    else if index = 1 then
        return "Channel 2"
    else if index = 2 then
        return "Channel 3"
    else
        print "No Channel name exists for the given index '"+index.toStr()+"'"
        return ""
    end if
end function

' sub onButtonGroupFocused()
'     button = m.button_group_1.buttonFocused
'     if button <> invalid then
'         if button = 0 then
'             print "button 1"
'         else if button = 1 then
'             print "button 2"
'         else if button = 2 then
'             print "button 3"
'         end if
'         m.row_list.jumpToItem = m.button_group_1.buttonFocused
'         setCurrentChannelName(m.button_group_1.buttonFocused)
'     else
'         print "invalid button"
'     end if
' end sub