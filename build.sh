#!/bin/bash

# need ovf tool for ova build!
# From https://developer.vmware.com/web/tool/ovf-tool/
if [ ! -d ovftool ]; then
	wget -N https://vdc-download.vmware.com/vmwb-repository/dcr-public/8a93ce23-4f88-4ae8-b067-ae174291e98f/c609234d-59f2-4758-a113-0ec5bbe4b120/VMware-ovftool-4.6.2-22220919-lin.x86_64.zip -O VMware-ovftool.zip
	unzip -q -o VMware-ovftool.zip
	echo VMware-ovftool.zip >.gitignore
	echo "ovftool" >>.gitignore
	echo "image" >>.gitignore
	echo "image-bundle" >>.gitignore
fi

# need to set the path to ovftool for kiwi build
export PATH=$PATH:/data/git/kiwi-image-micro-60/ovftool

# set variables
TARGET_DIR=.

# clean and recreate the build folder
rm -rf $TARGET_DIR/image
mkdir -p $TARGET_DIR/image

# build the image
kiwi-ng --profile x86-vmware system build --target-dir $TARGET_DIR/image --description $TARGET_DIR \
--add-repo http://susemanager.weiss.ddnss.de/pub/isos/slmicro60 \
--add-repo http://susemanager.weiss.ddnss.de/ks/dist/slmicro60-test,repo-md,SL-Micro-6.0-Test-Pool

#--add-repo http://susemanager.weiss.ddnss.de/ks/dist/child/staging-slmicro60-test-sle-micro-6.0-pool-x86_64/slmicro60-test,repo-md,SL-Micro-6.0-Test-Pool

#--add-repo http://susemanager.weiss.ddnss.de/ks/dist/child/staging-slemicro55-test-sle-manager-tools-for-micro5-pool-x86_64-5.5/slemicro55-test,repo-md,SLE-Manager-Tools-For-Micro5-Test-Pool \
#--add-repo http://susemanager.weiss.ddnss.de/ks/dist/child/staging-slemicro55-test-sle-manager-tools-for-micro5-updates-x86_64-5.5/slemicro55-test,repo-md,SLE-Manager-Tools-For-Micro5-Test-Updates

# create bundle
rm -rf $TARGET_DIR/image-bundle
mkdir -p $TARGET_DIR/image-bundle
kiwi-ng result bundle --target-dir $TARGET_DIR/image --bundle-dir=$TARGET_DIR/image-bundle --id=0
