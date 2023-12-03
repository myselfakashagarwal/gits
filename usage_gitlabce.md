
# About 👨🏽‍💻
In simple terms gitlab-ce is community edition of the GitLab. The CE version can be used to host own git server and provide web interface for repos at the same time have other features too like CICD, Docker registery etc.
This can easily be this script [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_gitlabce.sh)

## Access 🔑
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
# Repositories 🗂️
The repos created on the server can be found under this path ``/var/opt/gitlab/git-data/repositories/@hashed`` it is to be noted that the path are hashed so don't get scared to see hashes. Before working on the repo make sure to add global configuration for dubious ownership with command ``git config --global --add safe.directory ABSOLUTE-PATH-TO-YOUR-GIT-REPO`` after initilizing the repo with the `git init` command. Similarly the repo found here is bare to work with it without messing things up just clone it with command ``git clone ABSOLUTE-PATH-TO-YOUR-GIT-REPO``

# Trouble-shooting 🛠️
`502 bad gateway` This error might occur while accessing the web console just after running the setup script in that case first give some time there might be background processes that might need to complete. After that quick actions include restart ! yeah restart works it's not a default advice , check and try password and username , check if the resources such as ram are available for the console (usually this case occur in VMs) , check the link to the console is correct or not, at last visit youtube.

`Console is not accessiable` if thats the case first restart, then check url and most important check if the port 8080 is assigned to console only. `Notice` If you are trying to access console with url on different network than server is hosted on, in that case move to the networking course. In case try cloudlfared tunnel to host your url and try to access again.

These are the most common error that you might seem. In cases when there are dependencies `gitlab-ctl reconfigure` works condider [docs](https://docs.gitlab.com/omnibus/troubleshooting.html) and dont forget to raise issues if you encounter one. 👍🏼

