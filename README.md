# Nextcloud

This repository contains the settings I'm using to self-host Nextcloud. You can read more about it here: [
Configuring a self-hosted Nextcloud server](https://noeldemartin.com/tasks/configuring-a-self-hosted-nextcloud-server).

## Development set up

```sh
cp .env.dev .env
mkdir data
nginx-agora install-proxy ./nginx/cloud.noeldemartin.com nextcloud
nginx-agora enable nextcloud
docker-compose up -d
nginx-agora start
```

## Production set up

```sh
# Env
cp .env.prod.example .env
vim .env # Fill empty variables (This may come in handy https://bitwarden.com/password-generator/)

# Mount Hetzner Storage Box using WebDAV (https://www.hetzner.com/storage/storage-box)
mkdir data
sudo chown www-data:www-data data
sudo apt-get install davfs2
sudo vim /etc/davfs2/secrets # Append: https://<username>.your-storagebox.de <username> <password>
sudo vim /etc/fstab # Append: https://<username>.your-storagebox.de <nextcloud_path>/data davfs rw,uid=www-data,gid=www-data,file_mode=0660,dir_mode=0770 0 0
sudo mount -a

# Set up nginx-agora (https://github.com/NoelDeMartin/nginx-agora)
nginx-agora install-proxy ./nginx/cloud.noeldemartin.com.conf nextcloud
nginx-agora enable nextcloud

# Launch it!
docker-compose up -d
nginx-agora start
```

## First launch

Here's some things I usually do after the first launch:

- Disable most apps.
- Configure email settings.
- Create a personal user (instead of using `admin`).
- Configure TOTP authentication.
