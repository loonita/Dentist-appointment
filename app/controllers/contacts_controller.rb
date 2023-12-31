class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:error] = nil
      redirect_to root_path, notice: 'Mensaje enviado, ¡te contactaremos pronto!'
    else
      flash.now[:error] = 'No se logró enviar el mensaje.'
      render :new
    end
  end
end
