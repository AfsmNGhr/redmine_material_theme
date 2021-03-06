module RedmineMaterialTheme::Patches::MenuHelperPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :render_main_menu, :material_and_icons
      alias_method_chain :display_main_menu?, :domain_menu
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def render_menu_with_material_and_icons(menu, project = nil)
      links = []
      menu_items_for(menu, project) do |node|
        links << render_menu_node_with_material_and_icons(node, menu, project)
      end
      id, klass = style_for_list_menu(menu)
      links.empty? ? nil : content_tag('ul', links.join("\n").html_safe,
                                       for: id, class: klass)
    end

    def render_menu_node_with_material_and_icons(node, menu, project = nil)
      if node.children.present? || !node.child_menus.nil?
        return render_menu_node_with_children(node, project)
      else
        caption, url, selected = extract_node_details(node, project)
        active = menu_node_is_active(url)
        label, html_options =
               case menu
               when :account_menu
                 style_for_account_menu(node, caption, selected)
               when :top_menu
                 style_for_top_menu(node, caption, selected, active)
               when :project_menu, :application_menu, :domain_menu
                 style_for_tab_menu(node, caption, selected, active)
               else
                 [h(caption), node.html_options(selected: selected)]
               end
        link_to label, url, html_options
      end
    end

    def style_for_account_menu(node, caption, selected)
      label =
        case h(caption)
        when l(:label_my_account)
          'account_circle'
        when l(:label_logout)
          'exit_to_app'
        end
      [(content_tag(:i, label, class: 'material-icons account-icons') +
         h(caption)), node.html_options(selected: selected).
                      merge(class: ['mdl-menu__item',
                                    "#{node.html_options[:class]}"])]
    end

    def style_for_top_menu(node, caption, selected, active)
      label, id =
             case h(caption)
             when l(:label_project_plural)
               ['work', 'nav-projects']
             when l(:label_contact_plural)
               ['call', 'nav-contacts']
             when l(:label_domain_plural)
               ['domain', 'nav-domains']
             when l(:label_home)
               ['home', 'nav-home']
             when l(:label_my_page)
               ['assignment_ind', 'nav-my-page']
             when l(:label_administration)
               ['settings', 'nav-admin']
             when l(:label_help)
               ['help', 'nav-help']
             end
      [(content_tag(:i, label, class: ['material-icons', 'nav-icons', "#{active}"], id: id) +
        (content_tag(:span, h(caption).gsub("\n", '<br>'), class: 'mdl-tooltip', for: id))),
       node.html_options(selected: selected)]
    end

    def style_for_tab_menu(node, caption, selected, active)
      [h(caption), node.html_options(selected: selected).
                   merge(class: ['mdl-tabs__tab', "#{active}",
                                 "#{node.html_options[:class]}"])]
    end

    def style_for_list_menu(menu)
      case menu
      when :account_menu
        ['user-menu', ['scrollable-menu',
                       'mdl-menu--bottom-left',
                       'mdl-js-menu', 'mdl-menu',
                       'mdl-js-ripple-effect']]
      when :top_menu
        ['', 'nav-scrollable-menu']
      when :project_menu, :application_menu, :domain_menu
        ['', ['mdl-tabs__tab-bar',
              'mdl-tabs', 'mdl-js-tabs',
              'mdl-js-ripple-effect']]
      else
        ['', '']
      end
    end

    def display_main_menu_with_domain_menu?(project)
      Redmine::MenuManager.items(get_menu_name(project)).children.present?
    end

    def render_main_menu_with_material_and_icons(project)
      render_menu_with_material_and_icons(get_menu_name(project), project)
    end

    def menu_node_is_active(url)
      url_for(url).eql?(URI(request.url).path) ? 'is-active' : ''
    end

    private

    def get_menu_name(project)
      if project && !project.new_record?
        :project_menu
      else
        case URI(request.url).path
        when /domains/i
          :domain_menu
        else
          :application_menu
        end
      end
    end
  end
end

Redmine::MenuManager::MenuHelper.
  send :include, RedmineMaterialTheme::Patches::MenuHelperPatch
