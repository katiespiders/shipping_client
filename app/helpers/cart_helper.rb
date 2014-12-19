module CartHelper

  def show_options(rates_array)
    html = "<table class='table'>"
    rates_array.each do |rate|
      html += "<tr><td>#{rate[0]}</td><td>$#{Money.new(rate[1])}</td></tr>"
    end
    html += "</table>"
    html.html_safe
  end

end
