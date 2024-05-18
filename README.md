<img width="863" alt="Screenshot 2024-05-18 at 6 38 36 PM" src="https://github.com/myselfakashagarwal/gits/assets/106314226/3176319c-fe5c-4606-aae3-71b2f10ee6a0">

<br> 

## About

The Git Server is a robust infrastructure designed for hosting Git repositories, utilizing GitLab-CE for self-hosting, Cloudflared tunneling for secure access, and a Cockpit web interface for efficient system administration. This contains extremely flexible shell scripts that are designed to setup everything from absolute scratch. Matter fact these scripts can also handle hosting with no configuration that too securely. So whats holding you back to have your own git server git it a try and surf the tide of version control. <br> 

## Setup 

Run These scripts in the sequence specified and you are good to go ..  [FIRST](https://raw.githubusercontent.com/myselfakashagarwal/gitserver/legacy/setup_cloudflared.sh)    [SECOND](https://raw.githubusercontent.com/myselfakashagarwal/gitserver/legacy/setup_cockpit.sh)    [THIRD](https://raw.githubusercontent.com/myselfakashagarwal/gitserver/legacy/setup_gitlabce.sh) At the same time checkout the usage guide mentioned along with each component. <br> 

## DOCS & Components 

### Gitlab CE 

#### About 👨🏽‍💻
In simple terms gitlab-ce is community edition of the GitLab. The CE version can be used to host own git server and provide web interface for repos at the same time have other features too like CICD, Docker registery etc.
This can easily be this script [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_gitlabce.sh)

#### Access 🔑
Initially when the setup is done (with the [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_gitlabce.sh) ) In the initial setup by the script root/admin's password is provided by the script by which one can easily access the admin dashboard. But the initial root password is only valid for 24 hrs thus have to be changed by the admin. If unfamilier with GitLab its advised to watch beginer tutorials to get through. Here are the commands to get through quickly.

⎇ To get url of the web interface 
```bash
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e " \033[1;33m URL to access server internally = http://$internal_url/users_sign_in \033[0m")
```

⎇ To get 24 hrs valid pass after fresh installation
```bash
echo -e " \033[1;33m $(sudo cat /etc/gitlab/initial_root_password | grep "Password:") \033[0m"
```

⎇ To get url to reset admin pass (quick link)
```bash
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e " \033[1;33m URL to add new user = http://$internal_url/admin/users/root/edit  \033[0m")
```

⎇ To get url of admin dashboard (quick link)
```bash
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e " \033[1;33m URL to add new user = http://$internal_url/admin \033[0m")
```
##### Repositories 🗂️
The repos created on the server can be found under this path ``/var/opt/gitlab/git-data/repositories/@hashed`` it is to be noted that the path are hashed so don't get scared to see hashes. Before working on the repo make sure to add global configuration for dubious ownership with command ``git config --global --add safe.directory ABSOLUTE-PATH-TO-YOUR-GIT-REPO`` after initilizing the repo with the `git init` command. Similarly the repo found here is bare to work with it without messing things up just clone it with command ``git clone ABSOLUTE-PATH-TO-YOUR-GIT-REPO``

##### Trouble-shooting 🛠️
`502 bad gateway` This error might occur while accessing the web console just after running the setup script in that case first give some time there might be background processes that might need to complete. After that quick actions include restart ! yeah restart works it's not a default advice , check and try password and username , check if the resources such as ram are available for the console (usually this case occur in VMs) , check the link to the console is correct or not, at last visit youtube.

`Console is not accessiable` if thats the case first restart, then check url and most important check if the port 8080 is assigned to console only. `Notice` If you are trying to access console with url on different network than server is hosted on, in that case move to the networking course. In case try cloudlfared tunnel to host your url and try to access again.

These are the most common error that you might seem. In cases when there are dependencies `gitlab-ctl reconfigure` works condider [docs](https://docs.gitlab.com/omnibus/troubleshooting.html) and dont forget to raise issues if you encounter one. 👍🏼

<hr>

### Cockpit 

#### About 👨🏽‍💻
In a nutshell cockpit provides webinterface to your server with its help its easier to maintain and moniter system logs, services etc it also provides a terminal in web thus empowering user to access server console from any machine.
This can easily be this script [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cockpit.sh)

##### Access 🔑
The web interface can be accessed on port 9090 , all it needs is username and password in order you want to moderate access visit config file at path `/etc/cockpit/cockpit.conf`.

⎇ To get url of the cockpit interface 
```bash 
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e " \033[1;33m URL to access server internally = http://$internal_url:9090/system \033[0m")
```

##### Trouble shooting 🛠️
`Can't access the cockpit` This is the most common error, quick actions to tackle thsese include, check cockpit socket is enable and running with command `systemctl status cockpit.socket` if found inactive and disabled enable it with command `systemctl enable cockpit.socket` and `systemctl start cockpit.socket` then restart please refrain to deamon-reload services just wait and restart. Check if the port 9900 is used only by cockpit in case there's need to change default port visit [Tutorial](https://community.nethserver.org/t/how-to-change-the-default-port-9090/20626)
For more visit [Docs](https://help.sap.com/docs/SAP_HANA_COCKPIT/afa922439b204e9caf22c78b6b69e4f2/b1109e8c78b846cfb8a71c331bbd1313.html) 

<hr> 

### Cloudflared

#### About 👨🏽‍💻

Cloudflare tunnel can establish connections between end user and your server, how ? -> By outbounding connection between your resource/service and cloudflare global network. Cloudflare tunnel have tonnes of feature and capibilities like setting up tunnels with domain names, dashboard but in this setup only needed tings have been setup so that configurations and dependicies do not mess up the build. You can setup this by running [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cloudflared.sh)

#### Run your tunnel ⚙︎
In regular you can pre create your tunnels by following up this [tutorial](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/) yet for fast setup just create a local tunnel.

⎇ To create local cloudflared tunnel for accessing gitlab-ce web interface 
```bash 
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e "http://$internal_url/users_sign_in") | xargs cloudflared --no-tls-verify --url
```

⎇ To create local cloudflared tunnel for accessing cockpit web interface 
```bash 
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e "http://$internal_url:9090/system") | xargs cloudflared --no-tls-verify --url
```

#### Trouble shooting 🛠️
The most common errrors occur just becasue the port or the complete url is not mentioned. Sometimes there are more that one services running on same port clashing the services so in that case make sure each service have a seperate port. In case of `server misbehaving` error try to run tunnel on localhost with default port than run with complete url. For more check this [docs](https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/#:~:text=%E2%80%8B%E2%80%8B%20Tunnel%20connections%20fail,files%20limit%20on%20your%20machine.)


