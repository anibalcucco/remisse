module TrabajosHelper

  def pagos_registrados(cantidad)
    case cantidad
    when 0
      'No se registraron pagos'
    when 1
      'Se registro 1 pago'
    else
      "Se registraron #{cantidad} pagos"
    end
  end


end
