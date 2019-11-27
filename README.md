# X Roleplay System - An Advanced roleplay framework for RedM

![alt text](http://46.41.139.135/xrp.jpg)
Join our discord to get the newest updates and support! - https://discord.gg/FKH4uwb

## 1. Features
- Respawn/Spawn system - https://github.com/amakuu/xrp_respawn/
- Loading And Saving Player Information in MySQL databse
- Money System
- Gold System
- Groups System
- Permission System
- Jobs System [in build]
- Inventory System [in build]
- HUD
- Leveling and EXP system
- Respawn Place Selection - https://github.com/amakuu/xrp_respawn/
- A lot of configuration options

## 2. Requirements
 
[fivem-mysql-async](https://github.com/brouznouf/fivem-mysql-async)

[async](https://github.com/ESX-Org/async)

## 3. Installation
- Put fivem-mysql-async into server-data/resources/ and rename it to mysql-async

- Put async into server-data/resources/ and be sure that the folder name is async

- Put the xrp folder in server-data/resources/[xrp]/ - if you don't have [xrp], just create a new one

- Import db.sql into your mysql database

- Open your server.cfg and put below commands into it


```
set mysql_connection_string "server=ip;uid=user_name;password=very_secure_password;database=xrp"
ensure mysql-async
ensure async
ensure xrp
```

## 4. Usage
Join our discord to get the newest updates and support! - https://discord.gg/FKH4uwb

## 5. Credits

https://github.com/kanersps for all work he done, his scripts is the basics of the xrp framework
