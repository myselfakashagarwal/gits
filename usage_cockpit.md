# About 👨🏽‍💻
In a nutshell cockpit provides webinterface to your server with its help its easier to maintain and moniter system ligs, services etc it also provides a terminal in web thus empowering user to access server console from any machine.
This can easily be this script [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cockpit.sh)

# Access 🔑
The web interface can be accessed on port 9090 , all it needs is username and password in order you want to moderate access visit config file at path `/etc/cockpit/cockpit.conf`.

⎇ To get url of the cockpit interface 
```bash 
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e " \033[1;33m URL to access server internally = http://$internal_url:9090/system \033[0m")
```

# Trouble shooting 🛠️
`Can't access the cockpit` This is the most common error, quick actions to tackle thsese include, check cockpit socket is enable and running with command `systemctl status cockpit.socket` if found inactive and disabled enable it with command `systemctl enable cockpit.socket` and `systemctl start cockpit.socket` then restart please refrain to deamon-reload services just wait and restart. Check if the port 9900 is used only by cockpit in case there's need to change default port visit [Tutorial](https://community.nethserver.org/t/how-to-change-the-default-port-9090/20626)
For more visit [Docs](https://help.sap.com/docs/SAP_HANA_COCKPIT/afa922439b204e9caf22c78b6b69e4f2/b1109e8c78b846cfb8a71c331bbd1313.html) 