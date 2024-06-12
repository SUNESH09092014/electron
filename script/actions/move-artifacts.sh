#!/bin/sh

set -eo pipefail

if [ "`uname`" == "Darwin" ]; then
  if [ -z "$MAS_BUILD" ]; then
    BUILD_TYPE="darwin"
  else
    BUILD_TYPE="mas"
  fi
elif [ "`uname`" == "Linux" ]; then
  BUILD_TYPE="linux"
fi

echo Creating generated_artifacts_${BUILD_TYPE}_${TARGET_ARCH}...
rm -rf generated_artifacts_${BUILD_TYPE}_${TARGET_ARCH}
mkdir generated_artifacts_${BUILD_TYPE}_${TARGET_ARCH}

mv_if_exist() {
  if [ -f "$1" ] || [ -d "$1" ]; then
    echo Storing $1
    mv $1 generated_artifacts_${BUILD_TYPE}_${TARGET_ARCH}
  else
    echo Skipping $1 - It is not present on disk
  fi
}

cp_if_exist() {
  if [ -f "$1" ] || [ -d "$1" ]; then
    echo Storing $1
    cp $1 generated_artifacts_${BUILD_TYPE}_${TARGET_ARCH}
  else
    echo Skipping $1 - It is not present on disk
  fi
}

tar_if_exist() {
  for dir in \
    src/out/Default/gen/node_headers \
    src/out/Default/overlapped-checker \
    src/out/Default/ffmpeg \
    src/out/Default/hunspell_dictionaries \
    src/electron \
    src/third_party/electron_node \
    src/third_party/nan \
    src/cross-arch-snapshots \
    src/third_party/llvm-build \
    src/build/linux \
    src/buildtools/mac \
    src/buildtools/third_party/libc++ \
    src/buildtools/third_party/libc++abi \
    src/third_party/libc++ \
    src/third_party/libc++abi \
    src/out/Default/obj/buildtools/third_party \
    src/v8/tools/builtins-pgo
  do
    if [ -d "$dir" ]; then
      tar -czf $1 "$dir"
    fi
  done

  mv_if_exist $1
}

# Generated Artifacts
mv_if_exist src/out/Default/dist.zip
mv_if_exist src/out/Default/gen/node_headers.tar.gz
mv_if_exist src/out/Default/symbols.zip
mv_if_exist src/out/Default/mksnapshot.zip
mv_if_exist src/out/Default/chromedriver.zip
mv_if_exist src/out/ffmpeg/ffmpeg.zip
mv_if_exist src/out/Default/hunspell_dictionaries.zip
mv_if_exist src/cross-arch-snapshots
cp_if_exist src/out/electron_ninja_log
cp_if_exist src/out/Default/.ninja_log

tar_if_exist build_artifacts.tar.gz

