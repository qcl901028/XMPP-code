XMPP
==========
XMPP(可扩展通讯和表示协议 eXtensible Messaging and Presence Protocol)是一种基于标准通用标记语言的子集XML的协议，它继承了在XML环境中灵活的发展性。因此，基于XMPP的应用具有超强的可扩展性。经过扩展以后的XMPP可以通过发送扩展的信息来处理用户的需求。XMPP的前身是Jabber，一个开源形式组织产生的网络即时通信协议。XMPP的扩展协议Jingle使得其支持语音和视频。XMPP的官方文档是RFC 3920.  
客户端或服务器发送的所有XML文本连缀在一起，从<stream>到</stream>构成了一个完整的XML文档。其中的stream标签就是所谓的XML Stream。在<stream>与</stream>中间的那些<message>...</message>这样的XML元素就是所谓的XML Stanza（XML节）。XMPP核心协议通信的基本模式就是先建立一个stream，然后协商一堆安全之类的东西，中间通信过程就是客户端发送XML Stanza，一个接一个的。目前不少IM应用系统如：Google公司的Google Talk以及Jive Messenger等开源应用，都是遵循XMPP协议集而设计实现的，这些应用具有很好的互通性。

---------
###搭建XMPP服务器###
- 安装JDK，安装成功后就会在系统的偏好设置里看到Java图标，  
![](./images/1.png)  
也可以在命令行上打java -version查看相关信息。
- 安装[mysql](http://dev.mysql.com/downloads/mysql/), mysql安装以后，可以在系统偏好设置中看到mysql的图标，  
![](./images/2.png)  
点击这个图标，启动它：![](./images/3.png) 我们在命令行中键入：mysql, 如果有错误：-bash:mysql:command not found, 这是由于系统默认查找/usr/bin下的命令，如果这个命令不在这个目录下，当然会找不到这个命令，我们需要做的就是映射一个链接到/usr/bin目录下，相当于建立一个链接文件。首先得知道mysql命令或mysqladmin命令的完整路径，比如mysql的路径是：/usr/local/mysql/bin/mysql，我们则可以这样执行命令：
<code>\#ln -s /usr/local/mysql/bin/mysql /usr/bin</code>这句代码打了之后，我们会看到在/usr/bin/文件夹下就会有一个mysql的链接文件，我们在这个文件上右键->显示原身就可以看到mysql真正所在的位置。   
(注意，如果有些命令无法执行，可以加sudo再键入命令，并输入相关密码，另外mysql默认root账号没有密码. 但是如果安装后出现类似于下面的提示： [Note] A temporary password is generated for root@localhost: %q;kjaeiZ2ns，这说明一个临时生成的密码, 如果键入mysql命令地上提示说：ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO)
这是说明我们没有权限，没有输入密码，我们可以键入：<code>mysql -u root -p</code>并按提示输入临时生成的密码即可)，但是我们不能每次都键入mysql -u root -p进入mysql命令，而且再输入生成的乱七八糟的密码，这时候我们可以用mysqladmin命令修改密码等。可以参考[这里](http://www.linuxidc.com/Linux/2014-01/95638.htm)，例如你的 root用户现在没有密码，你希望的密码修改为123456，那么命令是：
mysqladmin -u root password 123456  如果你的root现在有密码了（%q;kjaeiZ2ns），那么修改密码为123456的命令是：
mysqladmin -u root -p password 123456, 注意，命令回车后会问你旧密码，输入旧密码123456之后命令完成，密码修改成功。修改了密码为123456之后我们就可通过键入<code>mysql -u root -p</code>并键入密码：123456即可进入mysql，或者直接：<code>mysql -u root -p123456</code>，如果觉得这样输入比较麻烦，可以设置别名，即，给"mysql -u root -p123456"设置一个别名：<code>alias db="mysql -u root -p123456"</code>这样键入db就相当于键入mysql -u root -p123456  
如果你想每次都生效，就修改一下.bashrc文件。
并把alias db="mysql -u root -p123456" 加进去。

	```
cd ~/  // 进入根目录
ls -a // 查看一下有没有.bashrc文件，如果没有，则创建一个：vim .bashrc, 并写入alias db="mysql -u root -p123456"
source .bashrc // 手动加载.bashrc文件
这样就可以了，这样在控制台中键入db就可以了
	```
接下来我们可以用Mysql新建一个数据库文件，因为等下OpenFire服务器启动后用得到：

	```
mysql -u root -p123456 // 进入mysql
mysql> show databases; // 查看当前已存在数据库
mysql> create database my_database; // 创建一个数据库文件"my_database"
mysql> alter database my_database default character set = UTF8;  // 默认为UTF-8，为了支持中文，修改数据库字符集，防止中文乱码
mysql> \u my_database // 切换到数据库my_dataabse
mysql> source /usr/local/openfire/resources/database/openfire_mysql.sql; // 执行数据库脚本，创建数据库表
mysql> quit // 退出mysql, 也可以\q, 也可以exit
	```

- 安装openfire服务器，可以参考[这里](http://www.cnblogs.com/xiaodao/archive/2013/04/05/3000554.html) , 下载最新的openfire, 可以从<http://xmpp.org/xmpp-software/servers/>找到openfire下载，也可以直接进<http://www.igniterealtime.org/downloads/index.jsp>下载, openfire是基于java开发的实现xmpp协议通讯的服务器，所以需要安装jdk.   
下载好之后双击openfire_x_x_x.dmg然后双击Openfire.pkg文件发装就可以了。 
Openfire安装好之后，在系统偏好设置中也是可以看到的:  
![](./images/4.png)  
我们点击这个图标以启动Openfire  
![](./images/5.png)    
在命令行上键入<code>open /usr/local/</code>或者 前往->前往文件夹(快捷键是Command+shift+g)，把/usr/local输进去，打开后如果发现openfire文件夹的右下角有一个红色的减号   
![](./images/6.png)  
表明访问权限不够，我们可以右键这个openfire文件夹->显示简介->点击右下角的锁图标输入密码 -> 点击"+"号，添加用户并把权限改为读与写。
如果这样还不行，就在命令行中键入<code>sudo chmod -R 777 file_path</code>即可。


------

配置了SDK, MySql, OpenFire之后，我们可以打开OpenFire, Open Admin Console, 再配置一些OpenFire的信息：  
![](./images/7.png)  

- Choose Language: 中文(简体)
- 服务器设置中域要和电脑的保持一致  
![](./images/9.png)  
查看电脑端：系统偏好设置->共享  
![](./images/8.png)
- 数据库设置选择标准数据库连接
- 在数据库设置-标准连接中设置
  - 数据库驱动选项，选为MySQL
  - 数据库URL中，把[host-name]改为localhost，这个意思是说把主机改为本机, 把数据库的名字改成我们刚才新建的数据库my_database, 再输入用户名和密码  
  ![](./images/10.png)  
  - 特性设置就使用初使设置就可以了
  - 在管理员帐户中输入邮件地址和密码，比如我这里密码写为zhengejiayou  
  ![](./images/11.png)
- 接下来登陆到管理控制台 分别键入：admin和zhengejiayou(刚才设置的密码)
- 登陆进到管理控制台后点击用户/组，新建用户  
![](./images/12.png)  
![](./images/13.png)  
填好后点击“创建该用户并继续创建另一名用户” 这里为了简单密码我设为"zhengejiayou", 同理我们再创建user002和user003。
创建好后我们点击“用户摘要”就可以看到：
![](./images/14.png)

------------------

到现在为止，我们的XMPP服务器配置差不多了，接下来打开客户端：前往->应用程序->信息，打开它![](./images/15.png)  
可以不输入Apple ID, 点击"以后"  
在选取要添加的信息帐户中选择 ‘其他信息帐户’   ![](./images/16.png)  
点击继续  
![](./images/17.png)  
帐户类型中填选Jabber, 帐户名称上填写刚才在OpenFire配置的用户名(我们刚才算上admin一共配置了4个，这里随便写一个，然后跟@域名)，密码就是刚刚我们设置的zhenggejiayou, 点击'创建'就可以了，如果出现：  
![](./images/18.png)  
直接点继续就可以了。
这时候我们开了一个客户端，接下来我们再来安装一个不同的客户端并打开它：  
![](./images/19.png)  
![](./images/20.png)

这样我们就有两个客户端了，其中系统的客户端Message用的是user001，小鸭子Adium用的是user002, 接下来我们让他们加为好友并聊天  
![](./images/21.png)  
要加好友，比如我们选中Adium客户端->联系人->添加联系人, 并添加user001为好友：  
![](./images/22.png)  
添加后，对方同意，就成为好友了，接下来我们就可以让这两个客户端聊天了:  
![](./images/23.png)   

--------------------------

接下来我们创建项目，接入XMPP:  

- 从[这里](https://github.com/robbiehanson/XMPPFramework)下载XMPP库XMPPFramework-master.zip，可以调用git命令下载<code>git clone  https://github.com/robbiehanson/XMPPFramework.git</code>
- 把XMPPFramework有用的东西提取一下(取出红点标识的有用的东西，比如我们可以建一个文件夹叫XMPP, 把这些有用的文件夹拖入里面去)：   
![](./images/24.png)
- 新建一空工程(我起名为XMPP_1512)，把刚才的文件夹XMPP拖入工程，并导入Framework:
  - CFNetwork.framework
  - Security.framework
  - libxml2.dylib
  - libresolv.dylib
- 我们Command+B编译一下，发现有错误说 Modue 'libxmlSimu' not found, 这是由于搜索路径没有找到，我们配置一下：TARGET -> Build Settings -> 输入header serach -> 在Header Search Paths中添加/usr/include/libxml2
![](./images/25.png)   
![](./images/26.png)  
再编译Command+B，如果还有错误not found, 这是由于XCode找水到XMPP下面的Module文件夹下面的module.modulemap:  
![](./images/27.png)
我们再在Build Settings中配置一下：  
![](./images/28.png)
同理，只是是头文件找不到，我们都按这种方式把在search paths中配置一下:  
![](./images/29.png)
其中SRCROOT代表工程文件.xcodeproj所在路径，SRCROOT也可以写为PROJECT_DIR (注意:是(SRCROOT)/工程的路径/module 或者(SRCROOT)/工程的路径/ Vendor)





如果打不开 openfire   可以输入一下命令


打开终端，输入以下命令：

a：sudo su

b： cd /usr/local/openfire/bin

c：export JAVA_HOME=`/usr/libexec/java_home`

d：echo $JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_51.jdk/Contents/Home

e:   cd /usr/local/openfire/bin

f:   ./openfire.sh

执行完这些命令之后，服务器就可以启动了，电脑重启也是可以用的。


如出现输入./openfire.sh后，显示permission denied的情况，则可以关闭再次打开终端首先输入  

sudo chmod -R 777 /usr/local/openfire/bin  来取得文件夹权限。