defmodule Levelup.Accounts.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :levelup,
    error_handler: Levelup.Accounts.ErrorHandler,
    module: Levelup.Accounts.Guardian

  # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
