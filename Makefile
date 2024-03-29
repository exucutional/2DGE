CC = g++
ASM = nasm
LD = g++

LUA_DIR = lua-5.3.5/src
SFML_DIR= C:/SFML
SOL2_DIR = sol2/include
SFML_LIB_DIR= $(SFML_DIR)/lib
INCDIR = $(SFML_DIR)/include

CFLAGS = -c -std=c++17 -g -O3 -Wall -I$(INCDIR) -I$(LUA_DIR) -I$(SOL2_DIR)
AFLAGS = -f elf64	
LDFLAGS = -g -no-pie
SFML = -lsfml-graphics -lsfml-window -lsfml-system 

VPATH = ./src
OBJPATH = ./compile

SRCC = luaScript.cpp main.cpp game.cpp gameobjects.cpp animation.cpp gamestate.cpp	\
menustate.cpp collision.cpp interaction.cpp player.cpp map.cpp ai.cpp

HEAD = luaScript.hpp game.hpp assetmanager.hpp statemanager.hpp objectmanager.hpp	\
gameobjects.hpp animation.hpp state.hpp collision.hpp interaction.hpp player.hpp	\
vector_func.hpp map.hpp ai.hpp

SRCSASM =

OBJC = $(SRCC:%.cpp=$(OBJPATH)/%.o)
OBJASM = $(SRCASM:.S=.o)

EXECUTABLE_LINUX = run.out
EXECUTABLE_WINDOWS = run.exe

windows: luamake_mingw $(OBJPATH) $(SRCC) $(SRCASM) $(EXECUTABLE_WINDOWS)

linux: luamake_linux $(OBJPATH) $(SRCC) $(SRCASM) $(EXECUTABLE_LINUX)

luamake_linux:
	$(MAKE) -C lua-5.3.5 linux

luamake_mingw:
	$(MAKE) -C lua-5.3.5 mingw

$(OBJPATH):
	@mkdir $@

$(EXECUTABLE_WINDOWS): $(OBJC)
	@echo "LINKING:"
	$(LD) $(LDFLAGS) $(OBJC) -o  $@ -L$(SFML_LIB_DIR) $(SFML) -L$(LUA_DIR)  -llua

$(EXECUTABLE_LINUX): $(OBJC)
	@echo "LINKING:"
	$(LD) $(LDFLAGS) $(OBJC) -o  $@ $(SFML) -L$(LUA_DIR) -llua -ldl

$(OBJPATH)/%.o: %.cpp $(HEAD)
	@echo "COMPILING:"
	$(CC) $(CFLAGS) $< -o $@

%.o: %.S
	$(ASM) $(AFLAGS) $< -o $@