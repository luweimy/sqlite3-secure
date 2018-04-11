TARGET     = bin/app
TARGET_DIR = $(dir ${TARGET})
OBJECT_DIR = obj/
LINK       = g++
CXX        = g++
CC         = gcc
CCFLAGS    = -g -Wall
CXXFLAGS   = -g -Wall -std=c++11
LINKFLAGS  = -g -Wall -std=c++11
OBJECT     = \
	$(OBJECT_DIR)main.o\
	$(OBJECT_DIR)sqlite3secure.o

$(shell test -d $(OBJECT_DIR) || mkdir -p $(OBJECT_DIR))

$(TARGET):$(OBJECT)
	test -d $(TARGET_DIR) || mkdir -p $(TARGET_DIR)
	$(LINK) $(LINKFLAGS) -o $(TARGET) $(OBJECT)

$(OBJECT_DIR)main.o:./main.cpp
	$(CXX) $(CXXFLAGS) -c -o $(OBJECT_DIR)main.o ./main.cpp
$(OBJECT_DIR)sqlite3secure.o:./sqlite3-secure/sqlite3secure.c
	$(CC) $(CCFLAGS) -c -o $(OBJECT_DIR)sqlite3secure.o ./sqlite3-secure/sqlite3secure.c

clean:
	rm $(OBJECT)
