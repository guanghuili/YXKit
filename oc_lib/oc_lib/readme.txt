//标准版



项目组织架构

	一，项目目录
		
		AppDelegate：这个目录下放的是AppDelegate.h(.m)文件，是整个应用的入口文件，所以单独拿出来。


		Models：这个目录下放一些与数据相关的Model文件，里面大概是这样：
				
			|- BaseModel.h

			|- BaseModel.m

			|- CollectionModel.h

			|- CollectionModel.m


		Macro ：这个目录下放了整个应用会用到的宏定义，里面大概是这样：


			|- AppMacro.h   AppMacro.h 里放app相关的宏定义

	    	|- NotificationMacro.h

			|- VendorMacro.h

			|- UtilsMacro.h

	   General ：

		这个目录放会被重用的Views/Classes和Categories。里面大概是这样：

			|- Views

				|- TPKScollView

				|- TPKPullToRefresh


			|- Classes

				|- TPKBaseViewController

				|- TPKHorizontalView


			| - Categories

				|- UIViewController+Sizzle

				|- UIImageView+Downloader


		Helpers ：

			这个目录放一些助手类，文件名与功能挂钩。里助手类的主要作用是帮助Controller瘦身，也可以提供一定程度的复用。

		Vendors ：

			这个目录放第三方的类库/SDK，如UMeng、WeiboSDK、WeixinSDK等等。

		Sections ：

				这个目录下面的文件对应的是app的具体单元，如导航、瀑布流等等。里面大概是这样：


		Resources

			这个目录下放的是app会用到的一些资源，主要是图片。
