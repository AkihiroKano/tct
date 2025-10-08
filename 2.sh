#!/bin/bash

# Сначала удаляем старые соединения чтобы избежать конфликтов
sudo nmcli con delete br0 2>/dev/null || true
sudo nmcli con delete static-enp0s8 2>/dev/null || true

# 1. Настройка физического интерфейса
echo "1. Настройка физического интерфейса enp0s8:"
# nmcli — утилита NetworkManager для управления сетевыми соединениями. con = connection работает с соединениями
# ethernet - проводной интерфейс. ifname — имя нового интерфейса. con-name — имя соединения в NetworkManager.
sudo nmcli con add type ethernet ifname enp0s8 con-name static-enp0s8 
sudo nmcli con modify static-enp0s8 ipv4.addresses 10.100.0.2/24
sudo nmcli con modify static-enp0s8 ipv4.gateway 10.100.0.1
sudo nmcli con modify static-enp0s8 ipv4.dns 8.8.8.8
# ipv4.method — метод получения IP. manual — статическая настройка (не DHCP)
sudo nmcli con modify static-enp0s8 ipv4.method manual
sudo nmcli con up static-enp0s8

sleep 3

# 2. Создание виртуального интерфейса br0
echo "2. Создание виртуального интерфейса br0:"
# bridge — тип интерфейса мост, позволяет объединять несколько интерфейсов
sudo nmcli con add type bridge ifname br0 con-name br0
sudo nmcli con modify br0 ipv4.addresses 10.100.0.3/24
sudo nmcli con modify br0 ipv4.method manual
# связь между физическим интерфейсом и bridge
sudo nmcli con add type bridge-slave ifname enp0s8 master br0
sudo nmcli con up br0

sleep 5

# 3. Проверка связи между интерфейсами
echo "3. Проверка связи между интерфейсами:"
# Проверяем что у интерфейсов правильные IP
echo "IP адрес enp0s8:"
ip addr show enp0s8 | grep inet
echo "IP адрес br0:"
ip addr show br0 | grep inet

# -c 4 отправка 4 пакетов. -I  указывает через какой интерфейс отправлять пакеты
ping -c 4 -I 10.100.0.2  10.100.0.3 # реальный интерфейс
ping -c 4 -I 10.100.0.3  10.100.0.2 # виртуальный интерфейс

# 4. Определение MAC-адреса виртуального интерфейса
echo "4. Определение MAC-адреса виртуального интерфейса br0"
echo "MAC-адрес:"
ip link show br0 | grep link/ether
