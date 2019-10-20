class Auto < ApplicationRecord
  has_many :trabajos, :dependent => :destroy

  # Load trabajos by default to improve performance in active_scaffold list
  default_scope { includes(:trabajos).order(oblea: :asc) }

  def debe
    return "No debe nada" if trabajos_no_pagados.empty?
    "Debe: #{trabajos_no_pagados.join(", ")}"
  end

  def nombre_completo
    "#{oblea} - #{nombre}"
  end

  # The header line lists the attribute names. ID is quoted to work
  # around an issue with Excel and CSV files that start with "ID".
  def self.csv_header
    "Remisse,Debe"
  end

  # Emit our attribute values as a line of CSVs
  def to_csv
    nombre_completo << " - " << debe
  end

  def to_s
    nombre_completo
  end

  # This is used in active_scaffold list.
  # Use loaded association to avoid N+1.
  def trabajos_no_pagados
    @no_pagados ||= trabajos.reject { |t| t.pagado? }
  end
end
