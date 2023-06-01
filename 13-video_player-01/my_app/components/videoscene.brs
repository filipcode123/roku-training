sub init()
    videocontent = createObject("RoSGNode", "ContentNode")
    videocontent.title = "Example Video"
    videocontent.streamformat = "mp4"
    videocontent.url = "https://roku-webdev-opus.s3.amazonaws.com/public-videos/big+stream+trimmed.mp4"
    m.video = m.top.findNode("exampleVideo")
    m.video.content = videocontent
    m.myButtonGroup = m.top.findNode("myButtonGroup")
    m.myButtonGroup.setFocus(true)
end sub


function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if key = "play" and m.myButtonGroup.isInFocusChain()
            m.video.control = "play"
            m.video.setFocus(true)
        end if
    end if

end function