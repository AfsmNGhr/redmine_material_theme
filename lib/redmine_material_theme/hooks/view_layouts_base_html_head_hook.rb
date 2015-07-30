module RedmineMaterialTheme
  module Hooks
    class MaterialHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(context)
        stylesheet_link_tag('material', plugin: 'redmine_material_theme') +
          javascript_include_tag('material.min', plugin: 'redmine_material_theme')
      end
    end
  end
end
