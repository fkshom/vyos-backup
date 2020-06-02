# vyos-backup

## USAGE

```
curl -L https://github.com/fkshom/vyos-config-backup/raw/master/install.sh | bash
sudo apt install git

git clone https://github.com/path/to/your/backup/repository.git backup
 or
git init backup
git remote add origin https://github.com/path/to/your/backup/repository.git

cd backup

backup_config.sh  # with commit only
 or
backup_config.sh -p  # with commit and push

...something
```
