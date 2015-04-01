class Servicios::DominiosController < ApplicationController
  
  def index
    
  end
  
  def whois
    if params['nombre'] && params['dominio']
      obj = Whois::Client.new
      otros=[]
      AppConfig.preferencias.planes_dominios.each do |dominio|
        if params['dominio'] != dominio['nombre'] && obj.lookup(params['nombre']+'.'+dominio['nombre']).available?
          otros << { :nombre => params['nombre'], :dominio => dominio['nombre'] }
        end
      end
      render 'servicios/dominios/index.html', :locals => {
          :nombre => params['nombre'], :dominio => params['dominio'], :disponible => obj.lookup(params['nombre']+'.'+params['dominio']).available?,
          :otros => otros
        }
    else
      render 'servicios/dominios/index.html'
    end
  end
  
end