#!/bin/sh
sudo virsh destroy webserver-vm
sudo virsh destroy db-vm
sudo virsh undefine webserver-vm
sudo virsh undefine db-vm
