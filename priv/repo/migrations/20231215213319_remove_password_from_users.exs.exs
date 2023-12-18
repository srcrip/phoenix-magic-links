defmodule Example.Repo.Migrations.RemovePasswordFromUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :hashed_password
    end
  end
end
