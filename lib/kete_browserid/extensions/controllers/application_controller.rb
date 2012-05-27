ApplicationController.class_eval do
  before_filter :set_add_on_scripts_and_links

  # set up our browserid javascript loading
  def set_add_on_scripts_and_links

    browserid_login_url = "/#{@site_basket.urlified_name}/account/login_via_browserid"
    head_js = " <script src=\"https://browserid.org/include.js\" type=\"text/javascript\"></script>"

    head_js += " <script type=\"text/javascript\">
    function setUpBrowserIDForm() {
      var form_html = '<form id=\"browserid_login_form\" action=\"#{browserid_login_url}\" style=\"display: none;\" method=\"post\">';
      form_html += '<input type=\"hidden\" name=\"assertion\" />';
      form_html += '<input style=\"display: none\" type=\"submit\" />';
      form_html += '</form>';

      jQuery('#body-outer-wrapper').append(form_html);
    }
    function browserid_login() {
      navigator.id.get(gotAssertion);
      }
    function gotAssertion(assertion) {  
        if (assertion !== null) {
          setUpBrowserIDForm();
          
          jQuery('input[name=assertion]').val(assertion);

          jQuery('#browserid_login_form').submit();
        }
      }
    </script>"

    # HACK to get content_for setting in controller
    # we shouldn't use the internal representation (instance variable) of content_for data
    # but we are, as we want to set this on every request
    # WARNING: because of this use of internal data storage hack, this will break with Rails 3x
    @content_for_add_on_scripts_and_links ||= String.new
    @content_for_add_on_scripts_and_links += head_js unless @content_for_add_on_scripts_and_links.include?(head_js)
  end

  private :set_add_on_scripts_and_links
end
