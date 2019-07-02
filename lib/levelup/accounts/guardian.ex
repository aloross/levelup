defmodule Levelup.Accounts.Guardian do
  use Guardian, otp_app: :levelup

  alias Levelup.Accounts

  def subject_for_token(credential, _claims) do
    {:ok, to_string(credential.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_credential!(id) do
      nil -> {:error, :resource_not_found}
      credential -> {:ok, credential}
    end
  end
end
