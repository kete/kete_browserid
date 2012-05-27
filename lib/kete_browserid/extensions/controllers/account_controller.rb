require 'faraday'

# add browserid_login action
AccountController.class_eval do
  skip_before_filter :verify_authenticity_token, :only => :login_via_browserid

  # browserid_login action will:
  # take assertion that browserid submission provides
  # check if email exists on our site
  # if so, authenticate the user as per what would be done with normal account_controller#login action
  # if not, redirect to browserid specific signup action to register the user
  def login_via_browserid
    assertion = params[:assertion]

    browserid_response = Faraday.post 'https://browserid.org/verify', { :assertion => assertion, :audience => Kete.site_url }
    
    browserid_hash = ::ActiveSupport::JSON.decode(browserid_response.body)

    browserid_email = browserid_hash['email']
    
    raise "BrowserID failure: #{browserid_hash.inspect}" unless browserid_email
    
    @user = User.find_by_email(browserid_email)

    if @user
      self.current_user = @user
      move_session_searches_to_current_user
      flash[:notice] = t('account_controller.login_via_browserid.logged_in')
      redirect_back_or_default({ :locale => current_user.locale,
                                 :urlified_name => @site_basket.urlified_name,
                                 :controller => 'account',
                                 :action => 'index' }, current_user.locale)
    else
      flash[:notice] = t('account_controller.login_via_browserid.no_account_matches')
      redirect_to :action => :signup_as_browserid, :email => browserid_email
    end
  end

  def signup_as_browserid
    raise ArgumentError, "email expected." if params[:email].blank? && !request.post?

    # this loads @content_type
    load_content_type

    @user = User.new(:email => params[:email])

    set_captcha_type

    create_brain_buster if @captcha_type == 'question'

    # after this is processing submitted form only
    return unless request.post?
    @user = User.new(params[:user].reject { |k, v| k == "captcha_type" })

    @user.creating_with_browserid = true

    case @captcha_type
    when 'image'
      if simple_captcha_valid?
        @user.security_code = params[:user][:security_code]
      end

      if simple_captcha_confirm_valid?
        @res = Captcha.find(session[:captcha_id])
        @user.security_code_confirmation = @res.text
      else
        @user.security_code_confirmation = false
      end
    when 'question'
      if validate_brain_buster
        @user.security_code = true
        @user.security_code_confirmation = true
      end
    end

    if agreed_terms?
      @user.agree_to_terms = params[:user][:agree_to_terms]
    end

    @user.save!

    @user.add_as_member_to_default_baskets

    flash[:notice] = t('account_controller.signup_as_browserid.signed_up_login_with_browserid')
    
    redirect_back_or_default({ :locale => params[:user][:locale],
                               :urlified_name => @site_basket.urlified_name,
                               :controller => 'account',
                               :action => 'index' })
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup_as_browserid'
  end
end
