#!/bin/bash
#=== Настройки
user=opensearch
new_uid=1010
old_uid=$(id -u $user)
group=opensearch
new_gid=1010
old_gid=$(id -g $user)

#=== Смена UID & GID
sudo usermod -u $new_uid $user
sudo groupmod -g $new_gid $group

#=== Поиск файлов
chownlist=$(mktemp)
chgrplist=$(mktemp)
sudo find / \
   \( \( -path "/proc" -or -path "/sys" \) -prune \) -or \
   \( \( -user $old_uid -fprint0 "$chownlist" \) , \( -group $old_gid -fprint0 "$chgrplist" \) \)

#=== chown и чистка
cat "$chownlist" | xargs -0 sudo chown $user
cat "$chgrplist" | xargs -0 sudo chown :$group
sudo rm "$chownlist" "$chgrplist"
