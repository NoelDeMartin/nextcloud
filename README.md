# Nextcloud

This repository contains the settings I'm using to self-host Nextcloud. You can read more about it here: [
Configuring a self-hosted Nextcloud server](https://noeldemartin.com/tasks/configuring-a-self-hosted-nextcloud-server).

## Development set up

```sh
cp .env.dev .env
mkdir data
nginx-agora install-proxy ./nginx/cloud.noeldemartin.test.conf nextcloud
nginx-agora enable nextcloud
docker compose up -d
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
docker compose up -d
nginx-agora start
```

## First launch

Here's some things I usually do after the first launch:

- Disable most apps.
- Configure email settings.
- Create a personal user (instead of using `admin`).
- Configure TOTP authentication.

## Updates

Running updates should be as easy as running the following commands, given that Nextcloud's AIO runs upgrades automatically on start up:

```sh
git pull
docker compose down
docker compose up -d
```

If you don't upgrade the server in a while, this may not work because the PHP version of new images is no longer supported. Instead of following the [manual upgrade instructions](https://github.com/nextcloud/all-in-one/blob/main/manual-upgrade.md), I've found it easier to upgrade to older Docker images instead (and repeat until you can use the latest).

Finally, make sure to check out the [version upgrade guides](https://docs.nextcloud.com/server/latest/admin_manual/release_notes/index.html#critical-changes), although they can often be ignored if you're using this AIO set up.
