config setup
  strictcrlpolicy=no
  charondebug=all
conn %default
  ikelifetime=60m
  keylife=20m
  rekeymargin=3m
  keyingtries=1
  keyexchange=ikev1
conn tunnel_1
  authby=secret
  auto=start
  type=tunnel
  left=<%= ENV['LOCAL_IP'] %>
  leftid=<%= ENV['PUBLIC_LEFT_IP'] %>
  leftsubnet=10.0.0.0/24
  leftauth=psk
  right=<%= ENV['PUBLIC_RIGHT_IP'] %>
  rightsubnet=<%= ENV['RIGHT_SUBNET_CIDR'] %>
  rightauth=psk
  ike=aes128-sha1-modp1024
  esp=aes128-sha1-modp1024
