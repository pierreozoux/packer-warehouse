# Packer-Warehouse

A warehouse to help you pack and ship your boxes!

Here, you'll find the templates you need for packer. Please do share your templates with others :)

## QuickStart - Build Ubuntu vagrant box

```bash
git clone https://github.com/pierreozoux/packer-warehouse.git
cd packer-warehosue
packer build \
  -var-file=var-files/ubuntu/13.04.json \
  ubuntu.json
```

## QuickStart2 - Build another box

1. read the `readme/distribtion.md` file
2. if there are steps needed, do them
3. adapt variables in the `var-files/ditribution/file.json`
4. adapt variables in `distribution.json`
5. check the scripts in `scripts/distribution/`
6. validate with `packer validate -var-file=var-files/ditribution/file.json distribution.json`
7. build with `packer build -var-file=var-files/ditribution/file.json distribution.json`

## Explanations of directory structure

### http

It contains files that your VM will require during the build. It will be served by your workstation thou a temporary http server. You can access this server in the boot_command via 2 variables `HTTPIP` and `HTTPPort`. Please have a look to the ubuntu template or [packer documentation](http://www.packer.io/docs/builders/virtualbox.html#toc_3) for more explanations.

### scripts

It contains the scripts used by the shell provisionner.

### var-files

It contains the json files needed to customise the different templates.

### readme

For each distribution, if the code is not enough, there is a little readme to explain how to work with!

## Contributing

1. Fork it
2. Create your recipe branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some features'`)
4. Push to the branch (`git push origin my-new-features`)
5. Create new Pull Request
