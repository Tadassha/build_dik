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
repo init -u https://github.com/crdroidandroid/android.git -b 16.0 --git-lfs --no-clone-bundle && \

# --- Sync ROM ---
/opt/crave/resync.sh && \
#repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags && \

# --- Clone Device Tree ---
rm -rf device/xiaomi device/xiaomi/vermeer device/xiaomi/sm8550-common
git clone https://github.com/Tadassha/android_device_xiaomi_vermeer -b lineage-23.0 device/xiaomi/vermeer && \

git clone https://github.com/LineageOS/android_device_xiaomi_sm8550-common -b lineage-23.0 device/xiaomi/sm8550-common && \

# --- Clone Hardware Tree ---
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi -b lineage-23.0 hardware/xiaomi && \
#git clone https://github.com/Evolution-X-Devices/hardware_xiaomi -b bka hardware/xiaomi && \

# --- Clone Kernel Tree ---
rm -rf kernel/xiaomi/sm8550 kernel/xiaomi/sm8550-devicetrees kernel/xiaomi/sm8550-modules device/xiaomi/sm8550-common
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550 -b lineage-23.0 kernel/xiaomi/sm8550
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-devicetrees -b lineage-23.0 kernel/xiaomi/sm8550-devicetrees
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-modules -b lineage-23.0 kernel/xiaomi/sm8550-modules

# --- Clone Vendor Tree ---
rm -rf vendor/xiaomi vendor/xiaomi/sm8550-common vendor/xiaomi/vermeer
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_sm8550-common -b lineage-23.0 vendor/xiaomi/sm8550-common
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_vermeer -b lineage-23.0 vendor/xiaomi/vermeer

# -- addition ---
rm -rf hardware/qcom-caf/common vendor/qcom/opensource/dataipa hardware/qcom-caf/sm8550/audio hardware/qcom-caf/sm8550/media hardware/qcom-caf/sm8550/gps 
git clone https://github.com/LineageOS/android_hardware_qcom_audio -b lineage-23.0 hardware/qcom-caf/sm8550/audio
# just dont have last version for 8550
#git clone https://github.com/LineageOS/android_hardware_qcom_media -b lineage-22.0-caf-sm8550 hardware/qcom-caf/sm8550/media
git clone https://github.com/LineageOS/android_hardware_qcom_display -b  lineage-23.0-caf-sm8550 hardware/qcom-caf/sm8550/display
git clone https://github.com/LineageOS/android_hardware_qcom_gps -b lineage-23.0  hardware/qcom-caf/sm8550/gps
git clone https://github.com/LineageOS/android_vendor_qcom_opensource_dataipa -b lineage-23.0-caf-sm8550 vendor/qcom/opensource/dataipa
git clone https://github.com/LineageOS/android_vendor_qcom_opensource_display-commonsys-intf -b lineage-23.0 vendor/qcom/opensource/commonsys-intf/display
git clone https://github.com/LineageOS/android_hardware_qcom-caf_common -b lineage-23.0 hardware/qcom-caf/common



# --- Device Settings ---
#rm -rf packages/resources/devicesettings
#https://github.com/LineageOS/android_packages_resources_devicesettings -b lineage-23.0 packages/resources/devicesettings && \

# =============================
#  Build: Vanilla → Gapps
# =============================

echo "===== Preparing Trees for crDroid ====="
cd device/xiaomi/vermeer
[ -f lineage_vermeer.mk ] && mv lineage_vermeer.mk crdroid_vermeer.mk
sed -i 's/lineage_vermeer/crdroid_vermeer/g' crdroid_vermeer.mk
sed -i 's/vendor\/lineage/vendor\/crdroid/g' crdroid_vermeer.mk
cd ../../..

# --- Vanilla Build ---
echo "===== Starting Vanilla Build ====="

. build/envsetup.sh && \
breakfast vermeer userdebug && \
make installclean && \
mka bacon

echo "===== All builds completed successfully! ====="
