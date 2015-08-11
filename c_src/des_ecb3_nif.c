#include "erl_nif.h"
#include "tomcrypt.h"

#define uchar unsigned char

// There are four functions that may be called during the lifetime
// of a NIF. load, reload, upgrade, and unload. Any of these functions
// can be left unspecified by passing NULL to the ERL_NIF_INIT macro.
//
// NIFs are awesome.

// Return value of 0 indicates success.
// Docs: http://erlang.org/doc/man/erl_nif.html#load

static int
load(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
{
    return 0;
}

// Called when changing versions of the C code for a module's NIF
// implementation if I read the docs correctly.
//
// Return value of 0 indicates success.
// Docs: http://erlang.org/doc/man/erl_nif.html#upgrade

static int
upgrade(ErlNifEnv* env, void** priv, void** old_priv, ERL_NIF_TERM load_info)
{
    return 0;
}

// Called when the library is unloaded. Not called after a reload
// executes.
//
// No return value
// Docs: http://erlang.org/doc/man/erl_nif.html#load

static void
unload(ErlNifEnv* env, void* priv)
{
    return;
}

// The actual C implementation of an Erlang function.
//
// Docs: http://erlang.org/doc/man/erl_nif.html#ErlNifFunc


static ERL_NIF_TERM
block_encrypt(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    return enif_make_badarg(env);
}

static ERL_NIF_TERM
block_decrypt(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
	ErlNifBinary k;
	ErlNifBinary v;
	ERL_NIF_TERM r;

	uchar key[24];
	uchar cipher[8];
	uchar *plain;
	symmetric_key skey;

	int err;

	if (argc != 2 || !enif_inspect_binary(env, argv[0], &k) || k.size != 24
		          || !enif_inspect_binary(env, argv[1], &v) || v.size != 8)
	{	
		return enif_make_badarg(env);
	}

	memcpy(key, k.data, 24);
	memcpy(cipher, v.data, 8);
	plain = (uchar *)enif_make_new_binary(env, 8, &r);

	if ((err = des3_setup(key, 24, 0, &skey)) != CRYPT_OK) {
      return enif_make_badarg(env);
   	}

    des3_ecb_decrypt(cipher, plain, &skey);

	return r;
}


static ErlNifFunc nif_funcs[] = {
    {"block_encrypt", 2, block_encrypt},
    {"block_decrypt", 2, block_decrypt}
};

// Initialize this NIF library.
//
// Args: (MODULE, ErlNifFunc funcs[], load, reload, upgrade, unload)
// Docs: http://erlang.org/doc/man/erl_nif.html#ERL_NIF_INIT

ERL_NIF_INIT(Elixir.DesEcb3, nif_funcs, &load, NULL, &upgrade, &unload);