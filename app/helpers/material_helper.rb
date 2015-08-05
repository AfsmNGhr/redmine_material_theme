module Materialhelper
  def render_menu_with_material_and_icons(menu, project=nil)
    links = []
    menu_items_for(menu, project) do |node|
      links << render_menu_node_material_and_icons(node, project)
    end
    links.empty? ? nil : content_tag('ul', links.join("\n"),
                                     class: ['scrollable-menu', 'mdl-menu',
                                             'mdl-menu--bottom-left',
                                             'mdl-js-menu',
                                             'mdl-js-ripple-effect']).html_safe
  end

  def render_menu_node_material_and_icons(node, project=nil)
    if node.children.present? || !node.child_menus.nil?
      return render_menu_node_with_children(node, project)
    else
      caption, url, selected = extract_node_details(node, project)
      return content_tag('li',
                         render_single_menu_node(node, caption, url, selected),
                         class: 'mdl-menu__item')
    end
  end
end
