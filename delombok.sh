#!/bin/bash

# delombok if necessary
if git grep -q "^import lombok" '*.java'; then
  # download lombok
  curl https://projectlombok.org/downloads/lombok.jar -o "$GITHUB_WORKSPACE/lombok.jar"

  function mergeDelombok {
    DIFF=$(diff -Z -w -b -B --unified=200000 --minimal "$GITHUB_WORKSPACE/$1" "$1")
    if [ $? -ne 0 ]; then
     echo "Ran delombok on $1"
     echo "$DIFF" | sed 's/^ //g' |sed 's/^-.*$//g' | sed -r 's#\+(.*)//(.*)$#\1/*\2/**/#g' |sed ':a;N;$!ba;s/\n+/ /g' | tail -n +3 | grep -v '\ No newline at end of file' > "$GITHUB_WORKSPACE/$1"
    fi
  }
  export -f mergeDelombok

  java -jar "$GITHUB_WORKSPACE/lombok.jar" delombok -f suppressWarnings:skip -f generated:skip -f generateDelombokComment:skip -n --onlyChanged -v . -d "$GITHUB_WORKSPACE/delombok"
  pushd "$GITHUB_WORKSPACE/delombok"
  find . -name '*.java' -exec bash -c 'mergeDelombok "{}"' \;
  popd
fi
