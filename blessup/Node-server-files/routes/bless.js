/**
 * Created by clicklabs on 5/3/14.
 */
var func = require('./commonfunction');
var mysql = require('mysql');
var fs = require('fs');
/*
 * -----------------------------------------------------------------------------
 * Bless user from access token
 * Input : accessToken, user id
 * Output : log message
 * -----------------------------------------------------------------------------
 */
exports.blessUserFromAccessToken = function (req, res) {
    var accessToken = req.body.accesstoken;
    var blessedId = req.body.userid;
    var manValues = [accessToken, blessedId];
    var checkData = func.checkBlank(manValues);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
    var extradata = ["user_name","fb_id"];
    func.authenticateAccessTokenAndReturnExtraData(accessToken, extradata, function (results) {
        if (results == 0) {
            var response = {"error": 'Invalid access token.'};
            res.jsonp(response);
        }
        else {
            var sql = "SELECT id from `bless` where `from` =?  AND `to` =? AND timestamp > CURDATE() LIMIT 1";
            connection.query(sql, [results[0].user_id, blessedId], function (err, resultToday) {
                if(resultToday.length == 0){
            var userId = results[0].user_id;
            var userName = results[0].user_name;
            var fbId = results[0].fb_id;
            var sql = "INSERT INTO `bless`(`from`,`fb_id`,`name`,`to`) VALUES (?,?,?,?)";
            connection.query(sql, [userId, fbId, userName, blessedId ], function (err, result) {
                var extradata = ["device_token","push_status"];
                var sql = "SELECT `device_token`,`push_status` from `users` where `user_id` =?";
                connection.query(sql, [blessedId], function (err, resultReg) {
                    var message = "Someone has blessed you !";
                  var blessId = result.insertId;
                    if(resultReg[0].push_status == 1){
                    func.sendAndroidPushNotifications(resultReg[0].device_token, message, '','','', 1, function (result) {
                    });
                    }
                    var response = {"log": 'User blessed successfully.'};
                    res.jsonp(response);
                });
            });
            }
                else{
                    var response = {"error": 'User already blessed.'};
                    res.jsonp(response);
                }
        });
        }
    });
    }
}
/*
 * -----------------------------------------------------------------------------
 * View my profile from access token
 * Input : accessToken
 * Output :
 * -----------------------------------------------------------------------------
 */
exports.viewUserBlessingProfileFromAccessToken = function (req, res) {
    var accessToken = req.body.accesstoken;
    var manValues = [accessToken];
    var checkData = func.checkBlank(manValues);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
    var extradata = ["user_name", "user_image"];
    func.authenticateAccessTokenAndReturnExtraData(accessToken, extradata, function (results) {
        if (results == 0) {
            var response = {"error": 'Invalid access token.'};
            res.jsonp(response);
        }
        else {
            var sql = "SELECT id from `bless` where `to` =? AND timestamp > CURDATE()";
            connection.query(sql, [results[0].user_id], function (err, resultToday) {
                var sqlweek = "SELECT id from `bless` where `to` =? AND `timestamp` >NOW() - INTERVAL 1 WEEK";
                connection.query(sqlweek, [results[0].user_id], function (err, resultWeek) {
                    var sqlmonth = "SELECT id from `bless` where `to` =? AND `timestamp` >NOW() - INTERVAL 1 MONTH";
                    connection.query(sqlmonth, [results[0].user_id], function (err, resultMonth) {
                        var sqlyear = "SELECT id  from `bless` where `to` =? AND `timestamp` >NOW() - INTERVAL 1 YEAR";
                        connection.query(sqlyear, [results[0].user_id], function (err, resultYear) {
                            if (resultToday.length > 0 || resultWeek.length || resultMonth.length || resultYear.length) {
                                var test = [];
                                var total = resultToday.length +  resultWeek.length + resultMonth.length + resultYear.length;
                                test.push({
                                    today: resultToday.length, week: resultWeek.length, month: resultMonth.length,year: resultYear.length,"total":total
                                });
                                var response = {"data":[{"user_name":results[0].user_name,"user_image":results[0].user_image,"bless":test}]};
                                res.jsonp(response);
                            }
                            else{
                                var test = [];  // new array
                                test.push({
                                    today: "0", week: "0", month: "0",year:"0","total" : "0"
                                });
                                var response = {"data":[{"user_name":results[0].user_name,"user_image":results[0].user_image,"bless":test}]};
                                res.jsonp(response);
                            }
                        });
                    });
                });
            });
        }

    });
    }
}
/*
 * -----------------------------------------------------------------------------
 * View feed from access token
 * Input : accessToken
 * Output :
 * -----------------------------------------------------------------------------
 */
exports.viewFeedFromAccessToken = function (req, res) {
    var accessToken = req.body.accesstoken;
    var manValues = [accessToken];
    var checkData = func.checkBlank(manValues);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
        var extradata = ["user_name", "user_image"];
        func.authenticateAccessTokenAndReturnExtraData(accessToken, extradata, function (results) {
            if (results == 0) {
                var response = {"error": 'Invalid access token.'};
                res.jsonp(response);
            }
            else {
                var sql = "SELECT `from`,`fb_id`,`name`,`is_view`,`timestamp` from `bless` where `to` =? ";
                connection.query(sql, [results[0].user_id], function (err, resultQuery) {
                    if(resultQuery.length > 0){
                    resultQuery = func.sortByKeyDesc(resultQuery, 'timestamp');
                    var test = [];
                    resultQuery.forEach(function(val){
                    if(val.is_view == 0){
                        var times = val.timestamp.toString().split(" ");
                        test.push({
                           "text":"You have been blessed",
                            "user_name":"",
                            "user_image":"",
                            "timestamp": "at " + times[1] +" " + times[2]
                        });
                    }
                        else{
                        var times = val.timestamp.toString().split(" ");
                        test.push({
                            "text":"blessed you",
                            "user_name": val.name,
                            "user_image": "http://graph.facebook.com/" + val.fb_id + "/picture?width=160&height=160 ",
                            "timestamp": "on " + times[1] +" " + times[2]
                        });
                    }
                });
                        var response = {"data":test};
                        res.jsonp(response);
                }
                    else{
                        var response = {"data":[]};
                        res.jsonp(response);
                }
                });
            }
        });
    }
}
/*
 * -----------------------------------------------------------------------------
 * Update bless view status
 * Input : accessToken
 * Output :
 * -----------------------------------------------------------------------------
 */
exports.updateBlessViewStatusFromAcessToken = function (req, res) {
    var accessToken = req.body.accesstoken;
    var blessId = req.body.blessid;
    var manValues = [accessToken, blessId];
    var manValues = [accessToken, blessId];
    var checkData = func.checkBlank(manValues);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
        var extradata = ["bless_timestamp"];
        func.authenticateAccessTokenAndReturnExtraData(accessToken, extradata, function (results) {
            if (results == 0) {
                var response = {"error": 'Invalid access token.'};
                res.jsonp(response);
            }
            else {
                var datetime = new Date();
                blessTimeStamp = results[0].bless_timestamp;
                if(blessTimeStamp == '0000-00-00 00:00:00'){
                    var response = {"error": 'Time out.'};
                    res.jsonp(response);
                }
                else{
                blessTimeStamp.setMinutes(blessTimeStamp.getMinutes() + 5).toString();
                var datetime = new Date();
                console.log(datetime);
                console.log(blessTimeStamp);
                if(datetime < blessTimeStamp ){
                var sql = "UPDATE `bless` SET `is_view`=? WHERE id=? LIMIT 1";
                connection.query(sql, [1, blessId], function (err, responseUpdate) {
                });
                var response = {"log": 'Bless viewed.'};
                res.jsonp(response);
            }
            else{
                var response = {"error": 'Time out.'};
                res.jsonp(response);
            }
            }
            }


        });
    }
}

/*
 * -----------------------------------------------------------------------------
 * Update bless view time
 * Input : accessToken
 * Output :
 * -----------------------------------------------------------------------------
 */
exports.updateBlessViewTimeFromAcessToken = function (req, res) {
    var accessToken = req.body.accesstoken;
    var timestamp = req.body.timestamp;
    var manValues = [accessToken];
    var checkData = func.checkBlank(manValues, timestamp);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
        var extradata = [];
        func.authenticateAccessTokenAndReturnExtraData(accessToken, extradata, function (results) {
            if (results == 0) {
                var response = {"error": 'Invalid access token.'};
                res.jsonp(response);
            }
            else {
                var sql = "UPDATE `users` SET `bless_timestamp`=? WHERE user_id=? LIMIT 1";
                connection.query(sql, [timestamp, results[0].user_id], function (err, responseUpdate) {
                });
                var response = {"log": 'Settings changed.'};
                res.jsonp(response);
            }
        });
    }
}
/*
 * -----------------------------------------------------------------------------
 * Update push status
 * Input : accessToken
 * Output :
 * -----------------------------------------------------------------------------
 */
exports.updatePushStatusFromAcessToken = function (req, res) {
    var accessToken = req.body.accesstoken;
    var flag = req.body.flag;
    var manValues = [accessToken, flag];
    var checkData = func.checkBlank(manValues);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
        var extradata = [];
        func.authenticateAccessTokenAndReturnExtraData(accessToken, extradata, function (results) {
            if (results == 0) {
                var response = {"error": 'Invalid access token.'};
                res.jsonp(response);
            }
            else {
                var sql = "UPDATE `users` SET `push_status`=? WHERE user_id=? LIMIT 1";
                connection.query(sql, [flag, results[0].user_id], function (err, responseUpdate) {
                });
                var response = {"log": ' Push settings changed.'};
                res.jsonp(response);
            }
        });
    }
}
/*
 * -----------------------------------------------------------------------------
 * Cron for push
 * Input : accessToken
 * Output :
 * -----------------------------------------------------------------------------
 */
exports.cronForPush = function (req, res) {
    var datetime = new Date();
    var sql = "SELECT `user_id`,`bless_timestamp`,`device_token` from `users` ";
    connection.query(sql, function (err, resultQuery) {
        if(resultQuery.length > 0){
            var message = "It is time to see who blessed you today!!";
            resultQuery.forEach(function(val){
                var Dbhours = val.bless_timestamp.getHours();
                var dbmin = val.bless_timestamp.getMinutes();
                var currhours = datetime.getHours();
                var currmin = datetime.getMinutes();
                if(Dbhours == currhours && dbmin == currmin){
                    getRandomBlessingUser(val.user_id, function (results) {
                    if(results){
                        var myDate = new Date();
                        myDate.setDate(myDate.getDate() + 1);
                        console.log(myDate);
                        var sql = "UPDATE `users` SET `bless_timestamp`=? WHERE user_id=? LIMIT 1";
                        connection.query(sql, [myDate, val.user_id], function (err, responseUpdate) {
                        });
                    func.sendAndroidPushNotifications(val.device_token, message, results[0].user_name,results[0].user_image,results[0].blessedid,2,function (result) {
                    });
                    }
                    });
                }
            });
            var response = {"log": ' success.'};
            res.jsonp(response);
        }
    });
}
/* ............................................................................................................................................................................................       * ------------------------------------------------------
 *  Authenticate a Fbuser
 *  Input:Fbid
 *  Output: User_id Or 0 if not Authenticate{check in database for Unique Fbid if the value is present return corrosponding userid else 0}
 * ------------------------------------------------------
 */
function getRandomBlessingUser(userId, callback) {
    var sql = "SELECT `id`,`from` from `bless` where `to` =? AND timestamp > CURDATE() ";
    connection.query(sql, [userId], function (err, resultToday) {
        if(resultToday.length > 0){
            var items = [];
            resultToday.forEach(function(val){
                items.push(val.id);
            });
            var item = items[Math.floor(Math.random()*items.length)];
            var sql = "SELECT `from` from `bless` where `id` =?  LIMIT 1";
            connection.query(sql, [item], function (err, resultFromId) {
    var sql = "SELECT `user_name`,`user_image` FROM `users` WHERE `user_id`=? LIMIT 1";
    connection.query(sql, [resultFromId[0].from], function (err, results) {
        if(results.length > 0){
            results[0]['blessedid'] = item;
            return callback(results);
        }
    });
            });
     }
        else{
            return callback(0);
        }
});
}