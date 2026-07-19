# Gits

Gits (Git Infrastructure Suite) is an infrastructure automation project that provisions and configures a self hosted GitLab Community Edition instance as a production ready Git and CI platform. It standardizes infrastructure provisioning, platform configuration, secure remote access, and operational setup into a small set of reproducible shell scripts, so a fully working, securely reachable Git server can be stood up from a bare Linux box with no manual configuration.

## Design Philosophy

The distribution decides the path. Rather than parsing `/etc/os-release`, each script detects the underlying distribution family by checking for a package manager marker directly: the presence of `/etc/yum.repos.d` means RHEL family, the presence of `/etc/apt` means Debian family. That single branch then decides every subsequent step: which packages get installed, which firewall tool is used (`ufw` vs `firewalld`), and which vendor install script (`.deb.sh` vs `.rpm.sh`) gets fetched and run.

Installation degrades gracefully. GitLab CE is first requested straight from the native package manager, since that path stays current with security patches automatically. If that resolution fails for any reason (a broken mirror, a missing repo entry), the script transparently falls back to fetching an explicit, version pinned `.deb` or `.rpm` directly from GitLab's own package registry and installing it with `dpkg`/`rpm`, so a single repository hiccup does not stall the entire setup.

Access is derived, not configured. Once GitLab finishes reconfiguring, the script reads the server's own network interfaces (via `ip a`) and GitLab's own generated root password file (`/etc/gitlab/initial_root_password`) directly, and prints both back to the operator. There is no separate access management step; the login link and the 24 hour temporary root password are handed over as a direct side effect of the install finishing.

Every phase reports itself. A single `print_messege` function wraps every stage (dependency install, firewall rules, platform install, reconfigure) in a full terminal width, color coded banner sized to the operator's own terminal (`tput cols`). Progress stays visible at a glance no matter how noisy the underlying package manager output gets, and this same banner convention is used consistently across all three setup scripts in the suite.

Exposure is optional, not structural. Cockpit and Cloudflared are layered onto the same box as independent, optional components rather than being built into the platform layer itself. GitLab CE works whether or not either is present. Cloudflared in particular means the platform never needs a public IP or an inbound port opened on the router. The tunnel is established outbound from the server to Cloudflare's network, so the connection direction never has to be reasoned about by the operator.

## Architectural Layers

### Platform Layer
GitLab Community Edition is the core of the suite: it hosts Git repositories, serves the web interface for browsing and managing them, and provides CI/CD pipelines and a Docker registry on top. It is installed through the official Omnibus bundle, which packages GitLab itself along with its own bundled PostgreSQL, Redis, and Nginx, so no separate database or web server setup is required.

### Administration Layer
Cockpit provides a general purpose web interface for the host itself: system logs, running services, resource usage, and a full browser based terminal, so the box can be administered from any machine without a direct SSH session.

### Access Layer
Cloudflared establishes an outbound tunnel from the server to Cloudflare's global network, exposing the platform and administration interfaces externally without requiring any inbound firewall rule or port forward on the network the server sits behind.

## Working

Every script in the suite follows the same shape, illustrated here by the GitLab CE installer:

1. **Detect the distribution.** The script checks for `/etc/yum.repos.d` or `/etc/apt` and sets a single `distribution` variable (`rhel` or `debian`) that every later branch reads from.
2. **Install dependencies.** On Debian family systems, `apt` installs `ca-certificates`, `curl`, `openssh-server`, `postfix`, `tzdata`, `perl`, `wget`, `libc6`, `ufw`, and `git`, then fetches GitLab's Debian bootstrap script. On RHEL family systems, the equivalent `yum` package set is installed, GitLab's GPG key is imported, and the RPM bootstrap script is fetched instead.
3. **Configure the firewall.** Debian systems enable `ufw` and allow HTTP, HTTPS, and OpenSSH. RHEL family systems start `firewalld` and permanently allow the `http`, `https`, and `ssh` services, plus an explicit `8080/tcp` port opening, before reloading the ruleset.
4. **Install GitLab CE.** The distribution specific bootstrap script (`script.deb.sh` or `script.rpm.sh`) is run to register GitLab's package repository, then `gitlab-ce` is installed through the native package manager. If that install command fails, the script falls back to downloading a pinned release build directly from `packages.gitlab.com` and installing it with `dpkg -i` or `rpm -i`.
5. **Reconfigure.** `gitlab-ctl reconfigure` runs to apply the Omnibus configuration and bring up GitLab's bundled services.
6. **Surface access.** The script parses `ip a` for the server's non loopback internal IP and prints the internal sign in URL, the machine's external IP via `ifconfig.me` for the equivalent external URL, and the contents of `/etc/gitlab/initial_root_password` so the operator has everything needed to log in immediately.

Cockpit and Cloudflared follow the same detect, install, configure, report pattern: Cockpit's script installs and enables the `cockpit.socket` unit so the web console is reachable on port 9090; Cloudflared's script installs the `cloudflared` binary and, for fast setups, establishes a quick unauthenticated tunnel (`cloudflared --no-tls-verify --url <internal address>`) directly against whichever internal URL (GitLab or Cockpit) needs to be exposed, without requiring a pre created named tunnel or domain.

## Components

| Component | Role | Access | Config path |
|---|---|---|---|
| GitLab CE | Git hosting, web UI, CI/CD, Docker registry | `http://<internal-ip>/users_sign_in`, root password valid 24 hours | `/etc/gitlab/gitlab.rb`; repositories under `/var/opt/gitlab/git-data/repositories/@hashed` |
| Cockpit | Web based system administration and browser terminal | `http://<internal-ip>:9090/system` | `/etc/cockpit/cockpit.conf` |
| Cloudflared | Outbound tunnel for secure external access, no inbound ports required | `cloudflared --no-tls-verify --url <internal-url>` | Per tunnel, created via the Cloudflare dashboard for persistent domains |

## Setup

Run the following scripts in order. Each one is self contained and prints its own access instructions when it finishes.

1. [Cloudflared setup](https://raw.githubusercontent.com/myselfakashagarwal/gitserver/legacy/setup_cloudflared.sh)
2. [Cockpit setup](https://raw.githubusercontent.com/myselfakashagarwal/gitserver/legacy/setup_cockpit.sh)
3. [GitLab CE setup](https://raw.githubusercontent.com/myselfakashagarwal/gitserver/legacy/setup_gitlabce.sh)

## Troubleshooting

**GitLab: `502 bad gateway`.** Usually a background reconfigure step still running right after setup. Give it a few minutes, then restart GitLab. Also check the resources available to the VM (RAM in particular), confirm the credentials being used, and confirm the console URL is correct.

**GitLab: console not reachable.** Restart the service, confirm the URL, and confirm port 8080 is not shared with another service. If accessing from a different network than the server is hosted on, route through the Cloudflared tunnel instead of the internal URL. Dependency related issues usually resolve with `sudo gitlab-ctl reconfigure`; see the [official troubleshooting docs](https://docs.gitlab.com/omnibus/troubleshooting.html) for anything beyond that.

**Cockpit: not reachable.** Check `systemctl status cockpit.socket`; if inactive, run `systemctl enable cockpit.socket` and `systemctl start cockpit.socket`, then restart rather than reloading the daemon directly. Confirm port 9090 is not in use by anything else.

**Cloudflared: connection or `server misbehaving` errors.** Usually caused by an incomplete URL or a port already in use by another service. Try running the tunnel against `localhost` on the default port before trying the full URL. See Cloudflare's [tunnel troubleshooting FAQ](https://developers.cloudflare.com/cloudflare-one/faq/teams-troubleshooting/) for further detail.
