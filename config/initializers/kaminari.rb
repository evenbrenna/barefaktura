# To avoid conflicts with will_paginate
# Kaminari is used by Active Admin
Kaminari.configure do |config|
  config.page_method_name = :per_page_kaminari
end
