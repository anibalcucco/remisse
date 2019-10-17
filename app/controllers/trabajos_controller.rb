class TrabajosController < ApplicationController
  before_action :authenticate_user!
  before_action :autos, :only => [:new]

  def index
    @trabajos_pagados_por_dia = Trabajo.pagados.group_by_day(:updated_at, options_for_group_by_day).count
  end

  def new
  end

  def edit
    @trabajo = Trabajo.find(params[:id])
  end

  def bulk
    @trabajos = auto.trabajos.no_pagados
  end

  def create
    unless fecha.blank?
      trabajos.each { |auto_id| create_or_update_trabajo(fecha, auto_id) }
      flash[:notice] = 'La carga fue exitosa'
      redirect_to :controller => 'autos'
    else
      flash[:notice] = 'Por favor seleccione una fecha antes de cargar'
      autos
      render :action => 'new'
    end
  end

  def update
    if pagos.present?
      pagos.each { |trabajo_id| mark_as_pagado(trabajo_id) }
      no_pagados = auto.trabajos.no_pagados
      flash[:notice] = "#{pagos.size} dia(s) fueron marcados como pagados. "
      if no_pagados.empty?
        flash[:notice] << "El remisse '#{auto.nombre_completo}' no debe mas nada"
      else
        flash[:notice] << "El remisse '#{auto.nombre_completo}' sigue debiendo #{no_pagados.size} dia(s)"
      end
    else
      flash[:notice] = "No se seleccionaron dias pagados"
    end
    redirect_to :controller => 'autos'
  end

  private

  def pagado?(auto_id)
    pagos.include?(auto_id)
  end

  def auto
    @auto ||= Auto.find(params[:auto_id])
  end

  def options_for_group_by_day
    {
      range: 2.weeks.ago.beginning_of_day..Time.now,
      format: '%A %d de %B',
      reverse: true
    }
  end

  def pagos
    params[:pagos] || []
  end

  def trabajos
    params[:trabajos] || []
  end

  def fecha
    params[:fecha]
  end

  def autos
    @autos ||= Auto.all
  end

  def create_or_update_trabajo(fecha, auto_id)
    trabajo = Trabajo.where(['fecha = ? AND auto_id = ?', fecha.to_date, auto_id]).first
    if trabajo
      trabajo.update_attribute(:pagado, pagado?(auto_id))
    else
      Trabajo.create(:fecha => fecha, :auto_id => auto_id, :pagado => pagado?(auto_id))
    end
  end

  def mark_as_pagado(trabajo_id)
    auto.trabajos.find(trabajo_id).update_attribute(:pagado, true)
  end
end
