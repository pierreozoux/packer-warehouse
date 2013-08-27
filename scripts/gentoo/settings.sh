#!/bin/bash -eux
# settings that will be shared between all scripts

if [ "$ARCHITECTURE" == "x86" ]; then
  build_arch="x86"
  build_proc="i686"
  kernel_architecture="x86"
  chost="i686-pc-linux-gnu"
elif [ "$ARCHITECTURE" == "amd64" ]; then
  build_arch="amd64"
  build_proc="amd64"
  kernel_architecture="x86_64"
  chost="x86_64-pc-linux-gnu"  
else
  exit 1
fi

nr_cpus=$(</proc/cpuinfo grep processor|wc -l)

cat <<DATAEOF > "/etc/profile.d/settings.sh"
#!/bin/bash -eux

# number of cpus in the host system (to speed up make and for kernel config)
export nr_cpus=$nr_cpus

export build_arch=$build_arch
export build_proc=$build_proc

# for grub
export kernel_architecture=$kernel_architecture

# for the compiler
export chost=$chost
DATAEOF
