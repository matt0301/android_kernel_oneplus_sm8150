#!/bin/bash

# Kernel version configuration
KNAME="NeptuneKernel"
MIN_HEAD=$(git rev-parse HEAD)
VERSION="$(cat version)-$(date +%m.%d.%y)-$(echo ${MIN_HEAD:0:8})"
if [[ "${1}" == "k" ]] ; then
	ZIPNAME="${KNAME}-$(cat version)-KSu-$(echo $(date +%d.%m.%Y-%H%M))"
else
	ZIPNAME="${KNAME}-$(cat version)-$(echo $(date +%d.%m.%Y-%H%M))"
fi

export LOCALVERSION="-${KNAME}-$(echo "${VERSION}")"

# Never dirty compile
./clean.sh

# Build with kernel SU
if [[ "${1}" == "k" ]] ; then
	echo "Building with Kernel SU"
	patch -p1 < kernelsu.patch
	curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
fi

# Let's build
START=$(date +"%s")
./build.sh || exit 1

# Kernel Output
if [ -e arch/arm64/boot/Image.gz ] ; then
	echo
	echo "Building Kernel Package"
	echo
	rm $ZIPNAME.zip 2>/dev/null
	rm -rf kernelzip 2>/dev/null
	# Import Anykernel3 folder
	mkdir kernelzip
	cp -rp scripts/AnyKernel3/* kernelzip/
	find arch/arm64/boot/dts -name '*.dtb' -exec cat {} + > kernelzip/dtb
	cd kernelzip/
	7z a -mx9 $ZIPNAME-tmp.zip *
	7z a -mx0 $ZIPNAME-tmp.zip ../arch/arm64/boot/Image.gz
	zipalign -v 4 $ZIPNAME-tmp.zip ../$ZIPNAME.zip
	rm $ZIPNAME-tmp.zip
	cd ..
	ls -al $ZIPNAME.zip
fi

rm -rf KernelSU

# Show compilation time
END=$(date +"%s")
DIFF=$((END - START))
echo -e "Kernel compiled successfully in $((DIFF / 60)) minute(s) and $((DIFF % 60)) second(s)"
