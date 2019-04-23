defprotocol Adminable do
  @moduledoc """
  Protocol for to capture how to build admin interfaces and which fields to allow to edit
  """
  @fallback_to_any true

  def source(schema)

  def readable_fields(schema)
  def editable_fields(schema)
  def index_fields(schema)

  def create_changeset(schema, data)

  def edit_changeset(schema, data)
end

defimpl Adminable, for: Any do
  def source(schema) do
    schema.__struct__.__schema__(:source)
  end

  def readable_fields(schema) do
    schema.__struct__.__schema__(:fields)
  end

  def editable_fields(schema) do
    schema.__struct__.__schema__(:fields) -- schema.__struct__.__schema__(:primary_key)
  end

  def index_fields(schema) do
    schema.__struct__.__schema__(:fields)
  end

  def create_changeset(schema, data) do
    Ecto.Changeset.cast(schema, data, editable_fields(schema))
  end

  def edit_changeset(schema, data) do
    Ecto.Changeset.cast(schema, data, editable_fields(schema))
  end
end
