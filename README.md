# Android常用多渠道打包方式实践

##[demo](https://github.com/andoop/ApkPackTest)

###多渠道打包用处
---
>打包就是对根据签名和其他标识生成安装包，渠道包就是要在安装包中添加渠道信息，也就是channel，对应不同的渠道，例如：小米市场、360市场、应用宝市场，我们要在安装包中添加不同的标识，应用在请求网络的时候携带渠道信息，方便后台做运营统计（这就是添加渠道信息的用处）。现在android渠道多种多样，其实渠道不仅仅局限于应用市场，一种推广方式也可以看做一个渠道，比如：通过人拉人的方式去推广，官网上推广，百度推广等。所以说渠道成千上万，为了推广，有时候一次也会打成千的安装包，那你半天或者一天啥都别干了，所以介绍几个大公司高效的打包方式，借鉴一下

###我们平常是这样打包的---友盟多渠道打包方式

####原理

>读取meta-data中渠道信息

####方法

>1、 在AndroidManifest.xml清单文件中，添加meta-data信息：

 	 <meta-data android:name="UMENG_CHANNEL" android:value="${UMENG_CHANNEL_VALUE}"/>

>UMENG_CHANNEL是渠道的key，${UMENG_CHANNEL_VALUE}是渠道的value，它只是一个变量，最后会被赋值

>2、 在模块下的build.gradle的android {}中添加productFlavors：


		 productFlavors{
		        wandoujia{
		           manifestPlaceholders = [UMENG_CHANNEL_VALUE: "wandoujia"]
		        }
		        xiaomi{
		           manifestPlaceholders=[UMENG_CHANNEL_VALUE: "xiaomi"]
		        }
		    }
	
>如上面的有两个渠道：wandoujia和xiaomi，在签名打包的时候就可以选择其中之一或者全选进行打包，他们会分别将meta-data中的${UMENG_CHANNEL_VALUE}替换为wandoujia和xiaomi

>3、优化1

>上面只是两个渠道，如果有几十个渠道，都这样写，重复的东西太多，观察到每个渠道就是flavor的名称，所以修改如下：

	 productFlavors{
	        wandoujia{
	            //manifestPlaceholders = [UMENG_CHANNEL_VALUE: "wandoujia"]
	        }
	        xiaomi{
	            //manifestPlaceholders=[UMENG_CHANNEL_VALUE: "xiaomi"]
	        }
	    }
	    productFlavors.all { flavor ->
	        flavor.manifestPlaceholders = [UMENG_CHANNEL_VALUE: name]
	    }

>只是添加了：

	 productFlavors.all { flavor ->
		        flavor.manifestPlaceholders = [UMENG_CHANNEL_VALUE: name]
		    }
>就是一个for循环，遍历所有flavor，将其名称替换${UMENG_CHANNEL_VALUE}

>4、优化2

>上面经过签名打包后生成的apk的名称是有默认命名规则的，如：xxx-xiaomi-release.apk
>但是我们想包含版本信息如：xxx-xiaomi-release-1.0.apk,所以最终打包脚本如下：

	  productFlavors{
	        wandoujia{
	            //manifestPlaceholders = [UMENG_CHANNEL_VALUE: "wandoujia"]
	        }
	        xiaomi{
	            //manifestPlaceholders=[UMENG_CHANNEL_VALUE: "xiaomi"]
	        }
	    }
	    productFlavors.all { flavor ->
	        flavor.manifestPlaceholders = [UMENG_CHANNEL_VALUE: name]
	    }
	    applicationVariants.all { variant ->
	        variant.outputs.each { output ->
	            def outputFile = output.outputFile
	            if (outputFile != null && outputFile.name.endsWith('.apk')) {
	                def fileName = outputFile.name.replace(".apk", "-${defaultConfig.versionName}.apk")
	                output.outputFile = new File(outputFile.parent, fileName)
	            }
	        }
	    }

>通过：`outputFile.name.replace(".apk", "-${defaultConfig.versionName}.apk")`将versonName添加到了安装包的名称中

>5、获取渠道

>在代码中我们可以通过读取mate-data信息来获取渠道，然后添加到请求参数中，获取方法如下：

    private String getChannel() {
        try {
            PackageManager pm = getPackageManager();
            ApplicationInfo appInfo = pm.getApplicationInfo(getPackageName(), PackageManager.GET_META_DATA);
            return appInfo.metaData.getString("UMENG_CHANNEL");
        } catch (PackageManager.NameNotFoundException ignored) {
        }
        return "";
    }

####缺点

>这样的打包方式效率比较低下，如果是几十个包还可以应付，打一个包快的话需要十几秒，慢的话需要几分钟不等，跟机器性能很有关系

---

###[美团多渠道打包](http://tech.meituan.com/mt-apk-packaging.html)

####原理

>把一个Android应用包当作zip文件包进行解压，然后发现在签名生成的目录下(META-INF)添加一个空文件不需要重新签名。利用这个机制，该文件的文件名就是渠道名。这种方式不需要重新签名等步骤，非常高效。

####方法（[使用美团提供的打包工具](https://github.com/andoop/AndroidMultiChannelBuildTool)）

>在[demo](https://github.com/andoop/ApkPackTest)中已经将美团的打包工具放到了test01文件中

>1、将要打包的apk放到PythonTool中

>2、在PythonTool/info/channel.txt中写入需要的渠道，一个渠道占一行

>3、双击执行PythonTool/MultiChannelBuildTool.py文件（需要Python环境），就会生成渠道包

>4、获取渠道信息：将JavaUtil文件中的ChannelUtil.java拷贝到工程，调用ChannelUtil.getChannel即可获取渠道
####优点
>这种打包方式速度非常快，900多个渠道不到一分钟就能打完(没有亲试)

####缺点

>1、google如果哪天更改打包规则，使得在META-INF中建立空文件还需要重新打包，这种方式将不可用

>2、一些不法的渠道商很容易通过工具修改渠道，如果一个渠道商，通过网络劫持和篡改渠道的组合方式来获取暴利，对于程序开发者来说可能会存在着巨大的经济损失

---

###360多渠道打包

####原理

>apk文件本质就是zip文件,利用zip文件“可以添加comment（摘要）”的数据结构特点，在文件的末尾写入任意数据，而不用重新解压zip文件，我们就可以将渠道信息写入摘要区

####用法（[360多渠道打包工具](https://github.com/andoop/MultiChannelPackageTool)）

>已经将360多渠道打包工具放入了[demo](https://github.com/andoop/ApkPackTest)的test02文件中

>1、将要写入渠道信息的apk放入MCPTool文件夹中

>2、修改MCPTool.bat批处理文件，更改渠道和密码（渠道信息为了安全需要加密）

>3、将apk拖到MCPTool.bat上执行，将会生成渠道包

>4、修改MCPTool-check.bat中的密码和MCPTool.bat中的密码一致

>5、将渠道包拖到MCPTool-check.bat上执行，就可以检查渠道信息是否正确

>6、获取渠道：将MCPTool.java添加到工程或者将MCPTool.jar导入工程，调用`MCPTool.getChannelId(this,"12345678","")` 第一个参数为context，第二个是密码，第三个是默认值

>[详细使用方法介绍](https://github.com/andoop/MultiChannelPackageTool)
####优点
>1、5M的apk，1秒种能打300个(作者亲试)

>2、在下载apk的同时，服务端可以写入一些信息，例如邀请码，分享信息等

####缺点

>渠道信息也是很容易修改，虽然可以加密，只是提高了修改的门槛

###
主要参考：https://mp.weixin.qq.com/s?__biz=MzA4MzEwOTkyMQ==&mid=2667374595&idx=1&sn=96fe214204da55caa3e583039352f57c&scene=1&srcid=0526z8qs53Na9zgREPwwnwDo&key=f5c31ae61525f82e5eef53cc0fef95064d607ec207c7c97b0ef3c414a5763622ab45f2a4ee73fef99080a2473c6ec7f1&ascene=0&uin=MTYzMjY2MTE1&devicetype=iMac+MacBookPro10%2C1+OSX+OSX+10.11.4+build(15E65)&version=11020201&pass_ticket=JtFbOWzVz0QaHe5dN1epxdryv2HEDINGpaqXxeWcwGI%3D