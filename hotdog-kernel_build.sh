git clone https://github.com/arminask/sm8150-mainline.git -b nabu-6.8 --depth 1 linux
cd linux
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- defconfig sm8150.config
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
_kernel_version="$(make kernelrelease -s)"
mkdir ../linux-oneplus-hotdog/boot
cp arch/arm64/boot/Image.gz ../linux-oneplus-hotdog/boot/vmlinuz-$_kernel_version
cp arch/arm64/boot/dts/qcom/sm8150-oneplus-hotdog.dtb ../linux-oneplus-hotdog/boot/dtb-$_kernel_version
sed -i "s/Version:.*/Version: ${_kernel_version}/" ../linux-oneplus-hotdog/DEBIAN/control
rm -rf ../linux-oneplus-hotdog/lib
make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=../linux-oneplus-hotdog modules_install
rm ../linux-oneplus-hotdog/lib/modules/**/build
cd ..
rm -rf linux

dpkg-deb --build --root-owner-group linux-oneplus-hotdog
dpkg-deb --build --root-owner-group firmware-oneplus-hotdog
#dpkg-deb --build --root-owner-group alsa-xiaomi-nabu
