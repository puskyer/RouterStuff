#!/tmp/mnt/merlin/entware/bin/bash

OldPath="$PATH"

source ./variables

PATH=$PATH:/opt/usr/sbin:/opt/sbin:/opt/bin:/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin



myssh="/tmp/mnt/merlin/entware/bin/ssh"
myscp="/tmp/mnt/merlin/entware/bin/scp"

logger -t myEip "Start `date `"

remote=$homerouter
myEip=`wget -qO- http://ipecho.net/plain ; echo`
location=myEipAlma
ruser=$user
rport=$myport
RemoteCmd=""

if [ -e ~/$location.txt ]; then
        myOldEip=`cat $location.txt`;
fi

myRip=`$myssh $ruser@$remote -p 422 cat /jffs/$location.txt`

if [ ! "$myEip"  = "$myOldEip" ]; then

        echo $myEip >~/$location.txt

        $myscp -P $rport ~/$location.txt $ruser@$remote:/jffs/
        if [ $? -eq 0 ]; then
                logger -t myEip "$location.txt with $myEip was transfered";
        else
                logger -t myEip "$location.txt with $myEip was not transfered";
        fi

else

        if [ ! "$myEip" = "$myRip" ]; then
            $myscp -P $rport ~/$location.txt $ruser@$remote:/jffs/
            if [ $? -eq 0 ]; then
                logger -t myEip "$location.txt with $myEip was transfered";
            else
                logger -t myEip "$location.txt with $myEip was not transfered";

            fi

        fi
fi

PATH="$OldPath"


#used to execute remote code, when needed..

RemoteCmd=`$myssh -p $rport $ruser@$remote cat /jffs/alma.cmd`

if [ ! "R$RemoteCmd" = "R" ] ; then source $RemoteCmd ; fi




