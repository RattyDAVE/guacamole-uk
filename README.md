# Guacamole

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

## Config File

In ${PWD}/config create ```usermapping.xml``` with the following 

```
<user-mapping>
    <authorize username="John" password="securepassword">
        <protocol>vnc</protocol>
        <param name="hostname">somevnc.hostname.com</param>
        <param name="port">5900</param>
        <param name="password">vncpassword</param>
    </authorize>
</user-mapping>
```






# Full Version

If you require the full version then use the following

```
####### Guacamole #######
mkdir /root/dbinit

docker pull guacamole/guacamole
docker pull guacamole/guacd
docker pull mysql

docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > /root/dbinit/guacamole_initdb.sql
docker run -d --name mysqldb -v /root/dbinit:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=pass@word01 -e MYSQL_DATABASE=guacamole_db -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=some_password mysql

rm -r /root/dbinit
docker run --name some-guacd -d guacamole/guacd
docker run --name some-guacamole --link some-guacd:guacd --link mysqldb:mysql -e MYSQL_DATABASE=guacamole_db -e MYSQL_USER=guacamole_user -e MYSQL_PASSWORD=some_password -d -p 8080:8080 guacamole/guacamole

#Access via ... http://docker.machine:8080/guacamole default password is guacadmin password guacadmin
####### END Guacamole #######
```

