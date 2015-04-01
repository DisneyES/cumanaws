class ContactoController < ApplicationController
  
  def resource_name
    :mensaje
  end
  
  def build_resource(hash=nil)
    self.resource = Mensaje.new(hash)
  end
  
  def new
    build_resource({})
    respond_with self.resource
  end
  
  def create
    
  end
  
end