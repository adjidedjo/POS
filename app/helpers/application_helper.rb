module ApplicationHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-info btn-xs", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def link_to_add_a(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields btn btn-info btn-xs", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def currency(price)
    number_to_currency(price, precision:0, unit: "Rp. ", separator: ".", delimiter: ".")
  end
end