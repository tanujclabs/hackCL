exports.AutomaticAbsentEntriesInMorning=function(req,res){
    var sql="SELECT `user_id`,`user_name` FROM `users`";
    connection.query(sql,function(err,result){
        console.log(err)
        console.log(result)
        if(!err){
            if(result.length > 0){
                var result_length=result.length;
                var approval_flag=1;
                var date=new Date();
                date.setMinutes(date.getMinutes() + 330);
                for(var i=0;i<result_length;i++){
                    var sql2="INSERT INTO `attendence`(`user_id`,`date`,`user_name`,`approval_flag`) VALUES(?,?,?,?)";
                    connection.query(sql2,[result[i].user_id,date,result[i].user_name,approval_flag],function(err,result2){
                        console.log(err)
                        console.log(result2)
                        if(err){
                            var response1={"error":'Something went wrong'};
                            res.send(JSON.parse(JSON.stringify(response1)));
                        }
                    });
                }
                var response={"log":'Chrone successful'};
                res.send(JSON.parse(JSON.stringify(response)));
            }
        }
        else{
            var response2={"error":'Something went wrong'};
            res.send(JSON.parse(JSON.stringify(response2)));
        }
    });
};