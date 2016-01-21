# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: crenault <crenault@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2015/05/09 18:00:27 by crenault          #+#    #+#              #
#    Updated: 2016/01/21 15:59:44 by crenault         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# submodules
SUBMODCHECK =
SUBMODEXIST =

# libraries
LDFLAGSRAW =
LDFLAGS = $(addprefix -L, $(LDFLAGSRAW))
LDLIBSRAW =
LDLIBS = $(addprefix -l, $(LDLIBSRAW))

# compiler
CC = clang

# executable name
NAME = containers

# flags
FLAGS = -Wall -Wextra
# FLAGS += -Werror
FLAGS += -pedantic-errors
# FLAGS += -O3 -march=native
# FLAGS += -g
# FLAGS += -Wpadded
# FLAGS += -fprofile-arcs -ftest-coverage

# include variables
INCLUDERAW = include
INCLUDE = $(addprefix -I, $(INCLUDERAW))

# frameworks
FRAMEWORKSRAW =
FRAMEWORKS = $(addprefix -framework , $(FRAMEWORKSRAW))

# binary flags
CFLAGS = $(FLAGS) $(INCLUDE)

# to compile files
SRC = main.c

# paths of source files
SRCDIR = src
vpath %.c $(SRCDIR)

# objects variables
OBJDIR = obj
OBJ = $(SRC:%.c=$(OBJDIR)/%.o)

# dependencies variables
DEPDIR = dep
DEP = $(SRC:%.c=$(DEPDIR)/%.d)

# .o files are secondary
.SECONDARY: $(OBJ)

# force rules and not file
.PHONY: all clean fclean re

# main rule
all: $(SUBMODCHECK) $(SUBMODEXIST) $(DEP) $(NAME)

# include dependencies generated
-include $(DEP)

# color variables
GREEN = "\033[0;32m"
BROWN = "\033[0;33m"
BLUE = "\033[0;34m"
RED = "\033[0;31m"
NO_COLOUR = "\033[0m"

# making compiled files
$(OBJDIR)/%.o: %.c | $(OBJDIR)
	@echo $(GREEN)"creation of" $@"..."$(NO_COLOUR)
	@$(CC) $(CFLAGS) -c -o $@ $<

# making dependencies files
$(DEPDIR)/%.d: %.c $(SUBMODCHECK) $(SUBMODEXIST) | $(DEPDIR)
	@echo $(BROWN)"creation of" $< "dependencies..."$(NO_COLOUR)
	@$(CC) $(CFLAGS) -MM $< -MT $(OBJDIR)/$*.o -MF $@

# making objs dir
$(OBJDIR):
	@mkdir -p $@

# making dependencies dir
$(DEPDIR):
	@mkdir -p $@

$(NAME): $(OBJ)
	@$(CC) -o $@ $^ $(FLAGS) $(LDFLAGS) $(LDLIBS) $(FRAMEWORKS)
	@echo $(BLUE)"created" $@$(NO_COLOUR)

# clean object files
clean:
	@$(RM) -r $(OBJDIR)
	@echo $(RED)$@ "done!"$(NO_COLOUR)

# clean exec file
fclean: clean
	@$(RM) $(NAME)
	@echo $(RED)$@ "done!"$(NO_COLOUR)

# rebuild
re: fclean all

# submodule check
$(SUBMODCHECK):
	@git submodule init
	@git submodule update
	@echo $(GREEN)"updated" $@$(NO_COLOUR)
