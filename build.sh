#!/bin/sh

set -xe

g++ -Wall -Wextra -Wno-missing-field-initializers \
    -ggdb                                         \
    -I./raylib-5.5_linux_amd64/include            \
    -o main main.cc                               \
    -L./raylib-5.5_linux_amd64/lib -lraylib       \
    -Wl,-rpath=./raylib-5.5_linux_amd64/lib
