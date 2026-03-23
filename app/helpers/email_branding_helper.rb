module EmailBrandingHelper
  def branded_accent_color(branding)
    branding&.accent_color.presence || "#0066cc"
  end

  def branded_font_family(branding)
    branding&.font_family.presence || "Arial"
  end

  def branded_from_name(branding, book)
    branding&.from_name.presence || book.title
  end

  def email_safe_font_stack(font_family)
    case font_family
    when "Georgia" then "Georgia, serif"
    when "Verdana" then "Verdana, Geneva, sans-serif"
    when "Trebuchet MS" then "'Trebuchet MS', Helvetica, sans-serif"
    when "Helvetica" then "Helvetica, Arial, sans-serif"
    when "Times New Roman" then "'Times New Roman', Times, serif"
    when "Courier New" then "'Courier New', Courier, monospace"
    else "Arial, Helvetica, sans-serif"
    end
  end
end
