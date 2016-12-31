FILES=files
TMP=tmp
BIN=bin
SRC=src

TARGET=$(BIN)/main

OPTIONS += -std=c99 -Wall -Wextra -pedantic -Werror
OPTIONS += -I $(TMP)


SOURCE += main.c

TEMP_SOURCE += files.c
TEMP_HEADER += files.h


OBJECTS := $(SOURCE:.c=.o)
OBJECTS := $(addprefix tmp/,${OBJECTS})
SOURCE  := $(addprefix src/,${SOURCE})

TEMP_OBJECTS := $(TEMP_SOURCE:.c=.o)
TEMP_OBJECTS := $(addprefix tmp/,${TEMP_OBJECTS})
TEMP_SOURCE  := $(addprefix tmp/,${TEMP_SOURCE})
TEMP_HEADER  := $(addprefix tmp/,${TEMP_HEADER})
TEMP_SOURCE += $(TEMP_HEADER)

ABS_TMP :=  $(PWD)/$(TMP)



all: $(TARGET)

$(TARGET): $(OBJECTS) $(TEMP_OBJECTS) | $(BIN)
	gcc $(OPTIONS) $^ -o "$@"

$(TMP)/files.c $(TMP)/files.h: $(FILES) | $(TMP) recreate
	rm -f $(TMP)/files.c $(TMP)/files.h
	echo "#ifndef TEMP_FILES_H" >> "$(TMP)/files.h"
	echo "#define TEMP_FILES_H" >> "$(TMP)/files.h"
	cd $(FILES) && \
	find . -type f | while IFS= read -r file; do \
          ename="$$(printf '%s' "$$file" | sed 's/[^a-zA-Z0-9]/_/g')"; \
          printf 'extern unsigned char %s[];\n' "$$ename" >> "$(ABS_TMP)/files.h"; \
          printf 'extern unsigned int %s_len;\n' "$$ename" >> "$(ABS_TMP)/files.h"; \
          xxd -i "$$file" >> "$(ABS_TMP)/files.c"; \
        done
	echo "#endif" >> "$(TMP)/files.h"

$(TMP)/%.o: $(SRC)/%.c
	gcc $(OPTIONS) -c $^ -o $@

$(TMP)/%.o: $(TMP)/%.c
	gcc $(OPTIONS) -c $^ -o $@

$(OBJECTS): | $(TEMP_HEADER)

recreate:

$(TMP):
	mkdir $(TMP)

$(BIN):
	mkdir bin

clean:
	rm -f $(OBJECTS) $(TEMP_OBJECTS) $(TEMP_SOURCE) $(TARGET)
