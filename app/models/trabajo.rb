class Trabajo < ActiveRecord::Base

  belongs_to :auto

  validates_uniqueness_of :fecha, :scope => :auto_id
  validates_presence_of :fecha

  attr_accessible :fecha, :auto_id, :pagado

  def fecha_formateada
    fecha.strftime('%d/%m/%y')
  end
  
  def to_s
    fecha_formateada
  end

end
