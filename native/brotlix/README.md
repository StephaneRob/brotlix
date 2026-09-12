# NIF for Brotlix

Rust NIF implementation backing the `Brotlix` Elixir module. Decompresses brotli-encoded
binaries using the [`brotli`](https://crates.io/crates/brotli) crate.

## To build the NIF module:

- Your NIF will now build along with your project.

## Exposed NIF

```elixir
defmodule Brotlix do
  use Rustler, otp_app: :brotlix, crate: "brotlix"

  # When your NIF is loaded, it will override this function.
  def decompress(_binary, _max_output_size), do: :erlang.nif_error(:nif_not_loaded)
end
```

`decompress/2` takes the compressed binary and a `max_size` (in bytes) that bounds the
decompressed output, returning `{:ok, binary}` or `{:error, reason}`. It runs on a dirty
CPU scheduler (`schedule = "DirtyCpu"`) since decompression can be CPU-intensive.

## Examples

[This](https://github.com/rusterlium/NifIo) is a complete example of a NIF written in Rust.
