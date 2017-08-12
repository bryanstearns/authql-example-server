defmodule Authql.Auth do
  @moduledoc """
  The Auth context.
  """
  import Ecto.Query, warn: false
  alias Authql.Repo
  alias Authql.Auth.Session
  alias Authql.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Register a new user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Looks up a session by its token.

  Returns {:error, :not_found} if the token doesn't correspond to a session,
  or {:error, :expired} if it's too old (but hasn't been cleaned up yet)

  ## Examples

      iex> get_session("...")
      {:ok, %Session{}}

      iex> get_session("bogus")
      {:error, :not_found}

  """
  defdelegate get_session(token), to: Session, as: :get

  @doc """
  Is this token valid?

  ## Examples
      iex> token_valid?("...")
      true

      iex> token_valid?("bogus")
      false

  """
  def token_valid?(token) do
    case get_session(token) do
      {:ok, _session} -> true
      error -> false
    end
  end

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{email: valid, password: valid})
      {:ok, %Session{}}

      iex> create_session(%{email: bad_value, password: bad_value})
      {:error, :invalid}

  """
  def create_session(%{email: email, password: password}) do
    Session.create(email, password)
  end

  @doc """
  Deletes a Session; quietly ignores bogus tokens.

  ## Examples

      iex> delete_session(%{token: valid_token})
      :ok

      iex> delete_session(%{token: invalid_token})
      {:error, :not_found}

  """
  def delete_session(%{token: token}) do
    Session.delete(token)
  end
end
