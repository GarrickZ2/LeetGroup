module CardHelper
  def check_title_empty(title)
    if title.empty?
      return false
    else
      return true
    end
  end

  def check_title_length(title)
    if title.size > 50
      return false
    else
      return true
    end
  end

  def check_source_length(source)
    if source.size > 100
      return false
    else
      return true
    end
  end

  def check_description_length(description)
    if description.size > 300
      return false
    else
      return true
    end
  end
end