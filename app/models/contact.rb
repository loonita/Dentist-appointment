class Contact < MailForm::Base
  attribute :nombre, :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :mensaje,   :validate => true
  attribute :telefono,  :validate  => true


  def headers
    {
      :subject => "Formulario Contacto",
      :to => "clinicasanantoniotalca@gmail.com",
      :from => "clinicasanantonio@tvidal.ubiobio.dev"
    }
  end
end