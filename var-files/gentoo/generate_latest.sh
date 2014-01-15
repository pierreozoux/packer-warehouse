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

  echo $file " " $sha512
}

iso=`curl -s $uri/latest-install-$build_arch-minimal.txt | grep -v "^#"`

iso_dl=$(dl_and_verify $iso)
iso_file=$(echo $iso_dl | cut -d" " -f1)
iso_sha512=$(echo $iso_dl | cut -d" " -f2)

echo "Iso file downloaded and verified"

stage3=`curl -s $uri/latest-stage3-$build_proc.txt | grep -v "^#"`

stage3_dl=$(dl_and_verify $stage3)
stage3_file=$(echo $stage3_dl | cut -d" " -f1)

echo "Stage3 file downloaded and verified"
echo ""
echo "Please give your SYNC server"
echo "ex: rsync.fr.gentoo.org/gentoo-portage OR example.org/gentoo-rsync"
echo "If you don't know, leave it blank"
read SYNC_SERVER

if [ -z "$SYNC_SERVER" ]
then
  SYNC_SERVER="rsync.gentoo.org/gentoo-portage"
fi
  
cat <<DATAEOF > "var-files/gentoo/latest.json"
{
    "architecture": "$architecture",
    "guest_os_type": "$guest_os_type",
    "iso_url": "$iso_file",
    "iso_checksum": "$iso_sha512",
    "iso_checksum_type": "sha512",
    "timezone": "UTC",
    "sync_server": "$SYNC_SERVER",
    "stage3file": "${stage3_file##*/}"
}
DATAEOF

exit 0
