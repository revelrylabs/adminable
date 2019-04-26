defmodule Adminable.Field do
  import Harmonium
  use Phoenix.HTML

  def field(form, schema_module, field, opts \\ []) do
    field_type = schema_module.__schema__(:type, field)
    field_html(form, field, field_type, opts)
  end

  defp field_html(form, field, :boolean, opts) do
    ~E"""
    <%= col do %>
      <%= single_checkbox(form, field, Keyword.merge([label: String.capitalize(to_string(field))], opts)) %>
    <% end %>
    """
  end

  defp field_html(form, field, number, opts) when number in [:integer, :float] do
    ~E"""
    <%= col do %>
      <%= number_input_stack(
          form,
          field,
          label: String.capitalize(to_string(field)),
          input: Keyword.merge([], opts))
      %>
    <% end %>
    """
  end

  defp field_html(form, field, _field_type, opts) do
    ~E"""
    <%= col do %>
      <%= text_input_stack(
          form,
          field,
          label: String.capitalize(to_string(field)),
          input: Keyword.merge([placeholder: String.capitalize(to_string(field))], opts))
      %>
    <% end %>
    """
  end
end
