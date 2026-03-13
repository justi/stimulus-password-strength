# frozen_string_literal: true

module StimulusPasswordStrength
  module Helper
    def password_strength_field(form, attribute, **options)
      config = StimulusPasswordStrength.configuration

      placeholder = options.delete(:placeholder)
      hint = options.delete(:hint)
      label = options.delete(:label)
      required = options.delete(:required)
      autocomplete = options.delete(:autocomplete) || "new-password"
      requirements = normalize_requirements(options.delete(:requirements) || [])
      input_class = options.delete(:input_class) || config.input_class
      container_class = options.delete(:container_class) || config.container_class
      label_row_class = options.delete(:label_row_class) || config.label_row_class
      label_row_style = options.delete(:label_row_style) || config.label_row_style
      label_class = options.delete(:label_class) || config.label_class
      header_aux_class = options.delete(:header_aux_class) || config.header_aux_class
      header_aux_style = options.delete(:header_aux_style) || config.header_aux_style
      status_row_class = options.delete(:status_row_class) || config.status_row_class
      status_row_style = options.delete(:status_row_style) || config.status_row_style
      requirements_class = options.delete(:requirements_class) || config.requirements_class
      requirements_style = options.delete(:requirements_style) || config.requirements_style
      requirement_class = options.delete(:requirement_class) || config.requirement_class
      requirement_style = options.delete(:requirement_style) || config.requirement_style
      wrapper_style = options.delete(:wrapper_style) || config.wrapper_style
      toggle_class = options.delete(:toggle_class) || config.toggle_class
      toggle_style = options.delete(:toggle_style) || config.toggle_style
      bar_track_class = options.delete(:bar_track_class) || config.bar_track_class
      bar_track_style = options.delete(:bar_track_style) || config.bar_track_style
      bar_base_class = options.delete(:bar_base_class) || config.bar_base_class
      bar_style = options.delete(:bar_style) || config.bar_style
      text_base_class = options.delete(:text_base_class) || config.text_base_class
      text_style = options.delete(:text_style) || config.text_style
      hint_class = options.delete(:hint_class) || config.hint_class

      labels = i18n_labels(options.delete(:strength_labels) || {})
      toggle_labels = i18n_toggle_labels(options.delete(:toggle_labels) || {})

      render(
        "stimulus_password_strength/field",
        form: form,
        attribute: attribute,
        label: label,
        placeholder: placeholder,
        hint: hint,
        required: required,
        autocomplete: autocomplete,
        requirements: requirements,
        input_class: input_class,
        container_class: container_class,
        label_row_class: label_row_class,
        label_row_style: label_row_style,
        label_class: label_class,
        header_aux_class: header_aux_class,
        header_aux_style: header_aux_style,
        status_row_class: status_row_class,
        status_row_style: status_row_style,
        requirements_class: requirements_class,
        requirements_style: requirements_style,
        requirement_class: requirement_class,
        requirement_style: requirement_style,
        wrapper_style: wrapper_style,
        toggle_class: toggle_class,
        toggle_style: toggle_style,
        bar_track_class: bar_track_class,
        bar_track_style: bar_track_style,
        bar_base_class: bar_base_class,
        bar_style: bar_style,
        text_base_class: text_base_class,
        text_style: text_style,
        hint_class: hint_class,
        requirement_pending_style: config.requirement_pending_style,
        requirement_met_style: config.requirement_met_style,
        requirement_unmet_style: config.requirement_unmet_style,
        labels: labels,
        toggle_labels: toggle_labels,
        bar_colors: config.bar_colors,
        text_colors: config.text_colors
      )
    end

    private

    def i18n_labels(override_labels)
      {
        weak: override_labels[:weak] || I18n.t("stimulus_password_strength.weak", default: "Weak"),
        fair: override_labels[:fair] || I18n.t("stimulus_password_strength.fair", default: "Fair"),
        good: override_labels[:good] || I18n.t("stimulus_password_strength.good", default: "Good"),
        strong: override_labels[:strong] || I18n.t("stimulus_password_strength.strong", default: "Strong")
      }
    end

    def i18n_toggle_labels(override_labels)
      {
        show: override_labels[:show] || I18n.t("stimulus_password_strength.show", default: "Show"),
        hide: override_labels[:hide] || I18n.t("stimulus_password_strength.hide", default: "Hide")
      }
    end

    def normalize_requirements(raw_requirements)
      raw_requirements.map do |requirement|
        item = requirement.to_h.transform_keys(&:to_sym)
        rule = item.fetch(:rule).to_sym
        label = item.fetch(:label).to_s

        raise ArgumentError, "Requirement label must be present" if label.strip.empty?

        case rule
        when :min_length
          {
            rule: rule.to_s,
            value: Integer(item.fetch(:value)),
            label: label,
            remaining_singular: item[:remaining_singular].to_s,
            remaining_plural: item[:remaining_plural].to_s,
            met_label: item[:met_label].to_s
          }
        when :uppercase
          {
            rule: rule.to_s,
            value: "",
            label: label,
            remaining_singular: "",
            remaining_plural: "",
            met_label: item[:met_label].to_s
          }
        else
          raise ArgumentError, "Unsupported requirement rule: #{rule}"
        end
      end
    end
  end
end
