#!/usr/bin/env bash

set -o errexit

SCRIPT_DIR=$(cd $(dirname $0) && pwd)
TS=$(date +%Y%m%dT%H%M%S)

main() {
  test -n "$HOME" || die '$HOME is empty'
  test -e "$HOME" || die '$HOME does not exist'

	select email in causton81@gmail.com cfauston@us.ibm.com; do
		cat > $SCRIPT_DIR/git-user <<EOF
[user]
  email = $email
  name = Christopher F. AUSTON
EOF

		break
	done

  if [ -e ~/.vimrc ]; then
    mv -v ~/.vimrc /tmp/vimrc.${TS}
  fi

  for dotfile in bashrc bash_aliases vim gitconfig git-user; do
    target=$SCRIPT_DIR/$dotfile
    link_name=$HOME/.$dotfile

    if [ ! -e $link_name ]; then
      # file doesn't exist
      ln -sv $target $link_name
    elif [ -L $link_name ]; then
      # check existing symlink
      curr_target=$(readlink $link_name)

      if [ "$curr_target" != "$target" ]; then
          unlink $link_name
          ln -sv $target $link_name
      fi
    else
      mv -v $link_name /tmp/${dotfile}.${TS}
      ln -sv $target $link_name
    fi
  done
}

die() {
  echo "$1"
  exit 1
}


main
