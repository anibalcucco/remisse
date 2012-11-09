class AutosController < ApplicationController

  before_filter :authenticate_user!

  active_scaffold :auto do |config|
    config.actions = [:create, :update, :list, :delete, :show, :search]
    config.label = "Remisses YA!"
    config.columns = [:nombre, :oblea]
    list.sorting = {:oblea => 'ASC'}
    list.columns = [:nombre, :oblea, :debe]
    list.per_page = 50
    config.action_links.add 'export_csv', :label => 'Exportar a Excel', :page => true
    config.create.link.label = "Agregar"
    config.search.link.label = "Buscar"
    config.update.link.label = "Modificar"
    config.delete.link.label = "Borrar"
    config.show.link.label = "Ver Detalles"
  end

  def export_csv
    autos = Auto.find(:all, :order => "oblea ASC")
    return if autos.size == 0

    data = ""
    fecha = Date.today.strftime('%d/%m/%Y')
    data << "Fecha: #{fecha}" << "\r\n\r\n"
    autos.each do |auto|
      data << auto.to_csv << "\r\n"
    end

    send_data data, :type => 'text/csv', :filename => "Remisses.xls"
  end

  def pagado
    auto = Auto.find(params[:id])
    cantidad = auto.no_pagados.size
    auto.no_pagados.each do |trabajo|
      trabajo.update_attribute(:pagado, true)
    end
    flash[:notice] = "#{cantidad} dia(s) fueron marcados como pagados. El remisse '#{auto.nombre_completo}' no debe mas nada"
    redirect_to :controller => 'autos'
  end

end