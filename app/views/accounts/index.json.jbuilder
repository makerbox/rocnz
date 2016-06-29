json.array!(@accounts) do |account|
  json.extract! account, :id, :user_id, :company, :address, :suburb, :state, :country, :phone, :first_name, :last_name, :seller_level
  json.url account_url(account, format: :json)
end
