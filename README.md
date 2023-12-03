# About 👨🏽‍💻
The Git Server is a robust infrastructure designed for hosting Git repositories, utilizing GitLab-CE for self-hosting, Cloudflared tunneling for secure access, and a Cockpit web interface for efficient system administration. Extreme automation is a cornerstone of this infrastructure, facilitated by Bash scripts. These scripts handle tasks ranging from user and group management to server maintenance and operations. The server also holds the "Git-Recipes" repository, which represents real-world Git techniques and depicts them with examples mimicking real-world scenarios.Overall, the Git Server serves its purpose to provide seamless continuous integration and server tasks like automation, security, system administration, scripting, etc.
<hr>

# "How can I setup my own 🤔"
If you want a structural setup just run these 
  [FIRST](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cloudflared.sh)
  [SECOND](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cockpit.sh)
  [THIRD](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_gitlabce.sh)
  scripts in sequence similarly follow the guide and docs at the same time.. It is to be noted that the setup is mainly for Rocky and Ubuntu

<hr>

# Structural Components ⚙︎
#### -------------- GitLab-CE --------------
#### Docs - [Official-Documentation](https://gitlab.com/rluna-gitlab/gitlab-ce)
#### Setup - [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_gitlabce.sh)
#### Usage - [Guide](https://github.com/myselfakashagarwal/gitserver/blob/legacy/usage_gitlabce.md)
#### ---------------- Cockpit ----------------
#### Docs - [Official-Documentation](https://cockpit-project.org/guide/latest/)
#### Setup - [Installation-script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cockpit.sh)
#### Usage - [Guide](https://github.com/myselfakashagarwal/gitserver/blob/legacy/usage_cockpit.md)
#### ------------- Cloudflared -------------
#### Docs - [Official-Documentation](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/)
#### Setup - [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cloudflared.sh)
#### Usage - [Guide](https://github.com/myselfakashagarwal/gitserver/blob/legacy/usage_cloudflared.md)
<hr>

