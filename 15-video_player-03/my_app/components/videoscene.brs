sub init()
    m.top.backgroundColor = "0x314bdeff"
    m.top.backgroundURI = ""

    m.videocontent = createObject("RoSGNode", "ContentNode")
    m.videocontent.title = "Example Video"
    m.videocontent.streamformat = "mp4"
    m.video = m.top.findNode("exampleVideo")
    m.video.content = m.videocontent

    m.myButtonGroup = m.top.findNode("myButtonGroup")
    m.myButtonGroup.observeField("buttonSelected","onButtonGroupSelected")
    m.myButtonGroup.setFocus(true)
    device_info = CreateObject("roDeviceInfo")
    display_size = device_info.GetDisplaySize()
    m.video.translation = [(display_size.w-768)/2,(display_size.h-432)/2]
end sub

sub onButtonGroupSelected()
    channel = get_channel(m.myButtonGroup.buttonSelected)
    if channel <> invalid then
        print "'"+channel+"' selected."
        if channel = "Channel 1" then
            m.videocontent.url = "https://roku-webdev-opus.s3.amazonaws.com/public-videos/big+stream+trimmed.mp4"
        else if channel = "Channel 2" then
            m.videocontent.url = "http://video.ted.com/talks/podcast/DanGilbert_2004_480.mp4"
        end if
        m.video.control = "play"
    else
        print "invalid channel"
    end if
end sub

function get_channel(index as Integer) as Object
    if index = 0 then
        return "Channel 1"
    else if index = 1 then
        return "Channel 2"
    else
        return invalid
    end if
end function
