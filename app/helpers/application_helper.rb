module ApplicationHelper
  include Pagy::Frontend

  def nav_link(label, path, &block)
    active = current_page?(path)
    classes = if active
      "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium bg-indigo-600 text-white"
    else
      "flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium text-gray-300 hover:bg-gray-700/60 hover:text-white transition-colors"
    end

    link_to path, class: classes do
      block ? capture(&block) : label
    end
  end

  def flash_class(type)
    case type.to_s
    when "notice", "success" then "bg-green-100 text-green-800 border border-green-200"
    when "alert", "error"    then "bg-red-100 text-red-800 border border-red-200"
    when "warning"           then "bg-yellow-100 text-yellow-800 border border-yellow-200"
    else                          "bg-blue-100 text-blue-800 border border-blue-200"
    end
  end

  def belt_badge(belt)
    colors = {
      "white"  => "bg-gray-100 text-gray-800",
      "blue"   => "bg-blue-100 text-blue-800",
      "purple" => "bg-purple-100 text-purple-800",
      "brown"  => "bg-amber-100 text-amber-900",
      "black"  => "bg-gray-900 text-white"
    }
    label = I18n.t("enums.student.belt.#{belt}", default: belt.to_s.capitalize)
    css   = colors.fetch(belt.to_s, "bg-gray-100 text-gray-700")
    content_tag(:span, label, class: "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium #{css}")
  end

  def status_badge(status)
    colors = {
      "active"    => "bg-green-100 text-green-800",
      "inactive"  => "bg-gray-100 text-gray-600",
      "suspended" => "bg-red-100 text-red-800",
      "paid"      => "bg-green-100 text-green-800",
      "pending"   => "bg-yellow-100 text-yellow-800",
      "overdue"   => "bg-red-100 text-red-800",
      "cancelled" => "bg-gray-100 text-gray-600"
    }
    label = I18n.t("enums.status.#{status}", default: status.to_s.capitalize)
    css   = colors.fetch(status.to_s, "bg-gray-100 text-gray-700")
    content_tag(:span, label, class: "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium #{css}")
  end

  def currency(value)
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".")
  end
end
