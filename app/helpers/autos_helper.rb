module AutosHelper
  def todo_pagado_link(auto)
    link_to "Marcar todo como pagado",
            pagado_auto_path(auto),
            :confirm => "Esto va a marcar todos los dias como pagados para '#{auto.nombre_completo}'. Esta seguro?",
            :method => :post
  end

  def debe_column(auto, column)
    return "No debe" if auto.trabajos_no_pagados.empty?
    content = link_to "Debe #{auto.trabajos_no_pagados.size} dias", bulk_trabajos_path(:auto_id => auto)
    links = []
    auto.trabajos_no_pagados.each { |trabajo| links << trabajo.fecha_formateada }
    content << ': ' << "#{links.join(", ")}"
    content << '. ' << todo_pagado_link(auto)
  end

  def auto_list_row_class(auto)
    auto.trabajos_no_pagados.count >= 8 ? 'moroso' : ''
  end
end
