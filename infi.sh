#!/bin/bash

# ==========================================================
#  InfinityX Build Script for Poco F6 Pro (vermeer)
# ==========================================================

# Переменные для удобства
DEVICE="vermeer"
COMMON="sm8550-common"
ROM_BRANCH="16" # Android 16 (InfinityX)
LOS_BRANCH="lineage-23.1"

# --- Очистка старых манифестов ---
rm -rf .repo/local_manifests
rm -rf .repo/manifests
rm -rf .repo/manifest.xml

# --- Инициализация и Синхронизация ---
repo init -u https://github.com/Mi-Apollo/infinity_manifest.git -b $ROM_BRANCH --git-lfs

# Синхронизация (Crave resync быстрее, если доступен)
if [ -f /opt/crave/resync.sh ]; then
    /opt/crave/resync.sh
else
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
fi

# --- Клонирование Device Trees ---
rm -rf device/xiaomi/$DEVICE device/xiaomi/$COMMON
git clone https://github.com/LineageOS/android_device_xiaomi_$DEVICE -b $LOS_BRANCH device/xiaomi/$DEVICE
git clone https://github.com/LineageOS/android_device_xiaomi_$COMMON -b $LOS_BRANCH device/xiaomi/$COMMON

# --- Клонирование Vendor (Проприетарные либы) ---
rm -rf vendor/xiaomi/$DEVICE vendor/xiaomi/$COMMON
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_$DEVICE -b $LOS_BRANCH vendor/xiaomi/$DEVICE
git clone https://github.com/TheMuppets/proprietary_vendor_xiaomi_$COMMON -b $LOS_BRANCH vendor/xiaomi/$COMMON

# --- Клонирование Kernel (GKI Структура) ---
rm -rf kernel/xiaomi/sm8550 kernel/xiaomi/sm8550-devicetrees kernel/xiaomi/sm8550-modules
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550 -b $LOS_BRANCH kernel/xiaomi/sm8550
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-devicetrees -b $LOS_BRANCH kernel/xiaomi/sm8550-devicetrees
git clone https://github.com/LineageOS/android_kernel_xiaomi_sm8550-modules -b $LOS_BRANCH kernel/xiaomi/sm8550-modules

# --- Дополнительное железо и настройки ---
rm -rf hardware/xiaomi
git clone https://github.com/LineageOS/android_hardware_xiaomi -b $LOS_BRANCH hardware/xiaomi

rm -rf packages/resources/devicesettings
git clone https://github.com/LineageOS/android_packages_resources_devicesettings -b $LOS_BRANCH packages/resources/devicesettings

# --- Подготовка окружения ---
. build/envsetup.sh
export INFINITY_MAINTAINER="tadano"

# ==========================================================
#  SBORKA: Vanilla
# ==========================================================
echo "===== STARTING VANILLA BUILD ====="
export WITH_GAPPS=false
lunch infinity_$DEVICE-user
make installclean
m bacon

# Перемещаем билд в отдельную папку
mkdir -p out/final_output/vanilla
mv out/target/product/$DEVICE/InfinityX*.zip out/final_output/vanilla/

# ==========================================================
#  SBORKA: GApps
# ==========================================================
echo "===== STARTING GAPPS BUILD ====="
export WITH_GAPPS=true
# Clean нужен, чтобы GApps корректно вшились в образ
make installclean 
m bacon

mkdir -p out/final_output/gapps
mv out/target/product/$DEVICE/InfinityX*.zip out/final_output/gapps/

echo "===== ALL BUILDS FINISHED! CHECK out/final_output ====="
