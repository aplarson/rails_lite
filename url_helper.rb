module URLHelper
  def url_helper(resource, param = nil)
    if param.nil?
      path = "/#{resource.to_s.downcase.pluralize}"
    else
      path = "/#{resource.to_s.downcase.pluralize}/#{param.id}"
    end
    path
  end
end