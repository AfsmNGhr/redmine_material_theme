module RedmineMaterialTheme::Patches::MenuHelperPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def render_menu_with_material_and_icons(menu, project=nil)
      links = []
      menu_items_for(menu, project) do |node|
        links << render_menu_node_with_material_and_icons(node, project, menu)
      end
      return case menu
             when :account_menu
               links.empty? ? nil : content_tag('ul', links.join("\n").html_safe,
                                                for: 'user-menu',
                                                class: ['scrollable-menu',
                                                        'mdl-menu--bottom-left',
                                                        'mdl-js-menu', 'mdl-menu',
                                                        'mdl-js-ripple-effect'])
             when :top_menu
               links.empty? ? nil : content_tag(:ul, links.join("\n").html_safe,
                                                class: 'nav-scrollable-menu')
             when :project_menu, :application_menu, :domain_menu
               links.empty? ? nil : content_tag(:ul, links.join("\n").html_safe,
                                                class: ['mdl-tabs__tab-bar',
                                                        'mdl-tabs', 'mdl-js-tabs',
                                                        'mdl-js-ripple-effect'])
             else
               links.empty? ? nil : content_tag('ul', links.join("\n").html_safe)
             end
    end

    def render_menu_node_with_material_and_icons(node, project=nil, menu)
      if node.children.present? || !node.child_menus.nil?
        return render_menu_node_with_children(node, project)
      else
        caption, url, selected = extract_node_details(node, project)
        active = url_for(url).eql?(URI(request.url).path) ? 'is-active' : ''
        case menu
        when :account_menu
          case h(caption)
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
          else
            link_to h(caption), url, node.html_options(selected: selected)
          end

        when :top_menu
          case h(caption)
          when l(:label_project_plural)
            link_to (content_tag(:i, 'work', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-projects') +
                     (content_tag(:span, l(:label_project_plural).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-projects'))),
                    url, node.html_options(selected: selected)
          when l(:label_contact_plural)
            link_to (content_tag(:i, 'call', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-contacts') +
                     (content_tag(:span, l(:label_contact_plural).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-contacts'))),
                    url, node.html_options(selected: selected)
          when l(:label_domain_plural)
            link_to (content_tag(:i, 'domain', class: ['material-icons', 'nav-icons', "#{active}"], id: 'nav-domains') +
                     (content_tag(:span, l(:label_domain_plural).gsub("\n", "<br>"), class: 'mdl-tooltip', for: 'nav-domains'))),
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
          else
            link_to h(caption), url, node.html_options(selected: selected)
          end

        when :project_menu, :application_menu, :domain_menu
          case h(caption)
          when l(:label_browse), l(:label_calendar), l(:label_board_plural),
               l(:label_activity), l(:label_news), l(:label_file_plural),
               l(:label_issue_plural), l(:label_issue_new), l(:label_gantt),
               l(:label_settings), l(:label_wiki), l(:label_repository),
               l(:label_document_plural), l(:label_contact_plural),
               l(:label_domain_plural), l(:label_hosting_plural),
               l(:label_access_plural)
            link_to h(caption), url, node.html_options(selected: selected).
                                     merge(class: ['mdl-tabs__tab', "#{active}",
                                                   "#{node.html_options[:class]}"])
          else
            link_to h(caption), url, node.html_options(selected: selected)
          end
        end
      end
    end

    def render_main_menu_with_material_and_icons(project)
      if URI(request.url).path == '/domains'
        render_menu_with_material_and_icons(:domain_menu, project)
      else
        render_menu_with_material_and_icons((project && !project.new_record?) ? :project_menu : :application_menu, project)
      end
    end
  end
end

Redmine::MenuManager::MenuHelper.
  send :include, RedmineMaterialTheme::Patches::MenuHelperPatch
