defmodule PKCS7 do
  def pad(bin) when is_binary(bin), do: pad(bin, 8 - rem(byte_size(bin), 8))

  def pad(bin, 1), do: <<bin::binary, 1>>
  def pad(bin, 2), do: <<bin::binary, 2, 2>>
  def pad(bin, 3), do: <<bin::binary, 3, 3, 3>>
  def pad(bin, 4), do: <<bin::binary, 4, 4, 4, 4>>
  def pad(bin, 5), do: <<bin::binary, 5, 5, 5, 5, 5>>
  def pad(bin, 6), do: <<bin::binary, 6, 6, 6, 6, 6, 6>>
  def pad(bin, 7), do: <<bin::binary, 7, 7, 7, 7, 7, 7, 7>>
  def pad(bin, 8), do: <<bin::binary, 8, 8, 8, 8, 8, 8, 8, 8>>

  def unpad(<<>>), do: <<>>

  def unpad(bin) when is_binary(bin) do
    last = :binary.last(bin)
    size = byte_size(bin) - last
    rem_size = rem(size, 8)

    if rem_size == 0 and (last < 1 || last > 8) do
      # no padding
      bin
    else
      case bin do
        <<data::binary-size(size), 1>> when rem_size == 7 ->
          data

        <<data::binary-size(size), 2, 2>> when rem_size == 6 ->
          data

        <<data::binary-size(size), 3, 3, 3>> when rem_size == 5 ->
          data

        <<data::binary-size(size), 4, 4, 4, 4>> when rem_size == 4 ->
          data

        <<data::binary-size(size), 5, 5, 5, 5, 5>> when rem_size == 3 ->
          data

        <<data::binary-size(size), 6, 6, 6, 6, 6, 6>> when rem_size == 2 ->
          data

        <<data::binary-size(size), 7, 7, 7, 7, 7, 7, 7>> when rem_size == 1 ->
          data

        <<data::binary-size(size), 8, 8, 8, 8, 8, 8, 8, 8>> when rem_size == 0 ->
          data

        _ ->
          :erlang.error(:bad_padding)
      end
    end
  end
end
