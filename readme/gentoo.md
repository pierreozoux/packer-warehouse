# Before packing your box

You must run `var-files/gentoo/generate_latest.sh` to generate the `latest.json` and download the iso/stage3 files.

and then run the following:

````bash
packer build \
  -var-file=var-files/gentoo/latest.json \
  gentoo.json
````

# Explanations of variables :

These are the variables used in the template, do not hesitate to modify them in the json file!

## architecture
amd64 or x86

## guest_os_type
Gentoo_64 or Gentoo

## timezone
timezone (as a subdirectory of /usr/share/zoneinfo)

implementation --> base.sh:80

"timezone": "Europe/Lisbon"

## country_sync_server
choose your SYNC server regarding your country
check this page for more details http://www.gentoo.org/main/en/mirrors-rsync.xml
if empty, it will default to the default gentoo rotation

implementation --> base.sh:91

"country_sync_server": ".us" # for example

"country_sync_server": ".fr" # for another example

## search_fastest_mirror 
find the 3 fastest GENTOO_MIRRORS 
if set to TRUE, it will download packets from all the mirrors and find the 3 fastest (add 15mins to the build)

implementation --> base.sh:96

(true or false)
