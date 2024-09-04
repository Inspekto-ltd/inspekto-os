#!/bin/bash
# dhcp.conf file changes
sed -i '/^[[:space:]]*#/d' /etc/dhcp/dhcpd.conf # remove all commented lines
sed -i ':a;N;$!ba;s/\n*$/\n/' /etc/dhcp/dhcpd.conf # remove empty lines at the end of the file, except one
sed -i 's/max-lease-time 7200;/max-lease-time 63113904;/' /etc/dhcp/dhcpd.conf # change max-lease-time to 2 years

# Define the variables
crevis_unique_mac="00:14:f7"
crevis_class_name="crevis"
subnet="90.0.0.0"
netmask="255.255.255.0"
minimum_ip_address="90.0.0.2"

cat <<EOF >> /etc/dhcp/dhcpd.conf
class "$crevis_class_name" {
     match if substring (hardware, 1, 3) = $crevis_unique_mac;
}

subnet $subnet netmask $netmask {
    pool {
        range dynamic-bootp $minimum_ip_address ;
        allow members of "$crevis_class_name";
        allow dynamic bootp clients;
    }
}
EOF

touch /var/lib/dhcp/dhcpd.leases
/usr/sbin/dhcpd -4 -d -f -cf /etc/dhcp/dhcpd.conf -lf /var/lib/dhcp/dhcpd.leases -pf /var/run/dhcpd.pid $CONNECTIVITY_INTERFACE
