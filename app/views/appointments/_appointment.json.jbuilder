json.extract! appointment, :id, :title, :date, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
