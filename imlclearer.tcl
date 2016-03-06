#!/usr/bin/expect -f
# usage ./iml.exp {password} {server name/ip}
set pass [lindex $argv 0]
set server [lindex $argv 1]

# connect to the remote server via ssh
spawn ssh -q -o "StrictHostKeyChecking no" $server #"StrictHostKeyChecking no" to avoid annoying yes/no prompt
match_max 100000
expect "*?assword:*" { send -- "$pass\r" }

# executing a simple sudo command to avoid sudo prompt later on with pipes
expect "*bash*" { send -- "sudo echo 'clearing iml'\r" }
expect "*sudo*assword*" { send -- "$pass\r" }

# execute "show iml" command to check if the last line is "REPAIRED"
expect "*bash*" {send -- "sudo hpasmcli -s 'show iml'| tail -3 | head -1 | grep -c REPAIRED\r" }

#get the output from earlier command
set output $expect_out(buffer);

#we only need the first line of output which contains the count, so put into an array
set count [ split $output \n ];

#check if the first line is 1, then clear the iml
if { $count[0] == 1 } {
   send -- "sudo hpasmcli -s 'clear iml'\r"
}

# get out from the host
expect "*bash*" { send -- "exit\r" }
