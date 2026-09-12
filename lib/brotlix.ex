defmodule Brotlix do
  use Rustler,
    otp_app: :brotlix,
    crate: :brotlix

  @default_max_output_size 10 * 1024 * 1024

  @doc """
  Decompress a binary using brotli

  `max_output_size` caps the decompressed size in bytes (default: #{@default_max_output_size}, 10 MB)

  ## Examples

      iex> Brotlix.decompress(<<11, 2, 128, 104, 101, 108, 108, 111, 3>>)
      {:ok, "hello"}
  """
  def decompress(binary, max_output_size \\ @default_max_output_size)
  def decompress(_binary, _max_output_size), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Decompress a binary using brotli, raising an error if the decompression fails

  see `decompress/2` for examples
  """
  def decompress!(binary, max_output_size \\ @default_max_output_size) do
    case decompress(binary, max_output_size) do
      {:ok, result} -> result
      {:error, reason} -> raise reason
    end
  end
end
