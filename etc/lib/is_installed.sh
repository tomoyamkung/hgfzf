#!/bin/bash -eu

function is_installed() {
  type $1 > /dev/null 2>&1
  return $?
}
