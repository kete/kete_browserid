config.to_prepare do
  # load our locales
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), '../config/locales/*.{rb,yml}')]

  # precedence over a plugin or gem's (i.e. an engine's) app/views
  # this is the way to go in most cases,
  # but in our case we want to override the app's view.
  # so we pop off our gem's app/views directory and put it at the front
  engine_views_dir = File.join(directory, 'app/views')
  # drop it from it's existing location if it exists
  ActionController::Base.view_paths.delete engine_views_dir
  # add it to the front of array
  ActionController::Base.view_paths.unshift engine_views_dir

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
