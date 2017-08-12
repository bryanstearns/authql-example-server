defmodule Authql.Auth.Session do
  use GenServer
  alias Authql.Auth.Session
  alias Authql.Auth.User
  alias Authql.Repo

  @token_valid_duration Timex.Duration.from_minutes(3) #days(14)
  @cleanup_interval Timex.Duration.from_minutes(1) #hours(1)

  defstruct user: nil, token: nil, expires_at: nil

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: :session])
  end

  def create(email, password, expires_at \\ nil) do
    GenServer.call(:session, {:create, email, password, expires_at})
  end

  def get(token) do
    GenServer.call(:session, {:get, token})
  end

  def delete(token) do
    GenServer.call(:session, {:delete, token})
  end

  def cleanup_expired_sessions! do
    send(:session, :cleanup_expired_sessions)
  end
  # ---

  def init([]) do
    prime_cleanup()
    {:ok, %{}}
  end

  def handle_call({:create, email, password, expires_at}, _from, state) do
    with {:ok, user} <- find_user(%{email: email, password: password}),
         expires_at = token_expiration(expires_at),
         token = make_token(user.id),
         new_session = %Session{user: user, token: token,
                                expires_at: expires_at},
         new_state = Map.put(state, token, new_session)
      do
        {:reply, {:ok, new_session}, new_state}
      else
        _ -> {:reply, {:error, :invalid}, state}
    end
  end

  def handle_call({:get, token}, _from, state) do
    case Map.get(state, token, :error) do
      :error ->
        {:reply, {:error, :not_found}, state}
      session ->
        if expired?(session) do
          {:reply, {:error, :expired}, state}
        else
          {:reply, {:ok, session}, state}
        end
    end
  end

  def handle_call({:delete, token}, _from, state) do
    case Map.pop(state, token) do
      {%Session{} = session, new_state} ->
        {:reply, {:ok, session}, new_state}
      _ ->
        {:reply, {:error, :not_found}, state}
    end
  end

  def handle_info(:cleanup_expired_sessions, state) do
    {:noreply, cleanup_expired_sessions(state)}
  end

  defp find_user(%{email: email, password: password}) do
    user = Repo.get_by(User, email: email)
    Comeonin.Bcrypt.check_pass(user, password)
  end

  defp make_token(user_id) do
    Phoenix.Token.sign(AuthqlWeb.Endpoint, Integer.to_string(user_id),
                       :crypto.strong_rand_bytes(32))
  end

  defp prime_cleanup() do
    Process.send_after(self(), :cleanup_expired_sessions,
      Timex.Duration.to_milliseconds(@cleanup_interval, truncate: true))
  end

  defp cleanup_expired_sessions(state) do
    now = Timex.now
    Enum.reduce(state, %{}, fn {token, session}, acc ->
      if Timex.before?(session.expires_at, now) do
        acc
      else
        Map.put(acc, token, session)
      end
    end)
  end

  defp token_expiration(nil), do: Timex.add(Timex.now, @token_valid_duration)
  defp token_expiration(expires_at), do: expires_at

  def expired?(%{expires_at: expires_at}) do
    Timex.before?(expires_at, Timex.now)
  end
end
