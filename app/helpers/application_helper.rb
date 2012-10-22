module ApplicationHelper

  def flash_div
    puts flash.inspect
    flash.collect { |k,v| "<div id=\"flash\" class=\"#{k}\">#{v}</div>" }.to_s
  end 

end
