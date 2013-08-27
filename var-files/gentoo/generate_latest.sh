#!/bin/bash

echo "Please tell which architecture you want to generate the variables (x86/amd64):"
read architecture

if [ "$architecture" == "x86" ]; then
  build_arch="x86"
  build_proc="i686"
  guest_os_type="Gentoo"
elif [ "$architecture" == "amd64" ]; then
  build_arch="amd64"
  build_proc="amd64"
  guest_os_type="Gentoo_64"

else
  echo "Meuh, architecture not recognized yet... Please retry"
  exit 1
fi

uri="http://distfiles.gentoo.org/releases/$build_arch/autobuilds"

function dl_and_verify {
  if [ ! -d "./http/gentoo" ]; then
    mkdir ./http/gentoo
  fi
  
  file="./http/gentoo/${1##*/}"

  sha512=`wget -q $uri/$1.DIGESTS -O - | grep ${1##*/} | head -n 1 | cut -f 1 -d " "`
  
  if [ ! -f $file ]; then
    wget -O $file $uri/$1
  fi

  sha512_file=`openssl dgst -sha512 $file | cut -f2 -d " "`

  if [ ! "$sha512" = "$sha512_file" ]; then
    echo "The checksum failed for $1.."
    rm $file
    echo "We just removed the failing file, Please rerun this script!"
    exit 1
  fi

  echo $file
}

iso=`curl -s $uri/latest-install-$build_arch-minimal.txt | grep -v "^#"`

iso_file=$(dl_and_verify $iso)
echo "Iso file downloaded and verified"
iso_md5=`md5sum $iso_file | cut -f1 -d" "`

stage3=`curl -s $uri/latest-stage3-$build_proc.txt | grep -v "^#"`

stage3_file=$(dl_and_verify $stage3)
echo "Stage3 file downloaded and verified"

echo "Please tell the country SYNC server (ex: .fr OR .pt OR .us):"
echo "If you don't know, leave it blank"
read country_sync_server

cat <<DATAEOF > "var-files/gentoo/latest.json"
{
    "architecture": "$architecture",
    "guest_os_type": "$guest_os_type",
    "iso_url": "$iso_file",
    "iso_checksum": "$iso_md5",
    "iso_checksum_type": "md5",
    "timezone": "UTC",
    "country_sync_server": "$country_sync_server",
    "stage3file": "${stage3_file##*/}"
}
DATAEOF

exit 0
