ExUnit.start(trace: true, exclude: [:skip])

Ecto.Adapters.SQL.Sandbox.mode(Switch.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
