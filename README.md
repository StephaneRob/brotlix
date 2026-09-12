# Brotlix

Elixir bindings for [brotli](https://github.com/dropbox/brotli) decompression, backed by a
[Rustler](https://github.com/rusterlium/rustler) NIF using the [`brotli`](https://crates.io/crates/brotli)
Rust crate.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `brotlix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:brotlix, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
iex> Brotlix.decompress(<<11, 2, 128, 104, 101, 108, 108, 111, 3>>)
{:ok, "hello"}

iex> Brotlix.decompress!(<<11, 2, 128, 104, 101, 108, 108, 111, 3>>)
"hello"
```

`decompress/2` and `decompress!/2` accept an optional `max_output_size` (in bytes, default
10 MB) to cap how much decompressed data is produced, guarding against decompression bombs:

```elixir
iex> Brotlix.decompress(<<11, 2, 128, 104, 101, 108, 108, 111, 3>>, 2)
{:error, "payload exceeds maximum allowed size"}
```

The decompression NIF runs on a dirty CPU scheduler so large payloads don't block the BEAM's
regular schedulers.
