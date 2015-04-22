module Cumanaws
  
  # To get information about the application
  module AppInfo
    
    # Return the URL of the Application
    # @return [String]
    def app_url
      AppConfig.aplicacion.url
    end

    # Return the Host of the Application
    # @return [String]
    def app_host
      AppConfig.aplicacion.host
    end
    
  end
  
end
