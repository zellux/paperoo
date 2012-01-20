module ApplicationHelper
  def bootstrap_nav_li_for(name)
    if controller_name == name
      content_tag(:li, link_to(name.capitalize, "/#{name}"), :class => 'active')
    else
      content_tag(:li, link_to(name.capitalize, "/#{name}"))
    end
  end

  def conference_full_name(conference, length=0)
    if conference.nil?
      result = ''
    elsif conference.booktitle.nil?
      result = conference.title
    else
      result = "#{conference.title} (#{conference.booktitle})"
    end
    result = result.first(length - 3) + '...' if length > 0 and result.length > length
    result
  end

  def linkify_authors(authors)
    authors.map { |e| content_tag(:a, e.name, :href => author_path(e)) }.join(', ').html_safe
  end

  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
end
