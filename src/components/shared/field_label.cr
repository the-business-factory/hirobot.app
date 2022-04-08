class Shared::FieldLabel(T) < BaseComponent
  needs attribute : Avram::PermittedAttribute(T)
  needs label_text : String?

  def render
    label_for attribute, label_text, class: "block text-sm font-medium text-gray-200"
  end
end
