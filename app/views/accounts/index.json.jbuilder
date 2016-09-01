json.array!(@accounts) do |account|
  json.extract! account, :id, :user_id, :name, :street, :suburb, :state, :country, :phone, :contact, :contact, :seller_level
  json.url account_url(account, format: :json)
end
