class TrabajosController < ApplicationController

  before_filter :authenticate_user!
  before_filter :find_auto, :only => [ :bulk, :update ]
  before_filter :check_has_early_access_to_features, :only => [ :index ]

  TIMEZONE = 'Atlantic Time (Canada)'.freeze

  def index
    @trabajos_pagados_por_dia = Trabajo.pagados.group_by_day(:updated_at, options_for_group_by_day).count
  end

  def new
    @autos = Auto.find(:all, :order => 'oblea ASC')
  end

  def edit
    @trabajo = Trabajo.find(params[:id])
  end

  def bulk
    @trabajos = @auto.no_pagados
  end

  def create
    unless params[:fecha].blank?
      params[:trabajos].each do |auto_id|
        trabajo = Trabajo.find(:first, :conditions => ['fecha = ? AND auto_id = ?', params[:fecha].to_date, auto_id])
        if trabajo
          trabajo.update_attribute(:pagado, pagado?(auto_id))
        else
          Trabajo.create(:fecha => params[:fecha], :auto_id => auto_id, :pagado => pagado?(auto_id))
        end
      end if params[:trabajos]
      flash[:notice] = 'La carga fue exitosa'
      redirect_to :controller => 'autos'
    else
      flash[:notice] = 'Por favor seleccione una fecha antes de cargar'
      @autos = Auto.find(:all)
      render :action => 'new'
    end
  end

  def update
    if params[:pagos]
      params[:pagos].each do |trabajo_id|
        trabajo = Trabajo.find(trabajo_id)
        trabajo.update_attribute(:pagado, true)
      end
      no_pagados = @auto.no_pagados
      flash[:notice] = "#{params[:pagos].size} dia(s) fueron marcados como pagados. "
      if no_pagados.empty?
        flash[:notice] << "El remisse '#{@auto.nombre_completo}' no debe mas nada"
      else
        flash[:notice] << "El remisse '#{@auto.nombre_completo}' sigue debiendo #{no_pagados.size} dia(s)"
      end
    else
      flash[:notice] = "No se seleccionaron dias pagados"
    end
    redirect_to :controller => 'autos'
  end

  private

  def pagado?(auto_id)
    return false unless params[:pagos]
    params[:pagos].include?(auto_id)
  end

  def find_auto
    @auto = Auto.find(params[:auto_id])
  end

  def options_for_group_by_day
    {
      range: 2.weeks.ago.in_time_zone(TIMEZONE).beginning_of_day..Time.now,
      time_zone: TIMEZONE,
      format: '%d/%m/%Y',
      reverse: true
    }
  end

  def check_has_early_access_to_features
    redirect_to action: :new unless current_user.has_early_access_to_features?
  end

end
