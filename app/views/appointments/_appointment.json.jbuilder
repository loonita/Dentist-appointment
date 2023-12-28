json.extract! appointment, :id, :start_time, :time, :status_id, user_id, dentist_id, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
