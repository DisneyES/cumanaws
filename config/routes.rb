Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  devise_for :cuentas, :skip => [:sessions,:registrations,:passwords]
  as :cuenta do
    
    get 'iniciarsesion', to: 'sessions#new', as: :iniciarsesion
    post 'iniciarsesion', to: 'sessions#create'
    get 'iniciarsesion/:redir', to: 'sessions#new', as: :iniciarsesion_redir
    post 'iniciarsesion/:redir', to: 'sessions#create'
    
    
    get 'cerrarsesion', to: 'devise/sessions#destroy', as: :cerrarsesion
    
    get 'crearcuenta', to: "registrations#new"
    post 'crearcuenta', to: "registrations#create"
    
    get 'cancelarcuenta', to: "devise/registrations#cancel", as: :cancel_cuenta_registration
    
    get 'editarcuenta', to: "registrations#edit", as: :edit_cuenta_registration
    patch 'editarcuenta', to: "registrations#update" #, as: :edit_cuenta_registration
    put 'editarcuenta', to: "registrations#update" # , as: :edit_cuenta_registration
    
    delete 'eliminarcuenta', to: "devise/registrations#destroy" #, as: :edit_cuenta_registration
    
    get 'crearcuenta/validarpais/:pais' , to: 'registrations#validar_pais'
    get 'crearcuenta/validaref/:pais/:ef' , to: 'registrations#validar_ef'
    
    #get 'validarorganizacion/:representa' , to: 'registrations#validar_organizacion'
    
    #get 'validarorganizacionef/:ef' , to: 'registrations#validar_organizacion_ef'
    
    get "recuperarcontrasenia", to: "devise/passwords#new", as: :new_cuenta_password
    post "recuperarcontrasenia", to: "devise/passwords#create", as: :cuenta_password
    
    get "cambiarcontrasenia", to: "devise/passwords#edit",  as: :edit_cuenta_password
    patch "cambiarcontrasenia", to: "devise/passwords#update" # , as: :edit_cuenta_password
    put "cambiarcontrasenia", to: "devise/passwords#update" #, as: :edit_cuenta_password
    
  end
  
  get 'micuenta', controller: 'mi_cuenta', action: 'index', as: :mi_cuenta
  get 'micuenta/dominios', controller: 'mi_cuenta/dominios', action: 'index', as: :mi_cuenta_dominios
  get 'micuenta/hospedaje', controller: 'mi_cuenta/hospedaje', action: 'index', as: :mi_cuenta_hospedaje
  
  get 'micuenta/saldo', controller: 'mi_cuenta/saldo', action: 'index', as: :mi_cuenta_saldo
  get 'micuenta/recargarsaldo', controller: 'mi_cuenta/saldo', action: 'new', as: :mi_cuenta_recargar_saldo
  post 'micuenta/recargarsaldo', controller: 'mi_cuenta/saldo', action: 'create'
  
  get 'micuenta/configuracion', controller: 'mi_cuenta/configuracion', action: 'index', as: :mi_cuenta_configuracion
  
  get 'administracion', controller: 'administracion', action: 'index', as: :administracion
  
  get 'administracion/cuentas', controller: 'administracion/cuentas', action: 'index', as: :administracion_cuentas
  get 'administracion/editarcuenta/:id', controller: 'administracion/cuentas', action: 'edit', as: :administracion_editar_cuenta
  put 'administracion/editarcuenta/:id', controller: 'administracion/cuentas', action: 'update'
  
  get 'administracion/recargas', controller: 'administracion/recargas', action: 'index', as: :administracion_recargas
  get 'administracion/procesarrecarga/:id', controller: 'administracion/recargas', action: 'edit', as: :administracion_procesar_recarga
  put 'administracion/procesarrecarga/:id', controller: 'administracion/recargas', action: 'update'
  
  get 'administracion/compras', controller: 'administracion/compras', action: 'index', as: :administracion_compras
  get 'administracion/procesarcompra/:id', controller: 'administracion/compras', action: 'edit', as: :administracion_procesar_compra
  put 'administracion/procesarcompra/:id', controller: 'administracion/compras', action: 'update'
  
  get 'administracion/planesdominios', controller: 'administracion/planes_dominios', action: 'index', as: :administracion_planes_dominios
  get 'administracion/nuevoplandominio', controller: 'administracion/planes_dominios', action: 'new', as: :administracion_nuevo_plan_dominio
  post 'administracion/nuevoplandominio', controller: 'administracion/planes_dominios', action: 'create'
  get 'administracion/editarplandominio/:id', controller: 'administracion/planes_dominios', action: 'edit', as: :administracion_editar_plan_dominio
  put 'administracion/editarplandominio/:id', controller: 'administracion/planes_dominios', action: 'update'
  
  get 'administracion/planeshospedaje', controller: 'administracion/planes_hospedaje', action: 'index', as: :administracion_planes_hospedaje
  get 'administracion/nuevoplanhospedaje', controller: 'administracion/planes_hospedaje', action: 'new', as: :administracion_nuevo_plan_hospedaje
  post 'administracion/nuevoplanhospedaje', controller: 'administracion/planes_hospedaje', action: 'create'
  get 'administracion/editarplanhospedaje/:id', controller: 'administracion/planes_hospedaje', action: 'edit', as: :administracion_editar_plan_hospedaje
  put 'administracion/editarplanhospedaje/:id', controller: 'administracion/planes_hospedaje', action: 'update'
  
  get 'administracion/cuentasbancarias', controller: 'administracion/cuentas_bancarias', action: 'index', as: :administracion_cuentas_bancarias
  get 'administracion/nuevactabancaria', controller: 'administracion/cuentas_bancarias', action: 'new', as: :administracion_nueva_cta_bancaria
  post 'administracion/nuevactabancaria', controller: 'administracion/cuentas_bancarias', action: 'create'
  get 'administracion/editarctabancaria/:id', controller: 'administracion/cuentas_bancarias', action: 'edit', as: :administracion_editar_cta_bancaria
  put 'administracion/editarctabancaria/:id', controller: 'administracion/cuentas_bancarias', action: 'update'
  
  get 'administracion/monedas', controller: 'administracion/monedas', action: 'index', as: :administracion_monedas
  get 'administracion/nuevamoneda', controller: 'administracion/monedas', action: 'new', as: :administracion_nueva_moneda
  post 'administracion/nuevamoneda', controller: 'administracion/monedas', action: 'create'
  get 'administracion/editarmoneda/:id', controller: 'administracion/monedas', action: 'edit', as: :administracion_editar_moneda
  put 'administracion/editarmoneda/:id', controller: 'administracion/monedas', action: 'update'
  
  
  get 'servicios', controller: 'servicios', action: 'index', as: :servicios
  
  get 'servicios/dominios', controller: 'servicios/dominios', action: 'index', as: :servicios_dominios
  post 'servicios/dominios', controller: 'servicios/dominios', action: 'whois'
  
  get 'servicios/hospedaje', controller: 'servicios/hospedaje', action: 'index', as: :servicios_hospedaje
  
  get 'blog', controller: 'blog', action: 'index', as: :blog
  
  get 'clientes', controller: 'clientes', action: 'index', as: :clientes
  
  get 'carrito', controller: 'carrito', action: 'index', as: :carrito
  get 'carrito/agregar/hospedaje/:id', controller: 'carrito', action: 'agregar_hospedaje', as: :agregar_hospedaje_carrito
  get 'carrito/agregar/dominio/:id/:nombre', controller: 'carrito', action: 'agregar_dominio', as: :agregar_dominio_carrito
  get 'carrito/remover/:id', controller: 'carrito', action: 'remover', as: :remover_articulo_carrito
  get 'carrito/editar/:id/:duracion', controller: 'carrito', action: 'editar', as: :editar_articulo_carrito
  get 'carrito/pagar', controller: 'carrito', action: 'new', as: :pagar_carrito
  post 'carrito/pagar', controller: 'carrito', action: 'create'
  
  get 'nosotros', controller: 'nosotros', action: 'index', as: :nosotros
  
  get 'contacto', controller: 'contacto', action: 'new', as: :contacto
  post 'contacto', controller: 'contacto', action: 'create'
  
  
  root to: 'inicio#index'
  
end
