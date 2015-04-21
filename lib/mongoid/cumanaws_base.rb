module Mongoid

  module CumanawsBase
    extend ActiveSupport::Concern
    
    included do
      
      include Mongoid::Document
      
      ## Registro de modificaciones
      embeds_one :creado
      embeds_many :ediciones
      
      before_create do |document|
        document.creado = Creado.new
        if $cuenta_signed_in
          document.creado.cuenta = $cuenta
        end
      end
      
      after_initialize do |document|
        
      end
      
      before_update do |document|
        edicion = Edicion.new
        if $cuenta_signed_in
          edicion.cuenta = $cuenta
        end
        document.ediciones.push(edicion)
      end
      
      def app_url
        AppConfig.aplicacion.url
      end
      
      def app_host
        AppConfig.aplicacion.host
      end
      
      def ns_host
        AppConfig.aplicacion.ns.host
      end
      
      def ns_mail
        AppConfig.aplicacion.ns.mail
      end
      
    end
  
  end
end