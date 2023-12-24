json.extract! appointment, :id, :status_id, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)