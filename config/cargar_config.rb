require 'configurate'

rails_root = File.expand_path('../../', __FILE__)
rails_env = ENV['RACK_ENV']
rails_env ||= ENV['RAILS_ENV']
rails_env ||= 'development'

config_dir = File.join rails_root, 'config'

AppConfig ||= Configurate::Settings.create do
  add_provider Configurate::Provider::Dynamic
  add_provider Configurate::Provider::Env
  
  unless rails_env == "test" || File.exists?(File.join(config_dir, 'cumanaws.yml'))
    $stderr.puts "ERROR FATAL: Configuraci&oacute;n no encontrada. Copia el archivo cumanaws.yml.ejemplo a cumanaws.yml y editalo seg&uacute;n tus necesidades."
    exit!
  end
  
  add_provider Configurate::Provider::YAML,
               File.join(config_dir, 'cumanaws.yml'),
               namespace: rails_env, required: false unless rails_env == 'test'
  add_provider Configurate::Provider::YAML,
               File.join(config_dir, 'cumanaws.yml'),
               namespace: "configuracion", required: false
  add_provider Configurate::Provider::YAML,
               File.join(config_dir, 'pordefecto.yml'),
               namespace: rails_env
  add_provider Configurate::Provider::YAML,
               File.join(config_dir, 'pordefecto.yml'),
               namespace: "pordefecto"
  
end