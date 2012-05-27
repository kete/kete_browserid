config.to_prepare do
  # load our locales
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), '../config/locales/*.{rb,yml}')]

  # override some controllers and helpers we need to alter for browserid support
  exts = File.join(File.dirname(__FILE__), '../lib/kete_browserid/extensions/{controllers,helpers}/*')
  # use Kernel.load here so that changes to the extensions are reloaded on each request in development
  Dir[exts].each { |ext_path| Kernel.load(ext_path) }

  # models we extend
  Dir[File.join(File.dirname(__FILE__), '../lib/kete_browserid/extensions/models/*')].each do |ext_path|
    key = File.basename(ext_path, '.rb').to_sym
    Kete.add_code_to_extensions_for(key, Proc.new { Kernel.load(ext_path) })
  end
end
