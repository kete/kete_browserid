ApplicationHelper.module_eval do
  def link_to_login(phrase, url_for_options, html_options)
    html = link_to_unless_current phrase, url_for_options, html_options
    html += '</li><li>'
    html += link_to(t('application_helper.link_to_login.login_with_browserid'),
                    'javascript:window.browserid_login()', :id => '#browserid', :title => "Sign-in with BrowserID link. ")
    html
  end

  def link_to_register(phrase, url_for_options, html_options)
    html = link_to_unless_current phrase, url_for_options, html_options
    html += '</li><li>'
    html += link_to(t('application_helper.link_to_register.register_via_browserid'),
                    'javascript:window.browserid_login()', :id => '#browserid-register', :title => "Signup with BrowserID link. ")
    html
  end
end
