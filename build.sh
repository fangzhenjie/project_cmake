#用于工程编译以及传输执行固件到局域网下的目标板，使用如下：
 #
 # ./lisinbuild,sh -u root -p root -i 192.168.1.20 -s lisinmtr -h /usr/local/lisin/bin
 #
 # -u :ssh用户
 # -p :ssh用户密码
 # -i :ssh用户地址
 # -s :需要传输的源文件
 # -h :ssh用户的传输目标地址 
 #
 # -u -p -i -s -h 参数都不加上去的情况下使用默认参数：
 #login_usr_default, login_pswd_default, login_ip_default, exe_bin_default, lisin_bin_path_default
 #
 #注意：修改后的参数会保存在[buildcfg]配置文件里，每次运行都会先读取配置文件里的信息！！！！
 #
 # @FilePath: \lisin_project\lisinbuild.sh
 # @*******: ********************************************************
### 


#!/bin/bash

#开发主机相关信息,当前build.sh放的地方
dirCurrent=`pwd`

#放CMake编译生成文件的地方
dirCompile=$dirCurrent/build

#默认要传输的文件设置,传输的文件名
exe_bin_default=lisinmtr

#局域网的设备 信息
#login_user ssh的登录账户
login_usr_default="root"
#login_passwd ssh的登录密码
login_pswd_default="root"
#login_ip ssh的ip
login_ip_default="192.168.1.20"
#工作目录 上面传输的文件要放的位置
lisin_bin_path_default="/usr/local/lisin/bin"



# Initial directory
rm -rf $dirCompile  #每次都重新编译，删除build文件
mkdir -p $dirCompile #创建build文件
cd $dirCompile


# Run cmake
cmake $dirCurrent  #编译cmake



# Run make
cmd_res=$? #判断编译的时候是否跟着参数

if [ $cmd_res -eq 0 ];then
    echo "Make \`Makefile\` complete."
    make -j4
else
    echo "[Err:$cmd_res] \`cmake\` faild."
    exit 1
fi



# make install
cmd_res=$?

if [ $cmd_res -eq 0 ];then
    echo "Compilation complete."
    make install #生成的文件安装
else
    echo "[Err:$cmd_res] \`make\` faild."
    exit 2
fi



# Copy executable to NUC980
cmd_res=$?

if [ $cmd_res -eq 0 ];then

    cd $dirCurrent

    # 读取配置文件
    cfg_file="$dirCurrent/buildcfg"

		# 检测配置文件是否存在
    if [ ! -f $cfg_file ]; then
				
				#如果不存在，赋值上面默认的数据
        echo "touch $cfg_file!!!"
        echo "login_user=$login_usr_default" > $cfg_file
        echo "login_pswd=$login_pswd_default" >> $cfg_file
        echo "login_host=$login_ip_default" >> $cfg_file
        echo "exe_bin=$exe_bin_default" >> $cfg_file
        echo "dest_path=$lisin_bin_path_default" >> $cfg_file

        _exe_bin=$exe_bin_default
        _login_user=$login_usr_default
        _login_pswd=$login_pswd_default
        _login_host=$login_ip_default
        _dest_path=$lisin_bin_path_default

    else
				#如果存在读取这些值
        echo "read buildcfg..."

				#找出配置文件中的值
        _login_user=`sed '/^login_user=/!d;s/.*=//;s/\r//g' $cfg_file`
        _login_pswd=`sed '/^login_pswd=/!d;s/.*=//;s/\r//g' $cfg_file`
        _login_host=`sed '/^login_host=/!d;s/.*=//;s/\r//g' $cfg_file`
        _exe_bin=`sed '/^exe_bin=/!d;s/.*=//;s/\r//g' $cfg_file`
        _dest_path=`sed '/^dest_path=/!d;s/.*=//;s/\r//g' $cfg_file`

				#如果某个值为空，使用默认的值，保存默认的值到配置文件
        if [ "$_exe_bin" = "" ]; then
            echo "login_user=$login_usr_default" >> $cfg_file
            _exe_bin=$exe_bin_default
        fi
        

        if [ "$_login_user" = "" ]; then
            echo "login_pswd=$login_pswd_default" >> $cfg_file
            _login_user=$login_usr_default
        fi

        if [ "$_login_pswd" = "" ]; then
            echo "login_host=$login_ip_default" >> $cfg_file
            _login_pswd=$login_pswd_default
        fi

        if [ "$_login_host" = "" ]; then
            echo "exe_bin=$exe_bin_default" >> $cfg_file
            _login_host=$login_ip_default
        fi

        if [ "$_dest_path" = "" ]; then
            echo "dest_path=$lisin_bin_path_default" >> $cfg_file
            _dest_path=$lisin_bin_path_default
        fi


    fi

    #参数输入
    exe_bin="${_exe_bin}"
    login_user="${_login_user}"
    login_pswd="${_login_pswd}"
    login_host="${_login_host}"
    dest_path="${_dest_path}"
  


    #读取外部输入参数
    while getopts ":u:p:i:s:h:" opt
    do
        case $opt in
            u)
            login_user=$OPTARG
            ;;
            p)
            login_pswd=$OPTARG
            ;;
            i)
            login_host=$OPTARG
            ;;
            s)
            exe_bin=$OPTARG
            ;;
            h)
            dest_path=$OPTARG
            ;;
            ?)
            echo "args error,using default args!!!!"
            ;;
        esac
    done

    #更新配置文件
    if [ "$exe_bin" != "$_exe_bin" ]; then
        echo "replace exe_bin!"
        sed -i "/^exe_bin=/c\exe_bin=${exe_bin}" $cfg_file
    fi

    if  [ "$login_user" != "$_login_user" ]; then
        echo "replace login_user!"
        sed -i "/^login_user=/c\login_user=${login_user}" $cfg_file
    fi

    if  [ "$login_pswd" != "$_login_pswd" ]; then
        echo "replace login_pswd!"
        sed -i "/^login_pswd=/c\login_pswd=${login_pswd}" $cfg_file
    fi

    if  [ "$login_host" != "$_login_host" ]; then
        echo "replace login_host!"
        sed -i "/^login_host=/c\login_host=${login_host}" $cfg_file
    fi
       
    if  [ "$dest_path" != "$_dest_path" ]; then
        echo "replace dest_path!"
        sed -i "/^dest_path=/c\dest_path=${dest_path}" $cfg_file
    fi

    #传输的路径一般为主目录下的bin目录，因为cmake会把生成的执行文件通过make install安装到固定的位置bin目录下。
    dirbin=${dirCurrent}/bin/${exe_bin} 
    exe_bin_bkp=${exe_bin}_bkp

    # 判断是否安装 sshpass , 若未安装则安装
    which "sshpass" > /dev/null
    if [ $? == 0 ]; then
        echo "\`sshpass\` Installed. Start copy file..."
    else
        sudo apt-get -y install sshpass 
    fi

#这是sshpass的使用
## 免密码登录
#$ sshpass -p password ssh username@host

# 远程执行命令
#$ sshpass -p password ssh username@host <cmd>

# 通过scp上传文件
#$ sshpass -p password scp local_file root@host:remote_file 

# 通过scp下载文件
#$ sshpass -p password scp root@host:remote_file local_file


    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo "Copying $dirbin to $login_user@$login_host[$login_pswd]:$dest_path ..."
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    

    # CmdKill="ps | grep "${exe_bin}" | grep -v grep | awk '{print $1}' | xargs kill -9" 

    # sshpass -p $login_pswd ssh -o StrictHostKeyChecking=no $login_user@$login_host "$CmdKill"
    # 执行创建文件夹指令
    sshpass -p $login_pswd ssh -o StrictHostKeyChecking=no $login_user@$login_host "mkdir -p $dest_path"
    # 把之前的可执行文件修改名字
    sshpass -p $login_pswd ssh -o StrictHostKeyChecking=no $login_user@$login_host "mv $dest_path/$exe_bin $dest_path/$exe_bin_bkp"
    # 把之前的可执行文件修改名字,把可执行文件传输过去
    sshpass -p $login_pswd scp -o StrictHostKeyChecking=no "$dirbin" $login_user@$login_host:"$dest_path"

else
    echo "[Err:$cmd_res] \`make\` faild."
    exit 3

fi