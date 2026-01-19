#!/bin/bash

# ==========================================================
#  InfinityX Build Script for Poco F6 Pro (vermeer)
# ==========================================================



# --- Remove old local manifests ---
rm -rf .repo/local_manifests
rm -rf .repo/manifests
rm -rf .repo/manifest.xml


# --- Remove Device Settings --- (Reason: It Will fail sync when we re run this script)
rm -rf packages/resources/devicesettings

# --- Init ROM repo ---
repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs --no-clone-bundle && \

# --- Sync ROM ---
#/opt/crave/resync.sh && \
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \

# --- Clone Device Tree ---
rm -rf device/xiaomi
git clone https://github.com/Tadassha/android_device_xiaomi_vermeer -b lineage-23.0 device/xiaomi/vermeer && \

# --- Clone Hardware Tree ---
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi -b lineage-23.0 hardware/xiaomi && \
#git clone https://github.com/Evolution-X-Devices/hardware_xiaomi -b bka hardware/xiaomi && \

# --- Clone Kernel Tree ---
rm -rf kernel/xiaomi/sm8550 kernel/xiaomi/sm8550-devicetrees kernel/xiaomi/sm8550-modules
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550 -b lineage-23.0 kernel/xiaomi/sm8550
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-devicetrees -b lineage-23.0 kernel/xiaomi/sm8550-devicetrees
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-modules -b lineage-23.0 kernel/xiaomi/sm8550-modules

# --- Clone Vendor Tree ---
rm -rf vendor/xiaomi
git clone https://github.com/xiaomi-8550/proprietary_vendor_xiaomi_vermeer -b beryl vendor/xiaomi/vermeer && \

# --- Device Settings ---
rm -rf packages/resources/devicesettings
https://github.com/LineageOS/android_packages_resources_devicesettings -b lineage-23.0 packages/resources/devicesettings && \

# =============================
#  Build: Vanilla → Gapps
# =============================

# --- Vanilla Build ---
echo "===== Starting Vanilla Build ====="
. build/envsetup.sh && \
breakfast vermeer user && \
make installclean && \
mka bacon

echo "===== All builds completed successfully! ====="
