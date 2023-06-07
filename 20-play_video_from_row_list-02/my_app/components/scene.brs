sub init()
    m.button_group_1 = m.top.findNode("button_group_1")
    
    m.row_list = m.top.findNode("row_list_1")
    m.row_list.content = CreateObject("roSGNode","RowListData")
    m.row_list.observeField("itemSelected","onRowListSelected")
    ' m.button_group_1.observeField("buttonSelected","onButtonGroupSelected")
    m.button_group_1.setFocus(True)
    m.video = m.top.FindNode("video_1")
    
end sub

sub onRowListSelected()
    rowItemSelected = m.row_list.rowItemSelected
    print rowItemSelected
    playVideo(rowItemSelected,"")
end sub

sub playVideo(video_index,video_title)
    video_content = CreateObject("ROSGNode", "ContentNode")
    video_content.title = video_title
    video_content.streamformat = "mp4"
    video_content.url = "http://video.ted.com/talks/podcast/DanGilbert_2004_480.mp4"
    m.video.content = video_content
    m.video.visible = "true"
    m.video.control = "play"
    m.video.setFocus(true)
end sub

sub onButtonGroupSelected()
    button = m.button_group_1.buttonSelected
    if button <> invalid then
        if button = 0 then
            print "button 1"
        else if button = 1 then
            print "button 2"
        else if button = 2 then
            print "button 3"
        end if
    else
        print "invalid button"
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean  
    handled = false
    if press = true then
        if key = "right" and m.button_group_1.isInFocusChain() then
            m.row_list.jumpToItem = m.button_group_1.buttonFocused
            setCurrentChannelName(m.button_group_1.buttonFocused)
            m.row_list.setFocus(True)
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