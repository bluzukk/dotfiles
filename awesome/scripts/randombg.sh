if [ -z "$1" ]
  then
    echo "INFO: Using random wallpaper"
    bg="$(shuf -n1 -e ~/.config/awesome/assets/wallpaper/*)"
  else
    bg=$1

fi

wal -n -i $bg
echo $bg
# echo 'awesome.restart()' | awesome-client
# echo 'awesome.restart()' | awesome-client

nitrogen --restore
nitrogen --set-zoom-fill $bg --head=0
pywalfox update
# sleep 1
