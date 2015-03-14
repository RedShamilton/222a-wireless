#!/bin/bash
iw dev mon0 del
flgs="fcsfail control otherbss"
iw phy phy$1 interface add mon0 type monitor flags $flgs
echo "Added mon0 to phy0 with flags: $flgs"
ifconfig mon0 up
ifconfig mon0 promisc
