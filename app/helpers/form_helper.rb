module FormHelper
  
#  def formulario(path)
#    form_for(resource, url:  path, remote: true, html: { id: resource_name, class: form_clase, 'data-type' => :json})
#  end
  
  def form_clase
    unless resource.errors.empty?
      "tiene_errores"
    else
      ""
    end
  end
  
  def form_resumen_errores
    if resource.errors.empty?
      html = <<-HTML
      <div id=\"errores_#{resource_name}" class="resumen_errores"></div>
      HTML
    else
      sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
      html = <<-HTML
      <div id=\"errores_#{resource_name}" class="resumen_errores">
        #{sentence}
      </div>
      HTML
    end
    html.html_safe
  end
  
  def form_campo_error!(nombre)
    unless resource.errors[nombre].empty?
      "<div class=\"msg_error\">#{resource.errors[nombre].join("<br/>")}</div>".html_safe
    else
      "<div class=\"msg_error\"></div>".html_safe
    end
  end
  
  def form_campo_error?(nombre)
    unless resource.errors[nombre].empty?
      true
    else
      false
    end
  end
  
  def form_campo(form,nombre,campo,params={})
    if form_campo_error?(nombre)
      campo_completo= "<div id=\"campo_#{form.object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")}_#{nombre}\" class=\"tiene_errores\">".html_safe
    else
      campo_completo= "<div id=\"campo_#{form.object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")}_#{nombre}\">".html_safe
    end
    unless campo=='check_box'
      if params[:label]
        campo_completo+= form.label(nombre,params[:label]) + '<br/>'.html_safe
      else
        campo_completo+= form.label(nombre) + '<br/>'.html_safe
      end
    end
    case campo
      when 'text_field'
        campo_completo+=form.text_field nombre, params.except(:label)
      when 'text_area'
        campo_completo+=form.text_area nombre, params.except(:label)
      when 'password_field'
        campo_completo+=form.password_field nombre, params.except(:label)
      when 'select'
        campo_completo+=form.select nombre, params[:opciones], {}, params.except(:opciones,:label)
      when 'check_box'
        campo_completo+=form.check_box(nombre, params.except(:label), 1, 0)+form.label(nombre)
      when 'date_field'
        # params[:date_separator] = '/'
        # params[:prompt] = {day: 'día', month: 'mes', year: 'año'}
        if params[:default]
          params[:value] = params[:default].to_s(:es)
        end
        params[:placeholder] = 'DD/MM/YYYY'
        campo_completo+="<script>
            $(document).ready(function(){
              $('##{form.object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")}_#{nombre}').datepicker({
                dateFormat: 'dd/mm/yy',
                changeMonth: true,
                changeYear: true,
                monthNames: #{t('date.month_names')[1..12]},
                monthNamesShort: #{t('date.abbr_month_names')[1..12]}
              });
            ".html_safe
        if params[:desde]
          campo_completo+="$('##{form.object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")}_#{nombre}').datepicker( 'option', 'minDate', '#{params[:desde].to_s(:es)}' );".html_safe
        end
        if params[:hasta]
          campo_completo+="$('##{form.object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")}_#{nombre}').datepicker( 'option', 'maxDate', '#{params[:hasta].to_s(:es)}' );".html_safe
        end
        campo_completo+="});</script>".html_safe
        campo_completo+=form.text_field nombre, params.except(:label)
      when 'id_field'
        params[:class] = 'id_field'
        campo_completo+=form.select(nombre.to_s+'_cat', params[:categorias],{}, params.except(:categorias,:autocomplete,:label))+'-'+form.text_field(nombre, params.except(:categorias,:label))
    end
    campo_completo+=form_campo_error!(nombre) + '</div>'.html_safe
  end
  
end