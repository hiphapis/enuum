module Enuum
  module View
    def enum_label(model, field, value=nil, label=nil, _options={})
      label_class = Enuum.configuration.label_class.to_sym
      content = model.send("#{field}_map")
      content = content[value.to_sym] if value.present?
      if content
        label ||= content[:name]
        i = content[:icon].present? ? "<i class='glyphicon glyphicon-#{content[:icon]}'></i> " : ''
        c = content[label_class].present? ? "label label-#{content[label_class]}" : ''
        content_tag(:span, "#{i}#{label}".html_safe, { class: c })
      end
    end
  end
end
