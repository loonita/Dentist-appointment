module PatientSearchable
  extend ActiveSupport::Concern

  class_methods do
    def search_by_name(query)
      # Normaliza el término de búsqueda
      normalized_query = normalize_string(query)

      # Realiza la búsqueda utilizando el término normalizado
      joins(:role).where(
        'unaccent(lower(users.name)) LIKE :query OR ' \
          'unaccent(lower(users.last_name)) LIKE :query OR ' \
          'unaccent(lower(users.rut)) LIKE :query ',
        query: "%#{normalized_query}%"
      )
    end

    private

    def normalize_string(str)
      I18n.transliterate(str.to_s.downcase)
    end
  end
end