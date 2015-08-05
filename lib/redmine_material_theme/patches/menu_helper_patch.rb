module RedmineMaterialTheme::Patches::MenuHelperPatch
  def self.included(base)
    unloadable
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def render_menu_with_material_and_icons(menu, project=nil)
      links = []
      menu_items_for(menu, project) do |node|
        links << render_menu_node_with_material_and_icons(node, project)
      end
      return case menu
             when :account_menu
               links.empty? ? nil : content_tag('ul', links.join("\n").html_safe,
                                                for: 'user-menu',
                                                class: ['scrollable-menu', 'mdl-menu',
                                                        'mdl-menu--bottom-left',
                                                        'mdl-js-menu',
                                                        'mdl-js-ripple-effect'])
             when :top_menu
               links.empty? ? nil : content_tag(:ul, links.join("\n").html_safe,
                                                class: 'nav-scrollable-menu')
             when :project_menu, :application_menu
               links.empty? ? nil : content_tag(:ul, links.join("\n").html_safe,
                                                      class: ['main-scrollable-menu',
                                                              'mdl-tabs__tab-bar',
                                                              'mdl-tabs', 'mdl-js-tabs',
                                                              'mdl-js-ripple-effect'])
             else
               links.empty? ? nil : content_tag('ul', links.join("\n").html_safe)
             end
    end

    def render_menu_node_with_material_and_icons(node, project=nil)
      if node.children.present? || !node.child_menus.nil?
        return render_menu_node_with_children(node, project)
      else
        caption, url, selected = extract_node_details(node, project)
        active = url_for(url).eql?(URI(request.url).path) ? 'is-active' : ''
        return case h(caption)

               # => :account_menu
               when l(:label_my_account)
                 link_to (content_tag(:i, 'account_circle', class: 'material-icons account-icons') +
                          h(caption)), url, node.html_options(selected: selected).
                                            merge(class: ['mdl-menu__item',
                                                          "#{node.html_options[:class]}"])
               when l(:label_logout)
                 link_to (content_tag(:i, 'exit_to_app', class: 'material-icons account-icons') +
                          h(caption)), url, node.html_options(selected: selected).
                                            merge(class: ['mdl-menu__item',
                                                  "#{node.html_options[:class]}"])

               # => :top_menu
               when l(:label_project_plural)
                 link_to (content_tag(:i, 'work', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-projects') +
                          (content_tag(:span, l(:label_project_plural).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-projects'))),
                         url, node.html_options(selected: selected)
               when l(:label_home)
                 link_to (content_tag(:i, 'home', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-home') +
                          (content_tag(:span, l(:label_home).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-home'))),
                         url, node.html_options(selected: selected)
               when l(:label_my_page)
                 link_to (content_tag(:i, 'assignment_ind', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-my-page') +
                          (content_tag(:span, l(:label_my_page).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-my-page'))),
                         url, node.html_options(selected: selected)
               when l(:label_administration)
                 link_to (content_tag(:i, 'settings', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-admin') +
                          (content_tag(:span, l(:label_administration).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-admin'))),
                         url, node.html_options(selected: selected)
               when l(:label_help)
                 link_to (content_tag(:i, 'help', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-help') +
                          (content_tag(:span, l(:label_help).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-help'))),
                         url, node.html_options(selected: selected)

               # => :project_menu, : application_menu
               when l(:label_browse), l(:label_calendar), l(:label_forum),
                    l(:label_activity), l(:label_news), l(:label_file_plural),
                    l(:label_issue_plural), l(:label_issue_new), l(:label_gantt),
                    l(:label_settings), l(:label_wiki), l(:label_repository),
                    l(:label_settings), l(:label_document_plural)
                 link_to h(caption), url, node.html_options(selected: selected).
                                          merge(class: ['mdl-tabs__tab', "#{active}",
                                                        "#{node.html_options[:class]}"])
               else
                 link_to h(caption), url, node.html_options(selected: selected)
               end
      end
    end

    def render_main_menu_with_material_and_icons(project)
      render_menu_with_material_and_icons((project && !project.new_record?) ? :project_menu : :application_menu, project)
    end
  end
end
