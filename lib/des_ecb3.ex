defmodule DesEcb3 do
  require Logger

  @compile {:autoload, false}
  @on_load :load_nif
  @nif_file '#{:code.priv_dir(:des_ecb3)}/des_ecb3'

  def load_nif do
    case :erlang.load_nif(@nif_file, 0) do
      :ok -> :ok
      {:error, {:reload, _}} -> :ok
      {:error, reason} -> Logger.warn("Failed to load nif: #{inspect(reason)}")
    end
  end

  def nif_decrypt(key, cipher_text)
  def nif_decrypt(_, _), do: exit(:nif_library_not_loaded)

  def nif_encrypt(key, plain_text)
  def nif_encrypt(_, _), do: exit(:nif_library_not_loaded)

  def encrypt(key, plain_text) do
    nif_encrypt(key, plain_text |> PKCS7.pad())
  end

  def decrypt(key, cipher_text) do
    nif_decrypt(key, cipher_text) |> PKCS7.unpad()
  end
end
