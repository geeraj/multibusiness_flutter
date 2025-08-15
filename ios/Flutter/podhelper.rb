require 'fileutils'
require 'yaml'

# Install pods needed to embed Flutter application, Flutter engine, and plugins
def flutter_application_pods
  flutter_root = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..'))
  raise "#{flutter_root} is not a valid directory. Run 'flutter pub get' first." unless File.directory?(flutter_root)

  ios_engine_dir = File.expand_path(File.join(flutter_root, 'bin', 'cache', 'artifacts', 'engine', 'ios'))
  raise "#{ios_engine_dir} not found. Run 'flutter precache --ios' first." unless File.directory?(ios_engine_dir)

  pod 'Flutter', :path => File.join(ios_engine_dir)

  # Read .flutter-plugins-dependencies
  dependencies_file = File.expand_path(File.join(flutter_root, '.flutter-plugins-dependencies'))
  if File.exist?(dependencies_file)
    plugin_hash = YAML.load_file(dependencies_file)
    plugin_hash['plugins']['ios'].each do |plugin|
      pod plugin['name'], :path => File.expand_path(plugin['path'], flutter_root)
    end
  end
end

# Ensure the iOS platform is at least 14.0
def flutter_minimum_ios_version(target)
  target.build_configurations.each do |config|
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
  end
end
