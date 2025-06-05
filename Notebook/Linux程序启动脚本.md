---
aliases:
  - Linux程序启动脚本示例
tags:
  - Linux
---
## Shell 脚本

**Linux 程序启动脚本**
```
#!/bin/bash

_oper='start'
[ -z $1 ] || _oper=$1
_prog="NMediaServ*"
_path=/opt/kdm/nmedia/
_config=

cd $_path

function service_ctl() {
     case $_oper in
	'start')
        while true ;do 
			pidof NMediaService >/dev/null && pidof NMediaServer >/dev/null || $_path/start
			pidof http_svr >/dev/null || /opt/kdm/webrtcdemo/start
			sleep 10
		done
        ;;
	'stop')
     	$_path/stop
	 	/opt/kdm/webrtcdemo/stop
	;;
	'restart')
		bash `basename $0`  stop
		bash `basename $0`  start
        ;;
	'status')
		ps -A|grep  NMediaServ && exit 0
	;;
	*)
	echo "bash `basename $0` 'start|restart|status|stop' "
	;;
    esac
}

service_ctl
```

**Linux CPU 监控**
```
#!/bin/bash  
# Example: 
#         sh cpu_consumer.sh 
#         sh cpu_consumer.sh 2 
#         sh cpu_consumer.sh stop 


loop_consumer="while :; do echo >/dev/null; done &"
if [[ $# > 2 ]]; then
    echo "USAGE: $0 [stop]"
    exit 1;
elif [[ $1 == *[0-9]* ]]; then
    cpunum=$1
elif [[ $1 = "stop" ]]; then
    ps -ef | grep "$loop_consumer" | grep -v grep | kill -9 `awk '{print $2}'`
    exit 0
else
    cpunum=`cat /proc/cpuinfo | grep processor | wc -l`
fi

for i in `seq ${cpunum}`
do
    /bin/bash -c "$loop_consumer"
done

```