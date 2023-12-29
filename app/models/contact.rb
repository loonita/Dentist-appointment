class Contact < MailForm::Base
  attribute :nombre, :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :mensaje,   :validate => true
  attribute :telefono,  :validate  => true


  def headers
    {
      :subject => "Formulario Contacto",
      :to => "teresa.vidal2001@alumnos.ubiobio.cl",
      :from => "teresa.vidal2001@alumnos.ubiobio.cl"
    }
  end
end