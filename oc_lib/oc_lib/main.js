require('UIColor,UIView,UIAlertView,HTTPWorker,Weather,NSObject,Class')
defineClass("AppDelegate", {
           
   
    changeBackground:function() {
        
      
            HTTPWorker.shareWorker().GETResponseObject_objClass_url_parameters_success_failure(self.window(),Weather.class(),'http://www.weather.com.cn/data/sk/101010100.html',null,block('Weather *',function(w){
                                                                                                                                                                                            
                                                                                                                                                                        
                                                                                                                                                                                            
                                                                                                                                                                                           console.log(w);
                                                                                                                                                                                        
                                                                                                                                                                                            
                                                                                                                                                                                            }),null);
          
    },
            

            
});
