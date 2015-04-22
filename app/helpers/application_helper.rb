module ApplicationHelper
  include Cumanaws::AppInfo
  
  def titulo
    AppConfig.aplicacion.titulo.present? ? AppConfig.aplicacion.titulo.html_safe : 'cuman&aacute; web services'.html_safe
  end
  def eslogan
    AppConfig.aplicacion.eslogan.present? ? AppConfig.aplicacion.eslogan.html_safe : false
  end
  def logo_src
    AppConfig.aplicacion.logo_src.present? ? AppConfig.aplicacion.logo_src.html_safe : false
  end
  def favicon_src
    AppConfig.aplicacion.favicon_src.present? ? AppConfig.aplicacion.favicon_src.html_safe : 'favicon.png'
  end
  def descripcion
    AppConfig.aplicacion.descripcion.present? ? AppConfig.aplicacion.descripcion.html_safe : false
  end
  def etiquetas
    AppConfig.aplicacion.etiquetas.present? ? AppConfig.aplicacion.etiquetas.html_safe : false
  end
  def resumen
    AppConfig.aplicacion.resumen.present? ? AppConfig.aplicacion.resumen.html_safe : '<!--[if lte IE 8]><span style="filter: FlipH; -ms-filter: "FlipH"; display: inline-block;"><![endif]-->
                                                                                    <span style="-moz-transform: scaleX(-1); -o-transform: scaleX(-1); -webkit-transform: scaleX(-1); transform: scaleX(-1); display: inline-block;">
                                                                                      &copy;
                                                                                    </span>
                                                                                    <!--[if lte IE 8]></span><![endif]-->
                                                                                    2015 cuman&aacute; web services'.html_safe
  end
  def select_paises(recursivo=false)
    paises=[['Selecione','']]
    AppConfig.aplicacion.paises.each do |pais|
      paises << [pais['nombre'],pais['codigo']]
    end
    return paises
  end
  def select_efs(pais,recursivo=false)
    efs=[['Selecione','']]
    AppConfig.aplicacion.paises.select{|k| k['codigo']==pais}[0]['entidades_federales'].each do |ef|
      efs << [ef['nombre'],ef['codigo']]
    end
    return efs
  end
  def select_localidades(pais,ef,recursivo=false)
    localidades=[['Selecione','']]
    AppConfig.aplicacion.paises.select{|k| k['codigo']==pais}[0]['entidades_federales'].select{|k| k['codigo']==ef}[0]['localidades'].each do |localidad|
      localidades << [localidad['nombre'],localidad['codigo']]
    end
    return localidades
  end
  
#  def select_doc_id_categorias(pais,modelo)
#    cats = []
#    AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==pais}[0]['documentos_identidad'].select{|k| k['modelos'].include?(modelo)}.each do |cat|
#      cats << [cat['categoria'],cat['categoria']]
#    end
#    return cats
#  end
#  def select_organizaciones(pais)
#    tipos = [['Selecione','']]
#    AppConfig.preferencias.parametros_por_pais.select{|k| k['codigo']==pais}[0]['organizaciones'].each do |org|
#      tipos << [org['nombre'],org['codigo']]
#    end
#    return tipos
#  end
#  def select_metodos_pagos
#    tipos = [['Selecione','']]
#    AppConfig.preferencias.metodos_pago.each do |metodo|
#      tipos << [metodo['nombre'],metodo['tipo']]
#    end
#    return tipos
#  end

  def select_ctas_bancarias
    tipos = [['Selecione','']]
    CuentaBancaria.where(:borrado => {'$exists' => false}).each do |cta|
      tipos << [cta.banco.nombre + ', ' + cta.nro, cta._id]
    end
    return tipos
  end
  
  def select_monedas
    tipos = [['Selecione','']]
    Moneda.where(:borrado => {'$exists' => false}).each do |moneda|
      tipos << [moneda.nombre + ' (' + moneda.codigo + ')', moneda._id]
    end
    return tipos
  end
  
end