json.extract! appointment, :id, :rut, :name, :last_name, :email, :phone_number, :date, :time, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
