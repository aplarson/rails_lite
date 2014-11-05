module CSRFProtector
  def form_authenticity_token
    token = SecureRandom.urlsafe_base64
    session['csrf_token'] = token
    token
  end
  
  def authentic_form?
    session['csrf_token'] == params['authenticity_token']
  end
end