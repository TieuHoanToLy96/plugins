defmodule Api.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def up do
    create table(:accounts, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :string)
      add(:phone_number, :string)
      add(:avatar, :string)
      add(:locale, :string)
      add(:pancakeid_handle, :string)
      add(:status, :integer)
      add(:settings, :map, default: %{})

      timestamps()
    end

    create table(:sessions, primary_key: false) do
       add(:id, :binary_id, primary_key: true)
      add(:data, :map)
      add(:ip, :string)
      add(:user_agent, :string)

      timestamps()
    end
  end
end
