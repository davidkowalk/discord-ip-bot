#/bin/bash

webhook="[WEBHOOK URL]"
port="25565"

send_update_message() {
	#echo "IP: $1"
	curl -X POST -H "Content-Type: application/json" -d "{\"content\":\"**IP**: $1:$port\"}" $webhook
}

update() {
	ip="`wget -qO- http://ifconfig.me`"
	send_update_message $ip
}

schedule_tomorrow() {
	next_update=$(date -d "5:00 tomorrow" +%s)
	current_time=$(date +%s)
	sleeptime=$(($next_update - $current_time))

	sleep $sleeptime
	update
}

#send_update_message "test"
ip="`wget -qO- http://ifconfig.me`"
msg="**IP:** $ip:$port"
curl -X POST -H "Content-Type: application/json" -d "{\"content\":\"$msg\"}" $webhook

while :
do
	schedule_tomorrow
done

echo Exiting
