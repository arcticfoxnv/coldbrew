.PHONY: all clean install push push-s3
all:
	@echo "Targets:"
	@echo "  clean - delete images"
	@echo "  centos7 - all centos7 images"
	@echo "  centos-7-base - base CentOS 7 image"
	@echo "  centos-7-nginx - CentOS 7 w/nginx mainline"

clean:
	rm -f *.box *.ova

push:
	s3cmd --config=${S3CONFIG} --acl-public put *.ova s3://packer/ovas/
	s3cmd --config=${S3CONFIG} --acl-public put *.box s3://boxes

centos-7-base: centos-7-base.box

centos-7-base.box: centos-7-base.json
	rm -rf output-virtualbox-iso
	packer build centos-7-base.json
	mv -f packer_virtualbox-iso_virtualbox.box centos-7-base.box
	mv -f output-virtualbox-iso/*.ova centos-7-base.ova

centos-7-nginx: centos-7-nginx.box

centos-7-nginx.box: centos-7-base centos-7-nginx.json
	rm -rf output-virtualbox-ovf
	packer build centos-7-nginx.json
	mv -f packer_virtualbox-ovf_virtualbox.box centos-7-nginx.box
	mv -f output-virtualbox-ovf/*.ova centos-7-nginx.ova

centos7: centos-7-base centos-7-nginx
