# guacamole

This is a stand alone Guacamole (https://guacamole.incubator.apache.org/) build with the config saved in a configuration xml file rather than a database and UK keymap included

Put your config XML in "config" directory and mount empty "data" directory for file transfers, in user-mapping.xml use the following

```
    <param name="enable-drive">true</param>
    <param name="drive-path">/file-transfer</param>
```

To use UK keyboard
```
    <param name="server-layout">en-gb-qwerty</param>
```

Start with
```
    docker run \
       -dit \
       --name guac \
       -p 8080:8080 \
       -v ${PWD}/config:/etc/guacamole \
       -v ${PWD}/data:/file-transfer \
       rattydave/guacamole-uk:latest
```

Then connect to docker server ```http://docker:8080/remote```


Example usermapping.xml taken from http://guacamole.apache.org/doc/gug/configuring-guacamole.html#user-mapping

```
<user-mapping>
    <authorize username="user1" password="password1">
        <protocol>vnc</protocol>
        <param name="hostname">localhost</param>
        <param name="port">5900</param>
        <param name="password">VNCPASS</param>
    </authorize>

    <!-- Another user, but using md5 to hash the password
         (example below uses the md5 hash of "PASSWORD") -->
    <authorize 
            username="USERNAME2"
            password="319f4d26e3c536b5dd871bb2c52e3178"
            encoding="md5">

        <!-- First authorized connection -->
        <connection name="localhost">
            <protocol>vnc</protocol>
            <param name="hostname">localhost</param>
            <param name="port">5901</param>
            <param name="password">VNCPASS</param>
        </connection>

        <!-- Second authorized connection -->
        <connection name="otherhost">
            <protocol>vnc</protocol>
            <param name="hostname">otherhost</param>
            <param name="port">5900</param>
            <param name="password">VNCPASS</param>
        </connection>
        
        <connection name="Unique Name">
            <protocol>rdp</protocol>
            <param name="hostname">localhost</param>
            <param name="port">3389</param>
        </connection>
        
        <connection name="SSH Connection to Server">
            <protocol>ssh</protocol>
            <param name="hostname">sshserver</param>
            <param name="port">22</param>
        </connection>

    </authorize>

</user-mapping>
```
