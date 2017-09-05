module BodyHelper

  def body_tag(options = {}, &block)
    css_classes = [
      controller.controller_name,
      "#{current_layout}-layout",
      "#{current_layout}_layout",
      @navable.try(:class).try(:name).try(:parameterize),
      ("demo_mode" if demo_mode?),
      ("ios" if params[:app] == "ios"),
      options[:class]
    ]
    data = {
      locale: I18n.locale,
      env: Rails.env.to_s,
      layout: current_layout,
      navable: @navable.try(:to_global_id).try(:to_s),
      tab: current_tab
    }
    content_tag :body, class: css_classes.join(" "), data: data do
      (content_tag(:div, id: 'vue-app') { yield })
    end
  end

end