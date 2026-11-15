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

# Guardar un snapshot antes de una modificación importante.
"$VBOX" snapshot "$VM" take 'Nombre descriptivo del snapshot'

# Exportar la VM al archivo OVA después de completar el laboratorio.
"$VBOX" export "$VM" --output 'Rubio_Post5_U5.ova'
