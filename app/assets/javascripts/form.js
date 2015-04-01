
function formjs(){
    
    this.timeout_campo={}
    this.form=null;
    
    this.constructor = function(){
        
        
        
        this.form=$('form[data-remote=true]');
        // Agregar eventos
        $('input[validar-con-ruta]').on('change',function(){formjs.validar_campo(this)});
        $('select[validar-con-ruta]').on('change',function(){formjs.validar_campo(this)});
        if($('input[obtener-valor-de-ruta]'))
            agregarBusqueda($('input[obtener-valor-de-ruta]'));
        
        return this.form.on("ajax:success", function(e, data, status, xhr) {

            formjs.alterar_form(data);
            
            //return $("form").append(xhr.responseText);
        }).on("ajax:error", function(e, xhr, status, error) {
            alert("no se ha recibido respuesta");
        });
    }
    
    this.validar_campo=function(campo){
        this.timeout_campo[campo.id]=campo.value;
        setTimeout('formjs.request_campo(\''+campo.id+'\',\''+campo.value+'\')',500);
    }
    
    this.request_campo=function(campo_id,campo_valor){
        
        if(this.timeout_campo[campo_id]===campo_valor){
            
            $('div#campo_'+campo_id).addClass('cargando');
            $('div#campo_'+campo_id).children('.msg_error').html('cargando...');
            
            var params=campo_valor;
            
            $.ajax({
                url:$('#'+campo_id).attr('validar-con-ruta')+'/'+params,
                async:true
            }).done(function(result){

                $('div#campo_'+campo_id).removeClass('cargando');
                $('div#campo_'+campo_id).children('.msg_error').html('');

                if(result){
                    if(result['_form'])
                        formjs.alterar_form(result['_form']);
                    if(result['_campos'])
                        formjs.alterar_campos(result['_campos']);
                }
            });
            
        }
        
    }
    
    this.alterar_form=function(data){
        formjs.form.find('div[id^=campo_]').removeClass('tiene_errores');
        formjs.form.find('div[id^=campo_]').children('.msg_error').html('');
        
        if(data['_exito']){
            formjs.form.removeClass('tiene_errores');
            formjs.form.children('div.resumen_errores').html('');
            if(data['_mensaje'])
                alert(data['_mensaje']);
            else
                alert('formulario enviado exitosamente');
            if(data['_ubicacion'])
                window.location=data['_ubicacion'];
        }
        else{
            formjs.form.addClass('tiene_errores');
            formjs.form.children('div.resumen_errores').html('se han encontrado '+data['_canterrores']+' errores');
            if(data['_campos'])
                formjs.alterar_campos(data['_campos']);
        }
    }
    
    this.alterar_campos=function(campos){
        for(var i in campos)
            formjs.alterar_campo(i,campos[i])
    }
    
    this.alterar_campo=function(id,cambios){
        if($('#'+id)){
            if(cambios['_set']){
                for(var i in cambios['_set']){
                    if(i=='error'){
                        $('div#campo_'+formjs.form.attr('id')+'_'+id).addClass('tiene_errores');
                        $('div#campo_'+formjs.form.attr('id')+'_'+id).children('.msg_error').html(cambios['_set'][i]+'<br/>');
                    }
                    else if(i=='label'){
                        $('label[for='+formjs.form.attr('id')+'_'+id+']').html(cambios['_set'][i]);
                    }
                    else{
                        if($('#'+formjs.form.attr('id')+'_'+id).length){
                            if($('#'+formjs.form.attr('id')+'_'+id).is('select')&&i=='opciones'){
                                $('#'+formjs.form.attr('id')+'_'+id).find('option').remove().end();
                                for( var j in cambios['_set'][i])
                                    $('#'+formjs.form.attr('id')+'_'+id).append(new Option(j,cambios['_set'][i][j]));
                            }
                            else
                                $('#'+formjs.form.attr('id')+'_'+id).prop(i,cambios['_set'][i]);
                        }
                        else if($('[id^='+formjs.form.attr('id')+'_'+id+'_]').length&&($('[id^='+formjs.form.attr('id')+'_'+id+'_]').attr('type')=='radio'||$('[id^='+formjs.form.attr('id')+'_'+id+'_]').attr('type')=='checkbox')){
                            if(i=='value'){
                                $('[id^='+formjs.form.attr('id')+'_'+id+'_]').removeProp('checked');
                                $('#'+formjs.form.attr('id')+'_'+id+'_'+cambios['_set'][i]).prop('checked',true);
                            }
                            else
                                $('[id^='+formjs.form.attr('id')+'_'+id+'_]').prop(i,cambios['_set'][j]);
                        }
                    }
                }
            }
            if(cambios['_unset']){
                for(var i in cambios['_unset']){
                    if(i=='error'){
                        $('div#campo_'+formjs.form.attr('id')+'_'+id).removeClass('tiene_errores');
                        $('div#campo_'+formjs.form.attr('id')+'_'+id).children('.msg_error').html('');
                    }
                    else{
                        if($('#'+formjs.form.attr('id')+'_'+id).length){
                            if($('#'+formjs.form.attr('id')+'_'+id).is('select')&&i=='opciones')
                                $('#'+formjs.form.attr('id')+'_'+id).find('option').remove().end();
                            else
                                $('#'+formjs.form.attr('id')+'_'+id).removeProp(i);
                        }
                        else if($('[id^='+formjs.form.attr('id')+'_'+id+'_]').length&&($('[id^='+formjs.form.attr('id')+'_'+id+'_]').attr('type')=='radio'||$('[id^='+formjs.form.attr('id')+'_'+id+'_]').attr('type')=='checkbox')){
                            if(i=='value')
                                $('[id^='+formjs.form.attr('id')+'_'+id+'_]').removeProp('checked');
                            else
                                $('[id^='+formjs.form.attr('id')+'_'+id+'_]').removeProp(i);
                        }
                    }
                }
            }
        }
    }
}

var formjs=new formjs();

function agregarBusqueda(campo){
    $('<a href="#" id="enlace_'+campo.attr('id')+'">buscar</a><div title="buscar" id="buscar_'+campo.attr('id')+'" style="display:none"></div>').insertAfter(campo);
    $('#buscar_'+campo.attr('id')).dialog({ autoOpen: false, modal: true, width: 800, height: 480,
        buttons: {
            aceptar: function() {
                var valor='';
                for(var i=0;$('#check_'+campo.attr('id')+'_'+i).attr('id');i++){
                    if($('#check_'+campo.attr('id')+'_'+i).is(':checked')){
                        valor+=$('#check_'+campo.attr('id')+'_'+i).val()+', ';
                    }
                }
                campo.val(valor.substr(0,(valor.length-2)));
		$(this).dialog("close");
            },
            cancelar: function() {
		$(this).dialog("close");
            }}});
    $('#enlace_'+campo.attr('id')).click(function() {
        $('#buscar_'+campo.attr('id')).dialog( "open" );
        $.ajax({
            url:$('#'+campo.attr('id')).attr('obtener-valor-de-ruta'),
            async:true
        }).done(function(result){
            lista='<table>';
            if(result['titulos']){
                lista+='<tr style="font-weight:bold;"><td></td>';
                for(var i in result['titulos'])
                    lista+='<td>'+result['titulos'][i]+'</td>';
                lista+='</tr>';
            }
            if(result['lista']){
                for(var i in result['lista']){
                    lista+='<tr><td><input type="checkbox" id="check_'+campo.attr('id')+'_'+i+'" name="check_'+campo.attr('id')+'['+i+']" value="'+result['lista'][i]['valor']+'" /></td>';
                    for(var j in result['lista'][i]['filas'])
                        lista+='<td>'+result['lista'][i]['filas'][j]+'</td>';
                    lista+='</tr>';
                }
            }
            lista+='</table>';
            $('#buscar_'+campo.attr('id')).html(lista);
        })
    });
}