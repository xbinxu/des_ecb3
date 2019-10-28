ifeq ($(ERTS_DIR),)
ERTS_DIR = $(shell erl -eval "io:format(\"~s/erts-~s~n\", [code:root_dir(), erlang:system_info(version)])" -s init stop -noshell)
ifeq ($(ERTS_DIR),)
   $(error Could not find the Erlang installation. Check to see that 'erl' is in your PATH or export ERTS_DIR)
endif
endif

ifeq ($(ERL_EI_INCLUDE_DIR),)
ERL_ROOT_DIR = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
ifeq ($(ERL_ROOT_DIR),)
   $(error Could not find the Erlang installation. Check to see that 'erl' is in your PATH)
endif
ERL_EI_INCLUDE_DIR = "$(ERL_ROOT_DIR)/usr/include"
ERL_EI_LIBDIR = "$(ERL_ROOT_DIR)/usr/lib"
endif

# Set Erlang-specific compile and linker flags
ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)
ERL_LDFLAGS ?= -L$(ERL_EI_LIBDIR)

LDFLAGS += -fPIC -shared
CFLAGS ?= -fPIC -O2 -Wall -Wextra -Wno-unused-parameter -Wno-unused-function -Wno-missing-field-initializers

ifeq ($(CROSSCOMPILE),)
ifeq ($(shell uname),Darwin)
LDFLAGS += -undefined dynamic_lookup
endif
endif

NIF = priv/des_ecb3.so

SOURCES = $(wildcard c_src/*.c)
OBJS = $(SOURCES:.c=.o)

all: priv $(NIF)

priv:
	mkdir -p priv

$(NIF): $(OBJS) 
	$(CC) $(ERL_LDFLAGS) $(LDFLAGS) -o $@ $(OBJS) 

%.o: %.c
	$(CC) -c $(ERL_CFLAGS) $(CFLAGS) -o $@ $< 

clean:
	$(RM) $(OBJS)
	$(RM) $(NIF)
