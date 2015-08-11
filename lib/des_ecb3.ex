defmodule DesEcb3 do

  @on_load {:init, 0}

  def init do
    path = :filename.join(:code.priv_dir(:des_ecb3), 'desecb3_nif')
    :ok = :erlang.load_nif(path, 0)
  end

  def block_decrypt(key, cipherText)
  def block_decrypt(_, _), do: exit(:nif_library_not_loaded)

  def block_encrypt(key, plainText)
  def block_encrypt(_, _), do: exit(:nif_library_not_loaded)

  def decrypt(key, cipherText) do 
    decrypt_block(key, cipherText, <<>>) |> PKCS7.unpad
  end

  defp decrypt_block(key, <<>>, result), do: result

  defp decrypt_block(key, << block :: binary-size(8), rest :: binary>>, result) do 
    plain_block = block_decrypt(key, block)
    decrypt_block(key, rest, << result :: binary, plain_block :: binary >>)
  end

end
