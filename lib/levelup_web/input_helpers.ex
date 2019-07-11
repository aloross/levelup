defmodule LevelupWeb.InputHelpers do
  use Phoenix.HTML

  def input(form, field) do
    type = Phoenix.HTML.Form.input_type(form, field)
    wrapper_opts = [class: "form-group"]

    input_classes =
      if form.errors[field] do
        "form-control is-invalid"
      else
        "form-control"
      end

    input_opts = [class: input_classes]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field))
      input = apply(Phoenix.HTML.Form, type, [form, field, input_opts])

      error =
        content_tag :div, class: "invalid-feedback" do
          LevelupWeb.ErrorHelpers.error_tag(form, field)
        end

      [label, input, error]
    end
  end
end
