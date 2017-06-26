.PHONY: all clean install push push-s3
all:
	@echo "Targets:"
	@echo "  clean - delete images"
	@echo "  centos7 - all centos7 images"
	@echo "  centos-7-base - base CentOS 7 image"
	@echo "  centos-7-nginx - CentOS 7 w/nginx mainline"

clean:
	rm -rf build *.ova *.box

push:
	s3cmd --config=${S3CONFIG} --acl-public put *.ova s3://packer/ovas/
	s3cmd --config=${S3CONFIG} --acl-public put build/*.box s3://boxes
	s3cmd --config=${S3CONFIG} --acl-public put build/*.json s3://boxes

centos-7-base: build/centos-7-base.ova

build/centos-7-base.ova: centos-7-base.json
	$(eval BOXBASE := centos-7-base)
	$(eval BOXVERSION := $(shell date +%Y%m%d-$(shell git rev-parse --short HEAD)))
	$(eval BOXNAME := $(BOXBASE)-$(BOXVERSION))
	$(eval BOXFILENAME := build/$(BOXNAME).box)
	mkdir -p build
	rm -rf output-virtualbox-ovf
	echo $(shell cat VERSION)-$(shell git rev-parse --short HEAD) > boxversion
	packer build $(BOXBASE).json
	mv -f packer_virtualbox-iso_virtualbox.box $(BOXFILENAME)
	mv -f output-virtualbox-iso/*.ova $(BOXBASE).ova
	./manifest.py --update build/$(BOXBASE).json $(BOXFILENAME) https://vagrant.subversivedata.com/$(BOXBASE) $(shell cat VERSION) virtualbox https://vagrant.subversivedata.com/$(BOXNAME).box --description "CentOS 7 Base"
	rm -f boxversion

centos-7-nginx: build/centos-7-nginx.ova

build/centos-7-nginx.ova: centos-7-base centos-7-nginx.json
	$(eval BOXBASE := centos-7-nginx)
	$(eval BOXVERSION := $(shell date +%Y%m%d-$(shell git rev-parse --short HEAD)))
	$(eval BOXNAME := $(BOXBASE)-$(BOXVERSION))
	$(eval BOXFILENAME := build/$(BOXNAME).box)
	mkdir -p build
	rm -rf output-virtualbox-ovf
	echo $(shell cat VERSION)-$(shell git rev-parse --short HEAD) > boxversion
	packer build $(BOXBASE).json
	mv -f packer_virtualbox-ovf_virtualbox.box $(BOXFILENAME)
	mv -f output-virtualbox-ovf/*.ova $(BOXBASE).ova
	./manifest.py --update build/$(BOXBASE).json $(BOXFILENAME) https://vagrant.subversivedata.com/$(BOXBASE) $(shell cat VERSION) virtualbox https://vagrant.subversivedata.com/$(BOXNAME).box --description "CentOS 7 +Nginx"
	rm -f boxversion

centos7: centos-7-base centos-7-nginx
