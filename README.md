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


## Auto Update

To automatically update I recomend using watchtower.

```
docker run -d \
    --name watchtower \
    -v /var/run/docker.sock:/var/run/docker.sock \
    containrrr/watchtower 
```

# Full Version

If you require the full version then use the following

```
####### Guacamole #######

#Setup MYSQL vars
MYSQL_ROOT_PASSWORD=pass@word01
MYSQL_DATABASE=guacamole_db
MYSQL_USER=guacamole_user
MYSQL_PASSWORD=some_password

#Setup Docker instance names
MYSQL_NAME=mysqldb
GUACD_NAME=some_guacd
GUACAMOLE_NAME=some-guacamole

docker pull guacamole/guacamole
docker pull guacamole/guacd
docker pull mysql

mkdir /root/dbinit
docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > /root/dbinit/guacamole_initdb.sql
docker run -d --name $MYSQL_NAME -v /root/dbinit:/docker-entrypoint-initdb.d -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD mysql
rm -r /root/dbinit

docker run --name $GUACD_NAME -d guacamole/guacd
docker run --name $GUACAMOLE_NAME --link $GUACD_NAME:guacd --link $MYSQL_NAME:mysql -e MYSQL_DATABASE=$MYSQL_DATABASE -e MYSQL_USER=$MYSQL_USER -e MYSQL_PASSWORD=$MYSQL_PASSWORD -d -p 8080:8080 guacamole/guacamole

#Access via ... http://docker.machine:8080/guacamole default password is guacadmin password guacadmin
####### END Guacamole #######
```

