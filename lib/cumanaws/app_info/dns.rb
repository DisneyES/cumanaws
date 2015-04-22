module Cumanaws
  
  module AppInfo
    
    # To get information about the DNS configuration
    module Dns

      # Return the Host of the Name Server
      # @return [String]
      def ns_host
        AppConfig.aplicacion.ns.host
      end

      # Return the e-mail address of the Name Server Administrator
      # @return [String]
      def ns_mail
        AppConfig.aplicacion.ns.mail
      end

    end
  
  end
  
end