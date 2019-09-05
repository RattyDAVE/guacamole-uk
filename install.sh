mkdir -p ~/docker/configs/guacamole

cat <<EOF > ~/docker/configs/guacamole/guacamole.properties
# Hostname and port of guacamole proxy
guacd-hostname: localhost
guacd-port:     4822

# Auth provider class (authenticates user/pass combination, needed if using the provided login screen)
auth-provider: net.sourceforge.guacamole.net.basic.BasicFileAuthenticationProvider
basic-user-mapping: /etc/guacamole/user-mapping.xml
EOF

cat <<EOF > /home/docker/configs/guacamole/user-mapping.xml
<user-mapping>
 <authorize username="user1" password="user1password">
  <connection name="RDP - Server 1 ">
   <protocol>rdp</protocol>
   <param name="hostname">server1.domain.name</param>
   <param name="port">3389</param>
  </connection>
  <connection name="RDP - Server 2">
   <protocol>rdp</protocol>
   <param name="hostname">server2.another.domain.name</param>
   <param name="port">3389</param>
  </connection>
  <connection name="SSH - server3">
   <protocol>ssh</protocol>
   <param name="hostname">server3.another.domain.name</param>
   <param name="port">22</param>
  </connection>
 </authorize>

 <authorize username="user2" password="user2password">
  <connection name="RDP - Server 1">
   <protocol>rdp</protocol>
   <param name="hostname">server1.domain.name</param>
   <param name="port">3389</param>
  </connection>
 </authorize>
</user-mapping>
EOF

docker run \
       -dit \
       --name guac \
       -p 8080:8080 \
       -v ~/docker/configs/guacamole:/etc/guacamole \
       -v ~:/file-transfer \
       rattydave/guacamole-uk:latest
