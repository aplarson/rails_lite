module URLHelper
  include CSRFProtector
  
  def url_helper(resource, param = nil)
    if param.nil?
      path = "/#{resource.to_s.downcase.pluralize}"
    else
      path = "/#{resource.to_s.downcase.pluralize}/#{param.id}"
    end
    path
  end
  
  def link_to(name, url)
    "<a href=\"#{url}\">#{name}</a>"
  end
  
  def button_to(name, url, method = :get)
    unless method = :get
      form_method = :post
    end
    <<-HTML
    <form action="#{url}" class="button_to" method="#{form_method}">
      <input type="hidden" name="_method" method="#{method}">
      <input type="submit" value="#{name}">
      <input type="hidden" 
             name="authenticity_token" 
             value="#{form_authenticity_token}">
    </form>
    HTML
  end
end