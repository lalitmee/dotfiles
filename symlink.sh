#!/bin/bash

dest=$1
fileName=$2

function linkDotfile {
	# second argument will be the file name
	# first argument will be the destination of the file from which
	# I need to create symlink

  if [ -h ${fileName} ]; then
    # Existing symlink
    echo "Removing existing symlink: ${fileName}"
    rm ${fileName}

  elif [ -f "${fileName}" ]; then
    # Existing file
    echo "Removing existing file: ${fileName}"
    rm ${fileName}
  fi

  echo "Creating new symlink: ${fileName}"
  ln -s ${dest} ${fileName}
}

if [ -n ${dest} ] && [ -n ${fileName} ]; then
	linkDotfile ${dest} ${fileName}
else
    echo "argument error"
fi
