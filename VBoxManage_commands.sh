#!/usr/bin/env bash
# Comandos de referencia ejecutados para el laboratorio en Windows con VBoxManage.
# Ejecutar desde PowerShell o adaptar la ruta al VBoxManage de cada sistema.
VBOX='C:/Program Files/Oracle/VirtualBox/VBoxManage.exe'
VM='Lab5-Alpine'

# Consultar versión, configuración y snapshots.
"$VBOX" --version
"$VBOX" showvminfo "$VM"
"$VBOX" snapshot "$VM" list --details

# Configuración de hardware de la VM: dos CPU, 2048 MiB, NAT.
"$VBOX" modifyvm "$VM" --cpus 2 --memory 2048 --nic1 nat --boot1 disk --boot2 none

# Seleccionar temporalmente cada modo de red.
"$VBOX" controlvm "$VM" nic1 nat
"$VBOX" controlvm "$VM" nic1 hostonly 'VirtualBox Host-Only Ethernet Adapter'
"$VBOX" controlvm "$VM" nic1 bridged 'Realtek RTL8852BE-VS WiFi 6 802.11ax PCIe Adapter'

# Snapshots tomados y restauración comprobada: se cambió la NIC a Host-only,
# luego se restauró el snapshot final y showvminfo confirmó que volvió a NAT.
"$VBOX" snapshot "$VM" take 'Base Alpine instalado y NAT'
"$VBOX" snapshot "$VM" take 'Antes de pruebas de disco'
"$VBOX" snapshot "$VM" take 'Pruebas de disco completadas'
"$VBOX" snapshot "$VM" list --details
"$VBOX" modifyvm "$VM" --nic1 hostonly --hostonlyadapter1 'VirtualBox Host-Only Ethernet Adapter'
"$VBOX" snapshot "$VM" restore 'Pruebas de disco completadas'

# Discos de comparación de 4 GiB, creados fuera del repositorio.
"$VBOX" createmedium disk --filename 'C:/Users/USUARIO/VirtualBox VMs/Lab5-Alpine/Comparacion-Dinamico.vdi' --size 4096 --format VDI --variant Standard
"$VBOX" createmedium disk --filename 'C:/Users/USUARIO/VirtualBox VMs/Lab5-Alpine/Comparacion-Fijo.vdi' --size 4096 --format VDI --variant Fixed
# Los discos se conectaron en SATA-1-0 y SATA-2-0, respectivamente.
"$VBOX" storageattach "$VM" --storagectl SATA --port 1 --device 0 --type hdd --medium 'C:/Users/USUARIO/VirtualBox VMs/Lab5-Alpine/Comparacion-Dinamico.vdi'
"$VBOX" storageattach "$VM" --storagectl SATA --port 2 --device 0 --type hdd --medium 'C:/Users/USUARIO/VirtualBox VMs/Lab5-Alpine/Comparacion-Fijo.vdi'
# Dentro de Alpine se particionaron/formatearon /dev/sdb1 y /dev/sdc1, y se midió:
# time dd if=/dev/zero of=/mnt/dynamic/test.bin bs=1M count=200 conv=fsync
# time dd if=/dev/zero of=/mnt/fixed/test.bin bs=1M count=200 conv=fsync

# OVA generado fuera del repositorio; no subir OVA ni discos VDI a Git.
"$VBOX" export "$VM" --output 'C:/Users/USUARIO/VirtualBox VMs/Lab5-Alpine/Rubio_Post5_U5.ova' --manifest
