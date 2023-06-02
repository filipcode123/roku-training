sub init()
    my_content_node = m.top.findNode("myContentNode")
    my_poster_grid = m.top.findNode("examplePosterGrid")
    my_poster_grid.content = my_content_node
    m.top.setFocus(true)
end sub