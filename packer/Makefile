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
	s3cmd --config=${S3CONFIG} --acl-public put build/*.box s3://boxes
	s3cmd --config=${S3CONFIG} --acl-public put build/*.json s3://boxes

centos-7-base: centos-7-base.box

centos-7-base.box: centos-7-base.json
	$(eval BOXNAME := centos-7-base)
	$(eval BOXVERSION := $(shell date +%Y%m%d-$(shell git rev-parse --short HEAD)))
	$(eval BOXFILENAME := build/$(BOXNAME)-$(BOXVERSION).box)
	mkdir -p build
	rm -rf output-virtualbox-iso
	packer build $(BOXNAME).json
	mv -f packer_virtualbox-iso_virtualbox.box $(BOXFILENAME)
	mv -f output-virtualbox-iso/*.ova $(BOXNAME).ova
	./manifest.py --update build/$(BOXNAME).json $(BOXFILENAME) $(BOXNAME) $(BOXVERSION) virtualbox https://vagrant.subversivedata.com/$(BOXFILENAME) --description "CentOS 7 Base"

centos-7-nginx: centos-7-nginx.box

centos-7-nginx.box: centos-7-base centos-7-nginx.json
	$(eval BOXNAME := centos-7-nginx)
	$(eval BOXVERSION := $(shell date +%Y%m%d-$(shell git rev-parse --short HEAD)))
	$(eval BOXFILENAME := build/$(BOXNAME)-$(BOXVERSION).box)
	mkdir -p build
	rm -rf output-virtualbox-ovf
	packer build $(BOXNAME).json
	mv -f packer_virtualbox-ovf_virtualbox.box $(BOXFILENAME)
	mv -f output-virtualbox-ovf/*.ova $(BOXNAME).ova
	./manifest.py --update build/$(BOXNAME).json $(BOXFILENAME) $(BOXNAME) $(BOXVERSION) virtualbox https://vagrant.subversivedata.com/$(BOXFILENAME) --description "CentOS 7 +Nginx"

centos7: centos-7-base centos-7-nginx
