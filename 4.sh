# Проверяем, что bond007 создался
ip link show bond007

# Выводим информацию о IP и MAC всех интерфейсов
echo "Информация о всех интерфейсах:"

# Физические интерфейсы
echo "--- enp0s3 ---"
ip addr show enp0s3 | grep -E "(inet|link/ether)"
ip -br link show enp0s3

echo "--- enp0s8 ---" 
ip addr show enp0s8 | grep -E "(inet|link/ether)"
ip -br link show enp0s8

# Bond интерфейс
echo "--- bond007 ---"
ip addr show bond007 | grep -E "(inet|link/ether)"
ip -br link show bond007

# Альтернативный способ посмотреть все сразу
echo "Краткая информация обо всех интерфейсах:"
ip -br addr show
