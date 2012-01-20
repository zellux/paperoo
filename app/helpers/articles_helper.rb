module ArticlesHelper
  def option_for_conference(c, selected=nil)
    options = { :value => c.id }
    options[:selected] = 1 if selected and c.id == selected.id
    content_tag(:option, conference_full_name(c, 100), options)
  end
end
