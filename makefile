# Nom de l'exécutable final
EXEC = exec

# Fichiers source
SRCS = codeC/main.c codeC/avl.c

# Fichiers objets générés
OBJS = $(SRCS:.c=.o)

# Compilateur et options de compilation
CC = gcc
CFLAGS = -Wall -Wextra -Werror -std=c11

# Règle principale
all: $(EXEC)

# Génération de l'exécutable
$(EXEC): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS)

# Compilation des fichiers .c en .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Nettoyage des fichiers générés
clean:
	rm -f $(OBJS)

# Nettoyage complet (y compris l'exécutable)
fclean: clean
	rm -f $(EXEC)

# Recompilation complète
re: fclean all