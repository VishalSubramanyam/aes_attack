#!/usr/bin/env bash
# Run this once to set up directory structure

for i in {0..15}
do
	mkdir -p byte${i}/cacheLineSize128
	mkdir -p byte${i}/cacheLineSize64
done
