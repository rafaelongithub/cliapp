class StudyItem
  attr_reader :id, :id_category, :item_description

  def initialize(id, id_category, item_description)
    @id = id
    @id_category = id_category
    @item_description = item_description
    #@done = false
  end

  #def done?
  #  done
  #end

  # def done!
  #  done = true
  # end

  def to_s()
    "#{item_description} - #{id_category}"
  end
end
