module CSRFProtector
  def form_authenticity_token
    session['csrf_token']
  end
  
  def authentic_form?
    session['csrf_token'] == params['authenticity_token']
  end
end