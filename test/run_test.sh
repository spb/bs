#!/bin/bash

cd $(dirname $0)
rm -rf build intermediate
make
