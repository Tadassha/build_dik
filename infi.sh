#!/bin/bash

# ==========================================================
#  InfinityX Build Script for Poco F6 Pro (vermeer)
# =========================================================

# --- Remove old local manifests ---
rm -rf .repo/local_manifests
rm -rf .repo/manifests
rm -rf .repo/manifest.xml


# --- Remove Device Settings --- (Reason: It Will fail sync when we re run this script)
#rm -rf packages/resources/devicesettings

# --- Init ROM repo ---
repo init -u https://github.com/LineageOS/android.git -b lineage-23.1 --git-lfs --no-clone-bundle && \

# --- Sync ROM ---
/opt/crave/resync.sh && \
#repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \

# --- Clone Device Tree ---
rm -rf device/xiaomi
git clone https://github.com/Tadassha/android_device_xiaomi_vermeer -b lineage-23.1 device/xiaomi/vermeer && \

git clone https://github.com/LineageOS/android_device_xiaomi_sm8550-common -b lineage-23.1 device/xiaomi/sm8550-common && \

# --- Clone Hardware Tree ---
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi -b lineage-23.1 hardware/xiaomi && \

# --- Clone Kernel Tree ---
#rm -rf kernel/xiaomi/sm8550 kernel/xiaomi/sm8550-devicetrees kernel/xiaomi/sm8550-modules device/xiaomi/sm8550-common
#git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550 -b lineage-23.0 kernel/xiaomi/sm8550
#git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-devicetrees -b lineage-23.0 kernel/xiaomi/sm8550-devicetrees
#git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-modules -b lineage-23.0 kernel/xiaomi/sm8550-modules

# --- Clone Vendor Tree ---
rm -rf vendor/xiaomi
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_vermeer -b lineage-23.0 vendor/xiaomi/vermeer && \
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_sm8550-common -b lineage-23.0 vendor/xiaomi/sm8550-common && \

# =============================
#  Build: Vanilla → Gapps
# =============================

# --- Vanilla Build ---
echo "===== Starting Vanilla Build ====="

. build/envsetup.sh && \
breakfast vermeer userdebug && \
make installclean && \
mka bacon

echo "===== All builds completed successfully! ====="
