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

To see an example script on how to install please see https://raw.githubusercontent.com/RattyDAVE/guacamole-uk/master/install.sh
