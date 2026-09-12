extern crate brotli;
use rustler::{Binary, Encoder, Env, NifResult, OwnedBinary, Term};
use std::io::Read;

fn to_binary_term<'a>(env: Env<'a>, bytes: &[u8]) -> NifResult<Term<'a>> {
    let mut binary = match OwnedBinary::new(bytes.len()) {
        Some(binary) => binary,
        None => return Ok((rustler::types::atom::error(), "failed to allocate output").encode(env)),
    };
    binary.as_mut_slice().copy_from_slice(bytes);
    Ok((rustler::types::atom::ok(), binary.release(env)).encode(env))
}

fn read_bounded<R: Read>(mut reader: R, max_size: usize) -> Result<Vec<u8>, &'static str> {
    let mut out = Vec::new();
    let mut chunk = [0u8; 8192];

    loop {
        let n = reader
            .read(&mut chunk)
            .map_err(|_| "error reading payload")?;
        if n == 0 {
            return Ok(out);
        }
        if out.len() + n > max_size {
            return Err("payload exceeds maximum allowed size");
        }
        out.extend_from_slice(&chunk[..n]);
    }
}

#[rustler::nif(schedule = "DirtyCpu")]
fn decompress<'a>(env: Env<'a>, input: Binary, max_size: usize) -> NifResult<Term<'a>> {
    let decompressor = brotli::Decompressor::new(input.as_slice(), 4096);

    match read_bounded(decompressor, max_size) {
        Ok(decompress_bytes) => to_binary_term(env, &decompress_bytes),
        Err(reason) => Ok((rustler::types::atom::error(), reason).encode(env)),
    }
}

rustler::init!("Elixir.Brotlix");
