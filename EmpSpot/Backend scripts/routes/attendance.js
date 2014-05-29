var common_function =require('./common_functions');
var md5 = require('MD5');
var math = require('math'); 

exports.AttendanceEntryFromIOS=function(req,res){
    res.header("Access-Control-Allow-Origin", "*");
    console.log(req.body);
    var user_id=req.body.user_id; 
    var in_out_flag=req.body.in_out_flag;
    var date=new Date();
    var present_absent_flag=1;
    
    var arr = [user_id,in_out_flag];

    var check_blank = common_function.CheckBlank(arr);
    if (check_blank === 1)
    {
        var response0 = {"error": 'Some parameter missing'};
        res.send(JSON.parse(JSON.stringify(response0)));
    }
    else {
        console.log(req.body);
        var length0=4;
        var str = '';
        var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; 
        var size = chars.length;
        for (var i = 0; i < length0; i++) {
            var randomnumber = math.floor(math.random() * size);
            str = chars[randomnumber] + str;
        }
        console.log("str")
        console.log(str)
        console.log(req.files);
        var timestamp = new Date().getTime().toString();
        req.files.image.name = str + timestamp + "-" + req.files.image.name;
        common_function.UploadImageToS3Bucket(req.files.image,'clicked_images',function(result_img_name0){
            if(result_img_name0==0){
                var response1 = {"error": 'File Upload Error'};
                res.send(JSON.parse(JSON.stringify(response1)));
            }
            else{
                if(in_out_flag==1){          // For IN
                    
                    console.log("date");
                    console.log(date);
                    var sql="UPDATE `attendence` SET `in_time`=?,`clicked_image_in_time`=?,`present_absent_flag`=? WHERE `user_id`=?";   //AND `date`=?
                    connection.query(sql,[date,result_img_name0,present_absent_flag,user_id],function(err,result2){
                        if(!err){
                            var sql_1="UPDATE `users` SET `in_out_flag`=? WHERE `user_id`=?";
                            connection.query(sql_1,[in_out_flag,user_id],function(err,result_1){
                                if(!err){
                                    var response={"log":'Entry successful'};
                                    res.send(JSON.parse(JSON.stringify(response)));
                                }
                                else{
                                    console.log(err)
                                    var response1={"error":'Something went wrong'};
                                    res.send(JSON.parse(JSON.stringify(response1)));
                                }
                            });
                            var response={"log":'Entry successful'};
                            res.send(JSON.parse(JSON.stringify(response)));
                        }
                        else{
                            console.log(err)
                            var response1={"error":'Something went wrong'};
                            res.send(JSON.parse(JSON.stringify(response1)));
                        }
                    });
                }
                else{                       // For OUT
                   var sql2="UPDATE `attendence` SET `out_time`=?,`clicked_image_out_time`=?,`present_absent_flag`=? WHERE `user_id`=?";   //AND `date`=?
                    connection.query(sql2,[date,result_img_name0,present_absent_flag,user_id],function(err,result2){
                        if(!err){
                            var sql_2="UPDATE `users` SET `in_out_flag`=? WHERE `user_id`=?";
                            connection.query(sql_2,[in_out_flag,user_id],function(err,result_2){
                                if(!err){
                                    var response={"log":'Exit successful'};
                                    res.send(JSON.parse(JSON.stringify(response)));
                                }
                                else{
                                    console.log(err)
                                    var response1={"error":'Something went wrong'};
                                    res.send(JSON.parse(JSON.stringify(response1)));
                                }
                            });
                            
                        }
                        else{
                            console.log(err)
                            var response1={"error":'Something went wrong'};
                            res.send(JSON.parse(JSON.stringify(response1)));
                        }
                    }); 
                }
            }
        });
    }
};