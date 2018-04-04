namespace :cleanup do
  task :trabajos_pagados => :environment do
    Trabajo.where(pagado: true, updated_at: 1.year.ago..1.month.ago).delete_all
  end
end
