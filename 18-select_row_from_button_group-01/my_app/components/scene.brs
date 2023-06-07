sub init()
    m.button_group_1 = m.top.findNode("button_group_1")
    
    m.row_list = m.top.findNode("row_list_1")
    m.row_list.content = CreateObject("roSGNode","RowListData")

    ' m.button_group_1.observeField("buttonSelected","onButtonGroupSelected")
    m.button_group_1.setFocus(True)
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
    if press = true then
        if key = "right" and m.button_group_1.isInFocusChain() then
            m.row_list.jumpToItem = m.button_group_1.buttonFocused
            m.row_list.setFocus(True)
        end if
    end if
end function