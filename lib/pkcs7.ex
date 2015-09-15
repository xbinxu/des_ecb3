defmodule PKCS7 do

  def unpad(<<>>), do: <<>>

  def unpad(bin) when is_binary(bin) do
    last = :binary.last(bin)
    size = byte_size(bin) - last
    rem_size = rem(size, 8)

    case bin do 
      << data :: binary-size(size), 1 >> when rem_size == 7 -> data
      << data :: binary-size(size), 2, 2 >> when rem_size == 6 -> data
      << data :: binary-size(size), 3, 3, 3 >> when rem_size == 5 -> data
      << data :: binary-size(size), 4, 4, 4, 4, >> when rem_size == 4 -> data
      << data :: binary-size(size), 5, 5, 5, 5, 5 >> when rem_size == 3 -> data
      << data :: binary-size(size), 6, 6, 6, 6, 6, 6 >> when rem_size == 2 -> data
      << data :: binary-size(size), 7, 7, 7, 7, 7, 7, 7 >> when rem_size == 1 -> data
      << data :: binary-size(size), 8, 8, 8, 8, 8, 8, 8, 8 >> when rem_size == 0 -> data
      _ -> 
        :erlang.error(:bad_padding)
    end
  end

end