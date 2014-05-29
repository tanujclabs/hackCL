var common_function =require('./common_functions');
var md5 = require('MD5');
var math = require('math'); 

/*
 * -----------------------------------------------------------------------------
 * List Users
 * INPUT : user_name,email,password
 * OUTPUT: user_id,access_token,user_name,image
 * -----------------------------------------------------------------------------
 */

exports.ListUsersToIOS = function(req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    var device_token=req.body.device_token;    
    
    var arr = [device_token];

    var check_blank = common_function.CheckBlank(arr);
    if (check_blank === 1)
    {
        var response = {"error": 'Some parameter missing'};
        res.send(JSON.parse(JSON.stringify(response)));
    }
    else {
        if(device_token=='device_token'){
            var sql="SELECT `user_id`,`user_name`,`pin`,`user_image`,`in_out_flag` FROM `users`";
            connection.query(sql,function(err,result){
                if(!err){
                    var result_length=result.length;
                    for(var i=0;i<result_length;i++){
                        result[i].user_image='http://empspot.s3.amazonaws.com/user_images/'+result[i].user_image;
                    }
                    var response1={"data":result};
                    res.send(JSON.parse(JSON.stringify(response1)));
                }
                else{
                    
                }
            });
        }
        else{
            var response2={"error":'Device is not registered with us.'};
            res.send(JSON.parse(JSON.stringify(response2)));
        }
    }
}

exports.AddNewUserFromWebPanel = function(req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    var user_name=req.body.user_name;    
    var email_id=req.body.email_id;
    var phone=req.body.phone;
    var pic=req.body.pic;
    
    console.log(user_name)
    console.log(email_id)
    
    var arr = [user_name,email_id,phone,pic];

    var check_blank = common_function.CheckBlank(arr);
    if (check_blank === 1)
    {
        var response0 = {"error": 'Some parameter missing'};
        res.send(JSON.parse(JSON.stringify(response0)));
    }
    else {
        var sql0="SELECT `user_id` FROM `users` WHERE `email_id`=? LIMIT 1";
        connection.query(sql0,[email_id,phone],function(err,result0){
            if(result0.length > 0){
                var resp2 = {"error": 'User with this email already exist'};
                res.send(JSON.parse(JSON.stringify(resp2)));
            }
            else{
                if(pic==1){
                    console.log(req.files);                                       
                    var timestamp = new Date().getTime().toString();
                    var length0 = 4;

                    var pin0 = '';
                    var digits0="123456789";
                    var size0 = digits0.length;
                    for (var i0 = 0; i0 < length0; i0++) {
                        var randomnumber0 = math.floor(math.random() * size0);
                        pin0 = digits0[randomnumber0] + pin0;
                    }
                    console.log("pin0")
                    console.log(pin0)
                   

                    var str = '';
                    var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; 
                    var size = chars.length;
                    for (var i = 0; i < length0; i++) {
                        var randomnumber = math.floor(math.random() * size);
                        str = chars[randomnumber] + str;
                    }
                    console.log("str")
                    console.log(str)
                    req.files.image.name = str + timestamp + "-" + req.files.image.name;
                    common_function.UploadImageToS3Bucket(req.files.image,'user_images',function(result_img_name0){
                        if(result_img_name0==0){
                            var response1 = {"error": 'File Upload Error'};
                            res.send(JSON.parse(JSON.stringify(response1)));
                        }
                        else{
                            var in_out_flag=0;
                            var sql2="INSERT INTO `users`(`email_id`,`user_name`,`pin`,`in_out_flag`,`user_image`,`phone`) VALUES(?,?,?,?,?,?)";
                            connection.query(sql2,[email_id,user_name,pin0,in_out_flag,result_img_name0,phone],function(err,result2){
                                if(!err){
                                    var response2 = {"log": 'User added successfully'};
                                    res.send(JSON.parse(JSON.stringify(response2)));
                                }
                                else{
                                    var response3 = {"error": 'File Upload Error'};
                                    res.send(JSON.parse(JSON.stringify(response3)));
                                }
                            });
                        }
                    });
                }
                else{
                    var length = 4;
                    
                    var pin = '';
                    var digits="0123456789";
                    var size0 = digits.length;
                    for (var i = 0; i < length; i++) {
                        var randomnumber0 = math.floor(math.random() * size0);
                        pin = digits[randomnumber0] + pin;
                    }
                    var in_out_flag=0;
                    var result_img_name='anonymous.jpeg';
                    var sql3="INSERT INTO `users`(`email_id`,`user_name`,`pin`,`in_out_flag`,`user_image`,`phone`) VALUES(?,?,?,?,?,?)";
                    connection.query(sql3,[email_id,user_name,pin,in_out_flag,result_img_name,phone],function(err,result3){
                        if(!err){
                            var approval_flag=1;
                            var date=new Date();
                            date.setMinutes(date.getMinutes() + 330);
                            var sql4="INSERT INTO `attendence`(`user_id`,`date`,`user_name`) VALUES(?,?,?,?)";
                            connection.query(sql4,[result3.insertId,date,user_name],function(err,result4){
                                console.log(err)
                                console.log(result4)
                                if(err){
                                    var response1={"error":'Something went wrong'};
                                    res.send(JSON.parse(JSON.stringify(response1)));
                                }
                            });
                            var response2 = {"log": 'User added successfully'};
                            res.send(JSON.parse(JSON.stringify(response2)));
                        }
                        else{
                            var response3 = {"error": 'File Upload Error'};
                            res.send(JSON.parse(JSON.stringify(response3)));
                        }
                    });                        
                }
                
            }
        });
    }
}


