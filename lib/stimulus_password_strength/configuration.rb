# frozen_string_literal: true

module StimulusPasswordStrength
  class Configuration
    attr_accessor :container_class,
                  :label_row_class,
                  :label_row_style,
                  :label_class,
                  :header_aux_class,
                  :header_aux_style,
                  :status_row_class,
                  :status_row_style,
                  :requirements_class,
                  :requirements_style,
                  :requirement_class,
                  :requirement_style,
                  :wrapper_style,
                  :input_class,
                  :toggle_class,
                  :toggle_style,
                  :bar_track_class,
                  :bar_track_style,
                  :bar_base_class,
                  :bar_style,
                  :text_base_class,
                  :text_style,
                  :hint_class,
                  :requirement_pending_style,
                  :requirement_met_style,
                  :requirement_unmet_style,
                  :bar_colors,
                  :text_colors

    def initialize
      @container_class = "space-y-1"
      @label_row_class = "flex items-end justify-between gap-3"
      @label_row_style = "display: flex; justify-content: space-between; align-items: flex-end; gap: 0.75rem;"
      @label_class = "block text-sm font-medium text-gray-700"
      @header_aux_class = "flex justify-end"
      @header_aux_style = "display: flex; justify-content: flex-end; align-items: center;"
      @status_row_class = "flex min-h-5 flex-row-reverse items-center justify-start gap-2"
      @status_row_style = "display: flex; flex-direction: row-reverse; align-items: center; justify-content: flex-start; gap: 0.5rem; min-height: 1rem;"
      @requirements_class = "flex justify-end gap-2"
      @requirements_style = "display: flex; justify-content: flex-end; align-items: center; gap: 0.5rem; min-height: 1rem;"
      @requirement_class = "text-xs text-right leading-tight"
      @requirement_style = "font-size: 0.75rem; line-height: 1rem; text-align: right;"
      @wrapper_style = "position: relative;"
      @input_class = "w-full rounded-xl border border-gray-300 px-4 py-3 pr-16 shadow-sm focus:border-blue-500 focus:ring-2 focus:ring-blue-200"
      @toggle_class = "absolute right-3 top-1/2 -translate-y-1/2 cursor-pointer text-xs font-medium text-gray-500 hover:text-gray-700"
      @toggle_style = "position: absolute; right: 0.75rem; top: 50%; transform: translateY(-50%); display: inline-flex; align-items: center; justify-content: center; padding: 0; border: 0; background: transparent; line-height: 0; z-index: 1;"
      @bar_track_class = "h-1.5 w-20 overflow-hidden rounded-full bg-gray-100"
      @bar_track_style = "height: 0.375rem; width: 5rem; overflow: hidden; border-radius: 9999px; background-color: #e5e7eb; visibility: hidden; flex-shrink: 0;"
      @bar_base_class = "h-full rounded-full transition-all duration-300"
      @bar_style = "display: block; height: 100%; border-radius: 9999px; visibility: hidden; transition: width 300ms ease, background-color 300ms ease;"
      @text_base_class = "text-xs"
      @text_style = "display: inline-block; width: 5.5rem; text-align: right; white-space: nowrap;"
      @hint_class = "mt-1 text-xs text-gray-500"
      @requirement_pending_style = "color: #6b7280;"
      @requirement_met_style = "color: #047857;"
      @requirement_unmet_style = "color: #b91c1c;"

      @bar_colors = {
        weak: "#f87171",
        fair: "#fbbf24",
        good: "#22c55e",
        strong: "#059669"
      }

      @text_colors = {
        weak: "#ef4444",
        fair: "#d97706",
        good: "#16a34a",
        strong: "#047857"
      }
    end
  end
end
