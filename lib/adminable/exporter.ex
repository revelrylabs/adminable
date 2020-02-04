defmodule Adminable.Exporter do
  @moduledoc """
  Exports templates and a view module.
  This allows for apps that use Adminable to modify templates
  to their liking.
  """

  template_paths = "lib/adminable/templates/admin/**/*.html.eex" |> Path.wildcard() |> Enum.sort()

  templates =
    for template_path <- template_paths do
      @external_resource Path.relative_to_cwd(template_path)
      {Path.basename(template_path), File.read!(template_path)}
    end

  @templates templates

  def list_templates do
    @templates
  end

  def view_module(web_module) do
    """
    defmodule #{inspect web_module}.Adminable.AdminView do
      use #{inspect web_module}, :view
      use Adminable.ViewHelpers
    end
    """
  end

  def templates_path(web_module) do
    Path.join(web_module_path(web_module), "templates")
  end

  def views_path(web_module) do
    Path.join(web_module_path(web_module), "views")
  end

  defp web_module_path(web_module) do
    name = Phoenix.Naming.underscore(web_module)
    Path.join(["lib", name])
  end

  def export(web_module) do
    templates_path = templates_path(web_module)
    views_path = views_path(web_module)

    view_module = view_module(web_module)
    templates = list_templates()

    exported_view_module_path = Path.join([views_path, "adminable", "admin_view.ex"])
    File.mkdir_p!(Path.dirname(exported_view_module_path))
    File.write!(exported_view_module_path, view_module)

    exported_templates_path = Path.join([templates_path, "adminable", "admin"])
    File.mkdir_p!(exported_templates_path)
    Enum.each(templates, fn({name, data}) ->
      File.write!(Path.join(exported_templates_path, name), data)
    end)
  end
end
