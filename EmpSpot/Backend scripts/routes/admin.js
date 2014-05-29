var common_function = require('./common_functions');

exports.ViewTodayAttendanceWebPanel = function(req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    var date = req.body.date;
    var sql = "SELECT `user_id`,`user_name`,`pin`,`user_image`,`email_id`,`phone` FROM `users`";
    connection.query(sql, function(err, result) {
        if (!err) {
//            console.log("result")
//            console.log(result)
            if (result.length > 0) {
                var result_length = result.length;
                var arr_user_ids = [];
                for (var i = 0; i < result_length; i++) {
                    arr_user_ids.push(result[i].user_id);
                }
                var str_user_ids = arr_user_ids.toString();

//                date.setMinutes(date.getMinutes() - 330);
//                console.log(date);
                var sql2 = "SELECT `attendence_id`,`user_id`,`in_time`,`out_time`,`clicked_image_in_time`,`clicked_image_out_time`,`present_absent_flag` FROM `attendence` WHERE `user_id` IN(" + str_user_ids + ") AND `date`=?";    // AND DATE
                connection.query(sql2, [date], function(err, result2) {
                    if (!err) {
//                        console.log("result2")
//                        console.log(result2)
                        if (result2.length > 0) {
                            var result2_length = result2.length;
                            var final_arr = [];
                            for (var j = 0; j < result_length; j++) {
                                for (var k = 0; k < result2_length; k++) {
                                    if (result[j].user_id == result2[k].user_id) {
                                        if (result2[k].in_time !== '0000-00-00 00:00:00') {
                                            result2[k].in_time = result2[k].in_time.toISOString().replace(/T/, ' ').replace(/\..+/, '');
                                        }
                                        if (result2[k].out_time !== '0000-00-00 00:00:00') {
                                            result2[k].out_time = result2[k].out_time.toISOString().replace(/T/, ' ').replace(/\..+/, '');
                                        }
                                        if(result[j].user_image!=''){
                                            result[j].user_image='http://empspot.s3.amazonaws.com/user_images/' +result[j].user_image;
                                        }
                                        if(result2[k].clicked_image_in_time!=''){
                                            result2[k].clicked_image_in_time='http://empspot.s3.amazonaws.com/clicked_images/' +result2[k].clicked_image_in_time;
                                        }
                                        if(result2[k].clicked_image_out_time!=''){
                                            result2[k].clicked_image_out_time='http://empspot.s3.amazonaws.com/clicked_images/' +result2[k].clicked_image_out_time;
                                        }
                                        
                                        final_arr.push({"user_name": result[j].user_name, "user_image": result[j].user_image,"pin":result[j].pin, "email_id": result[j].email_id, "phone": result[j].phone, "attendance_id": result2[k].attendence_id, "in_time": result2[k].in_time, "out_time": result2[k].out_time, "clicked_image_in_time": result2[k].clicked_image_in_time, "clicked_image_out_time": result2[k].clicked_image_out_time, "present_absent_flag": result2[k].present_absent_flag});
                                        break;
                                    }
                                }
//                                console.log("final_arr");
//                                console.log(final_arr);
                            }
//                            console.log("final_arr1");
//                            console.log(final_arr);
                            var response1 = {"data": final_arr};
                            res.send(JSON.parse(JSON.stringify(response1)));
                        }
                        else {

                        }
                    }
                    else {
                        console.log(err)
                        var response2 = {"error": 'Something went wrong'};
                        res.send(JSON.parse(JSON.stringify(response2)));
                    }
                });
            }
        }
        else {
            console.log(err)
            var response3 = {"error": 'Something went wrong'};
            res.send(JSON.parse(JSON.stringify(response3)));
        }
    });
};

exports.EditPresentAbsentFlagWebPanel = function(req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    var attendance_ids = req.body.attendance_ids;
    var present_absent_flag_ids = req.body.present_absent_flag_ids;
    var arr_attendance_ids = attendance_ids.split(',');
    var arr_present_absent_flag_ids = present_absent_flag_ids.split(',');
    var arr_attendance_ids_length = arr_attendance_ids.length;
    for (var i = 0; i < arr_attendance_ids_length; i++) {
        var sql = "UPDATE `attendence` SET `present_absent_flag`=? WHERE `attendence_id`=? LIMIT 1";
        connection.query(sql, [arr_present_absent_flag_ids[i], arr_attendance_ids[i]], function(err, result) {
            if (err) {
                console.log(err)
                var response = {"error": 'Something went wrong'};
                res.send(JSON.parse(JSON.stringify(response)));
            }
        });
    }
    var response2 = {"log": 'Update successful'};
    res.send(JSON.parse(JSON.stringify(response2)));
};

exports.UnapproveAttendanceEntryWebPanel = function(req, res) {
    res.header("Access-Control-Allow-Origin", "*");
    var attendance_ids = req.body.attendance_ids;
//    var email_ids=req.body.email_ids;
    var approval_flags = req.body.approval_flags;

    var arr_attendance_ids = attendance_ids.split(',');
    var arr_email_ids = [];
    var arr_approval_flags = approval_flags.split(',');

//    console.log("email_ids")
//    console.log(email_ids)
//    console.log("arr_email_ids")
//    console.log(arr_email_ids)



    var arr_attendance_ids_length = arr_attendance_ids.length;
    var unapproved_arr_email_ids = [];
    for (var i = 0; i < arr_attendance_ids_length; i++) {
        (function(i) {
            var sql = "UPDATE `attendence` SET `approval_flag`=? WHERE `attendence_id`=? LIMIT 1";
            connection.query(sql, [arr_approval_flags[i], arr_attendance_ids[i]], function(err, result) {
                if (!err) {
                    var sql2 = "SELECT `user_id` FROM `attendence` WHERE `attendence_id`=?";
                    connection.query(sql2, [arr_attendance_ids[i]], function(err, result2) {
                        if (!err) {
                            var sql2 = "SELECT `email_id` FROM `users` WHERE `user_id`=?";
                            connection.query(sql2, [result2[0].user_id], function(err, result3) {
                                if (!err) {
                                    arr_email_ids.push(result3[0].email_id);
                                    if (arr_approval_flags[i] == 0) {
                                        unapproved_arr_email_ids.push(arr_email_ids[i]);
                                        //                    console.log("unapproved_arr_email_ids")
                                        //                    console.log(unapproved_arr_email_ids)
                                    }

                                    if (i == arr_attendance_ids_length - 1) {
                                        var str_unapproved_arr_email_ids = unapproved_arr_email_ids.toString();
                                        console.log("unapproved_arr_email_ids")
                                        console.log(unapproved_arr_email_ids)
                                        console.log("str_unapproved_arr_email_ids")
                                        console.log(str_unapproved_arr_email_ids);
                                        var sub = "Regarding attendance unapproval";
                                        var email_body = "Your attendance has been unapproved. Please consult to HR";
                                        common_function.SendEmail(str_unapproved_arr_email_ids, email_body, sub, function(result2) {
                                        });
                                    }
                                }
                            });
                        }
                    });
                }
            });




        })(i);
    }

    var response2 = {"log": 'Update successful'};
    res.send(JSON.parse(JSON.stringify(response2)));
};