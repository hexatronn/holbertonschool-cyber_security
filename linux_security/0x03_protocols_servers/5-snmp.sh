#!/bin/bash
cat /etc/snmp/snmpd.conf | grep -Ev "# " | grep "public"
