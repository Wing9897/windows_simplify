@echo off
echo enable ICMP Echo Request(ICMPv4-In)
netsh advfirewall firewall set rule name="Core Networking Diagnostics - ICMP Echo Request (ICMPv4-In)" profile=private,public new enable=yes
pause