#!/bin/bash

##########################################################
#                                                        #
#              The name of your machine                  #
#                                                        #
##########################################################

MACHINENAME=$1

##########################################################
#                                                        #
#                     Create VM                          #
#                                                        #
##########################################################

VBoxManage createvm --name $MACHINENAME --ostype "Debian_64" --register --basefolder /sgoinfre/$(whoami)

##########################################################
#                                                        #
#      Set memory RAM, virtual memomty and network       #
#                                                        #
##########################################################

VBoxManage modifyvm $MACHINENAME --ioapic on
VBoxManage modifyvm $MACHINENAME --memory 4096 --vram 128
VBoxManage modifyvm $MACHINENAME --nic1 nat

##########################################################
#                                                        #
#      Create Disk Partition, connect Debian ISO         #
#                                                        #
##########################################################

VBoxManage createhd --filename /sgoinfre/$(whoami)/$MACHINENAME/$MACHINENAME_DISK.vdi --size 10000 --format VDI
VBoxManage storagectl $MACHINENAME --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $MACHINENAME --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  /sgoinfre/$(whoami)/$MACHINENAME/$MACHINENAME_DISK.vdi
VBoxManage storagectl $MACHINENAME --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $MACHINENAME --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "/sgoinfre/bmiguel-/debian.iso"
VBoxManage modifyvm $MACHINENAME --boot1 dvd --boot2 disk --boot3 none --boot4 none

##########################################################
#                                                        #
#        Enable Bridged Adapter to ssh connection        #
#                                                        #
##########################################################

VBoxManage modifyvm $MACHINENAME --nictype1 82540EM
VBoxManage modifyvm $MACHINENAME --nic1 bridged
VBoxManage modifyvm $MACHINENAME --nicpromisc1 deny
VBoxManage modifyvm $MACHINENAME --bridgeadapter1 eno2

##########################################################
#                                                        #
#                    Start the VM                        #
#                                                        #
##########################################################

VBoxManage startvm $MACHINENAME --type gui
