Rails.application.routes.draw do

  resources :adjusments do
    collection do
      get 'find_showroom'
    end
  end

  resources :transfer_items do
    collection do
      get 'find_serial_on_stock'
      get 'find_item_on_stock'
      get 'get_nama_from_serial'
      get 'get_kode_from_nama'
      get 'get_showrooms'
    end
  end

  resources :warehouse_admins

  namespace :accounting do
    get 'stocks/mutasi_stock'
    get 'stocks/view_stock'
    get 'stocks/view_selisih_intransit'
    get 'stocks/view_selisih_stock'
    get 'stocks/view_penjualan'
    get 'stocks/available_stock'
    resources :verifying_payments do
      collection do
        put 'verify'
        get 'show_order'
        get 'verify_order'
        get 'show_channel_payment'
      end
    end
  end

  resources :search_sales

  resources :sales_counters

  resources :acquittances do
    collection do
      get 'get_sale_info'
      get 'search_sales'
      get "search_sales_by_phone"
      get "get_mid_from_merchant"
      get "get_second_mid_from_merchant"
      get "rekap_pelunasan"
      get "export_xml"
    end
  end

  resources :bank_accounts

  resources :pos_ultimate_customers do
    collection do
      get 'get_customer_info'
    end
  end

  resources :channel_customers do
    collection do
      get "import_intransit"
      post "proses_import_intransit"
      post "proses_import_intransit_jde"
    end
  end

  get 'return_items/return'
  put 'return_items/process_return'
  get 'return_items/return_by_serial'
  put 'return_items/process_return_by_serial'
  get 'return_items/print_return'
  get 'return_items/show'
  get 'return_items/send_returned_items'
  get 'return_items/cancel_returned_items'

  get 'item_receipts/receipt'
  put 'item_receipts/process_receipt'
  get 'item_receipts/receipt_by_serial'
  get 'item_receipts/check_item_value'
  put 'item_receipts/process_receipt_by_serial'
  get 'item_receipts/receipt_jde'
  put 'item_receipts/process_receipt_jde'

  get 'reports/index'
  get 'reports/sales_counter'
  get 'reports/export_xml'
  get 'reports/rekap_so'
  get 'reports/mutasi_stock'
  get 'reports/selisih_intransit'
  get 'reports/selisih_retur'
  get 'reports/available_stock'
  get 'reports/index_akun'
  get 'reports/index_export'
  get 'reports/exported'

  devise_for :users, controllers: { sessions: "users/sessions" }

  devise_scope :user do
    authenticated :user do
      root controller: :page, :action => 'home'
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'page/home'
  get 'page/download_manual_book'
  get 'page/admin_master_landing_page'

  resources :stores

  resources :items

  get 'sale/update_stores', as: 'update_stores'

  resources :sales do
    collection do
      get "get_mid_from_merchant"
      get "get_second_mid_from_merchant"
      get "get_kode_barang_from_serial"
      get "get_kode_barang_from_nama"
      get "edit_by_confirmation"
      get "destroy_by_confirmation"
      get "exhibition_stock"
      get "items"
      get "item_master"
      get "stock_availability"
      get "request_cancel_order"
      get "show_sale"
      put "approve_cancel_order"
      get "rejected_cancel_order"
    end
  end

  resources :showrooms do
    collection do
      get "import_intransit"
      post "proses_import_intransit"
    end
  end

  resources :venues

  # The priority is based upon order of creation: first created -> highest priority. See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
#  root controller: :page, :action => 'home'

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
end
