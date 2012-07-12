ApplicationHelper.module_eval do
  def link_for_login_with_browserid
    link_to(t('application_helper.link_for_login_with_browserid.login_with_browserid'),
            'javascript:window.browserid_login()',
            :id => '#browserid',
            :title => "Sign-in with BrowserID link. ")
  end
  
  def link_to_login(phrase, url_for_options, html_options)
    standard_html = link_to_unless_current phrase, url_for_options, html_options
    return standard_html unless ::KeteBrowserid.supported?(request.user_agent)

    html = String.new

    # don't make link active for login page
    browserid_login_html = if params[:controller] == 'account' && params[:action] == 'login'
                             t('application_helper.link_to_login.login_with_browserid')
                           else
                             link_for_login_with_browserid
                           end

    
    unless ::KeteBrowserid::REPLACE_EXISTING_LOGIN
      html = standard_html
      html += '</li><li>'
    end

    html += browserid_login_html
    html
  end

  def link_for_register_via_browserid
    link_to(t('application_helper.link_for_register_via_browserid.register_via_browserid'),
            'javascript:window.browserid_login()',
            :id => '#browserid-register',
            :title => "Signup with BrowserID link. ")
  end

  def link_to_register(phrase, url_for_options, html_options)
    standard_html = link_to_unless_current phrase, url_for_options, html_options
    return standard_html unless ::KeteBrowserid.supported?(request.user_agent)

    html = String.new
    
    # don't make link active for signup page
    browserid_register_html = if params[:controller] == 'account' && params[:action] == 'signup'
                                t('application_helper.link_to_register.register_via_browserid')
                              else
                                link_for_register_via_browserid
                              end

    unless ::KeteBrowserid::REPLACE_EXISTING_REGISTER
      html = 
      html += '</li><li>'
    end

    html += browserid_register_html
    html
  end
end
