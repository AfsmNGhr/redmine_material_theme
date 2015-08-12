require 'redmine'
require 'redmine_material_theme/hooks/view_layouts_base_html_head_hook'
require 'redmine_material_theme/patches/menu_helper_patch'

Redmine::Plugin.register :redmine_material_theme do
  name 'Redmine material theme'
  author 'Ermolaev Alexsey'
  description 'Deface with material theme'
  author_url 'mailto:afay.zangetsu@gmail.com'
  version '0.1'
  requires_redmine version_or_higher: '3.0.0'
  requires_redmine_plugin :redmine_base_deface, version_or_higher: '0.0.1'
end
