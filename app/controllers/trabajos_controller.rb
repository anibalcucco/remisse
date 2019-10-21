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
    @trabajos = auto.trabajos_no_pagados
  end

  def create
    if fecha.blank?
      flash[:notice] = 'Por favor seleccione una fecha antes de cargar'
      autos
      render :action => 'new'
    else
      autos_que_trabajaron.each { |auto| register_trabajo(auto, fecha, autos_que_pagaron.include?(auto)) }
      flash[:notice] = 'La carga fue exitosa'
      redirect_to controller: :autos
    end
  end

  def update
    if trabajos_pagados.present?
      update_trabajos
      show_current_state
    else
      flash[:notice] = "No se seleccionaron dias pagados"
    end
    redirect_to controller: :autos
  end

  private

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

  def autos_que_trabajaron
    @autos_que_trabajaron ||= Auto.where(id: params[:trabajos] || [])
  end

  def autos_que_pagaron
    @autos_que_pagaron ||= Auto.where(id: params[:pagos] || [])
  end

  def trabajos_pagados
    @trabajos_pagados ||= Trabajo.where(id: params[:pagos] || [])
  end

  def fecha
    @fecha ||= params[:fecha]&.to_date
  end

  def autos
    @autos ||= Auto.all
  end

  def register_trabajo(auto, fecha, pagado)
    trabajo = auto.trabajos.detect { |trabajo| trabajo.fecha == fecha }
    if trabajo
      trabajo.update_attribute(:pagado, pagado)
    else
      auto.trabajos.create(:fecha => fecha, :pagado => pagado)
    end
  end

  def update_trabajos
    trabajos_pagados.each { |trabajo| trabajo.update_attribute(:pagado, true) }
  end

  def show_current_state
    no_pagados = auto.trabajos.no_pagados
    flash[:notice] = "#{trabajos_pagados.size} dia(s) fueron marcados como pagados. "
    if no_pagados.empty?
      flash[:notice] << "El remisse '#{auto.nombre_completo}' no debe mas nada"
    else
      flash[:notice] << "El remisse '#{auto.nombre_completo}' sigue debiendo #{no_pagados.size} dia(s)"
    end
  end
end
