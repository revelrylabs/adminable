defmodule Mix.Tasks.Adminable.Gen.View do
  @shortdoc "Generates views and templates"

  @moduledoc """
  Generates views and templates so that they can be modifed.
      mix adminable.gen.view my_web_module

  ## Arguments
    * `my_web_module` - web_module to use for path and module names
  """
  use Mix.Task

  @impl true
  def run([web_module_string]) do
    web_module = Module.concat([web_module_string])
    Adminable.Exporter.export(web_module)
  end

  def run(_) do
    Mix.Shell.IO.error("Invalid args. Usage mix adminable.gen.view my_web_module")
    exit({:shutdown, 1})
  end
end
