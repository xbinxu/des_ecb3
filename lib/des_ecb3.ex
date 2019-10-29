defmodule DesEcb3 do
  require Logger

  @compile {:autoload, false}
  @on_load :load_nif

  @spec load_nif :: :ok | {:error, any}
  def load_nif do
    case :erlang.load_nif('#{:code.priv_dir(:des_ecb3)}/des_ecb3', 0) do
      :ok -> :ok
      {:error, {:reload, _}} -> :ok
      {:error, reason} -> Logger.warn("Failed to load nif: #{inspect(reason)}")
    end
  end

  @spec nif_decrypt(binary, binary) :: binary
  def nif_decrypt(key, cipher_text)
  def nif_decrypt(_, _), do: :erlang.nif_error(:nif_not_loaded)

  @spec nif_encrypt(binary, binary) :: binary
  def nif_encrypt(key, plain_text)
  def nif_encrypt(_, _), do: :erlang.nif_error(:nif_not_loaded)

  @spec encrypt(binary, binary) :: binary
  def encrypt(key, plain_text) do
    nif_encrypt(key, plain_text |> PKCS7.pad())
  end

  @spec decrypt(binary, binary) :: binary
  def decrypt(key, cipher_text) do
    nif_decrypt(key, cipher_text) |> PKCS7.unpad()
  end
end
