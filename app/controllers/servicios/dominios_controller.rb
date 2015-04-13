class Servicios::DominiosController < ApplicationController
  
  def index
    
  end
  
  def whois
    if params['nombre'] && params['dominio']
      obj = Whois::Client.new
      plandominio = PlanDominio.where(:dominio => params[:dominio], :borrado => {'$exists' => false}).first
      locals={}
      if plandominio
        locals[:_id] = plandominio._id
        locals[:nombre] = params[:nombre]
        locals[:dominio] = plandominio.dominio
        locals[:disponible] = obj.lookup(params['nombre']+'.'+plandominio.dominio).available?
      else
        locals[:_id] = nil
        locals[:nombre] = params[:nombre]
        locals[:dominio] = params[:dominio]
        locals[:disponible] = false
      end
      locals[:otros]=[]
      PlanDominio.where(:borrado => {'$exists' => false}).each do |dominio|
        if params['dominio'] != dominio.dominio && obj.lookup(params['nombre']+'.'+dominio.dominio).available?
          locals[:otros] << { :_id => dominio._id, :nombre => params['nombre'], :dominio => dominio.dominio }
        end
      end
      render 'servicios/dominios/index.html', :locals => locals
    else
      render 'servicios/dominios/index.html'
    end
  end
  
end