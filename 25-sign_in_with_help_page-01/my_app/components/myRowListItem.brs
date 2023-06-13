sub init()
  m.poster_node = m.top.findNode("itemPoster") 
  m.label_node = m.top.findNode("itemLabel")
  end sub

sub showcontent()
  item_content = m.top.itemContent
  m.poster_node.uri = item_content.HDPosterUrl
  m.label_node.text = item_content.title
end sub
