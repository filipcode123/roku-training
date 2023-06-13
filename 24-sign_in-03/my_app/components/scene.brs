sub init()
    m.global.addFields({successfulLogIn: false})
    m.button_group_1 = m.top.findNode("button_group_1")
    m.row_list = m.top.findNode("row_list_1")
    m.video = m.top.findNode("video_1")
    m.sign_in_buttons = m.top.findNode("sign_in_buttons")
    m.dialog_buttons = m.top.findNode("button_group")
    m.email_box = m.top.findNode("email_box")
    m.password_box = m.top.findNode("password_box")

    m.top.backgroundURI = ""
    setBackgroundColor("0x035C78ff")

    ' m.button_group_1.observeField("buttonFocused","onButtonGroupFocused")

    m.row_list.content = CreateObject("roSGNode","RowListData")
    m.row_list.observeField("itemSelected","onRowListSelected")
    m.row_list.observeField("itemFocused","onRowListFocused")

    m.dialog_buttons.observeField("buttonSelected","onDialogSelected")

    m.sign_in_buttons.observeField("buttonSelected","displaySignInDialog")
    m.sign_in_buttons.setFocus(True)
end sub

sub onDialogSelected()  
    focused_button = m.dialog_buttons.buttonFocused
    if focused_button = 0 then
        closeSignInDialog()
    else if focused_button = 1 then
        if validateInput() then
            closeSignInDialog()
            displayToast()
            setSuccessfulLogInField()
            print "successfulLogIn: "+m.global.successfulLogIn.toStr()
        end if
    end if
end sub

sub setSuccessfulLogInField()
    m.global.successfulLogIn = true
end sub

sub displayToast()
    m.top.findNode("sign_in_toast").visible = "true"
    m.test_timer = CreateObject("roSGNode","Timer")
    m.test_timer.repeat = "false"
    m.test_timer.duration = "3"
    m.test_timer.control = "start"
    m.test_timer.observeField("fire","hideToast")
    m.top.appendChild(m.test_timer)
end sub

sub hideToast()
    m.test_timer.control = "stop"
    m.top.findNode("sign_in_toast").visible = "false"
end sub

sub validateInput() as boolean
    print m.email_box.text
    print m.password_box.text
    return m.email_box.text = "test@test.com" and m.password_box.text = "123"
end sub

sub displaySignInDialog()
    sign_in_dialog = m.top.findNode("sign_in_pop_up_rectangle")
    sign_in_dialog.visible = "true"
    m.dialog_buttons.setFocus(True)
end sub

sub closeSignInDialog()
    m.top.findNode("sign_in_pop_up_rectangle").visible = "false"
    m.sign_in_buttons.setFocus(True)
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
        else if key = "down" and m.dialog_buttons.isInFocusChain() then
            m.email_box.setFocus(True)
            m.email_box.active = "true"
            m.password_box.active = "false"
            handled = true
        else if key = "down" and m.email_box.hasFocus() then
            m.password_box.setFocus(True)
            m.email_box.active = "false"
            m.password_box.active = "true"
            handled = true
        else if key = "up" and m.email_box.hasFocus() then
            m.dialog_buttons.setFocus(True)
            m.email_box.active = "false"
            handled = true
        else if key = "up" and m.password_box.hasFocus() then
            m.email_box.setFocus(True)
            m.email_box.active = "true"
            m.password_box.active = "false"
            handled = true
        else if key = "OK" and m.email_box.hasFocus() then
            createDialog("Enter email","email")
            handled = true
        else if key = "OK" and m.password_box.hasFocus() then
            createDialog("Enter password","password")
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

sub createDialog(title as String, keyboardDomain as String)
    m.dialog_box = createObject("roSGNode","StandardKeyboardDialog")
    m.dialog_box.title=title
    m.dialog_box.keyboardDomain = keyboardDomain
    m.dialog_box.buttons = ["ok"]
    m.top.dialog = m.dialog_box
    m.top.dialog.observeFieldScoped("buttonSelected","closeDialog")
end sub

sub closeDialog()
    print m.top.dialog.text
    if m.email_box.hasFocus() then
        m.email_box.text = m.top.dialog.text
    else if m.password_box.hasFocus() then
        m.password_box.text = m.top.dialog.text
    end if
    m.dialog_box.close = true
end sub

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

