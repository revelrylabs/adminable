defmodule Adminable.AdminView do
  @moduledoc false

  use Phoenix.View,
    root: "lib/adminable/templates",
    namespace: Adminable

  use Adminable.ViewHelpers
end
