# About 👨🏽‍💻
Cloudflare tunnel can establish connections between end user and your server, how ? -> By outbounding connection between your resource/service and cloudflare global network. Cloudflare tunnel have tonnes of feature and capibilities like setting up tunnels with domain names, dashboard but in this setup only needed tings have been setup so that configurations and dependicies do not mess up the build. You can setup this by running [Installation-Script](https://github.com/myselfakashagarwal/gitserver/blob/legacy/setup_cloudflared.sh)

# Run your tunnel ⚙︎
In regular you can pre create your tunnels by following up this [tutorial](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/) yet for fast setup just create a local tunnel.

⎇ To create local cloudflared tunnel for accessing gitlab-ce web interface 
```bash 
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e "http://$internal_url/users_sign_in") | xargs cloudflared --no-tls-verify --url
```

⎇ To create local cloudflared tunnel for accessing cockpit web interface 
```bash 
(internal_url=$(ip a | grep -w "inet" | grep -v "inet 127.0.0.1" | awk '{print $2}' | cut -d "/" -f1) && echo -e "http://$internal_url:9090/system") | xargs cloudflared --no-tls-verify --url
```

# Trouble shooting 🛠️
The most common errrors occur just becasue the port or the complete url is not mentioned. Sometimes there are more that one services running on same port clashing the services so in that case make sure each service have a seperate port. In case of `server misbehaving` error try to run tunnel on localhost with default port than run with complete url. For more check this [docs](https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/#:~:text=%E2%80%8B%E2%80%8B%20Tunnel%20connections%20fail,files%20limit%20on%20your%20machine.)
