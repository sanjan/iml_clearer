#!/usr/bin/expect -f
#  ./iml.exp password hostname
set pass [lrange $argv 0 0]
set server [lrange $argv 1 1]
spawn ssh -q -o "StrictHostKeyChecking no" $server
match_max 100000
expect "*?assword:*"
send -- "$pass\r"
expect "*bash*"
send -- "sudo hpasmcli -s 'show iml'\r"
expect "*sudo*assword*"
send -- "$pass\r"
expect "*bash*"
send "sudo hpasmcli -s 'show iml'| tail -3 | head -1 | grep -c REPAIRED\r"
expect "*bash*"
send "sudo hpasmcli -s 'clear iml'\r"
expect "*bash*"
send -- "exit\r"