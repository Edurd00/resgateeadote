module ApplicationHelper
  def localized_animal_age(age)
    match = age.to_s.match(/\A\s*(\d+)\s+(dia|semana|m[eê]s|ano)s?\b/i)
    return age unless match

    quantity = match[1].to_i
    unit = match[2].downcase
    singular, plural = case unit
    when "dia" then ["dia", "dias"]
    when "semana" then ["semana", "semanas"]
    when "mês", "mes" then ["mês", "meses"]
    when "ano" then ["ano", "anos"]
    end

    age.sub(match[0], "#{match[1]} #{quantity == 1 ? singular : plural}")
  end
end
