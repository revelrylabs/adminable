defmodule Adminable.AdminView do
  @moduledoc false

  use Phoenix.View,
    root: "lib/adminable/templates",
    namespace: Adminable

  # Use all HTML functionality (forms, tags, etc)
  use Phoenix.HTML

  alias Adminable.Router.Helpers, as: Routes
  import Harmonium

  def index_fields(schema_module) do
    schema_module.fields()
  end

  def form_fields(changeset) do
    schema = changeset.data

    fields = schema.__struct__.fields() -- [:inserted_at, :updated_at]
    fields -- schema.__struct__.__schema__(:primary_key)
  end

  defdelegate field(form, schema_module, field, opts \\ []), to: Adminable.Field
end
