module KeteBrowserid
  REPLACE_EXISTING_LOGIN = true
  REPLACE_EXISTING_REGISTER = true

  def self.supported?(user_agent)
    !user_agent.include?('MSIE 7.') && !user_agent.include?('MSIE 6.')
  end
end
