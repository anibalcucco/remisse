class Trabajo < ApplicationRecord
  belongs_to :auto

  scope :pagados, -> { where(pagado: true) }
  scope :no_pagados, -> { where(pagado: false) }

  validates_uniqueness_of :fecha, :scope => :auto_id
  validates_presence_of :fecha

  def fecha_formateada
    fecha.strftime('%d/%m/%y')
  end

  def to_s
    fecha_formateada
  end
end
