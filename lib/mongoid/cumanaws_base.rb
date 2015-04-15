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
      
    end
  
  end
end