#!/bin/bash

echo "$1,$2,$3" | tr "," "\n" | sort -n
