class Notifications < ApplicationMailer

  def receptores(params,email)
    @parameters=params

    mail( to: email, subject: @parameters[:subject])
  end

  def ingreso_corte(params,email)
    @parameters=params

    mail( to: email, subject: @parameters[:subject])
  end

  def cambios_corte(params,email)
    @parameters=params

    mail( to: email, subject: @parameters[:subject])
  end

  #hola = {:subject => nil}
  #hola[:subject] = 'meh'
  #Notifications.receptores(hola,"slakat@gmail.com").deliver_now

end
