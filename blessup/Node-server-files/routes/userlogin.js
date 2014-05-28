var func = require('./commonfunction');
var mysql = require('mysql');
/* .............................................................................................................................................................................................
 * ------------------------------------------------------
 *  Register Or login  fb user
 *  Input:fbid,fbname,fbacesstoken,devicetoken
 *  Output:User information
 * ------------------------------------------------------
 */
exports.registerOrLoginUserByFacebook = function (req, res) {
    var userFbId = req.body.fbid;
    var userFbName = req.body.fbname;
    var fbAccessToken = req.body.fbaccesstoken;
    var fbEmail = req.body.email;
    var devicetoken = req.body.devicetoken;

    var manValues = [userFbId, userFbName, fbAccessToken, fbEmail, devicetoken];

    var checkData = func.checkBlank(manValues);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
        func.authenticateFbuserThroughFbAcessToken(userFbId, fbAccessToken, function (results) {
            if (results == 0) {
                var response = {"error": 'Not An Authenticated User!'};
                res.jsonp(response);
            }
            else {
                var datetime = new Date();
                checkUserExistThroughFbId(userFbId, function (results) {
                    if (results == 0) {
                        var d = new Date(),
                            s = "06.00 PM",
                            parts = s.match(/(\d+)\.(\d+) (\w+)/),
                            hours = /am/i.test(parts[3]) ? parseInt(parts[1], 10) : parseInt(parts[1], 10) + 12,
                            minutes = parseInt(parts[2], 10);
                        d.setHours(hours);
                        d.setMinutes(minutes);

                        var accessToken = new Buffer((Math.random() + userFbId)).toString('base64');
                        var userPicture = "http://graph.facebook.com/" + userFbId + "/picture?width=160&height=160";
                        var sql = "INSERT INTO `users`(fb_id,user_name,email,access_token,user_image,user_type,device_token,last_login_timestamp,bless_timestamp) VALUES (?,?,?,?,?,?,?,?,?)";
                        connection.query(sql, [userFbId, userFbName, fbEmail, accessToken, userPicture, 2, devicetoken, datetime, d ], function (err, result) {
                            var userId = result.insertId;
                            var response = {"data": [
                                {"user_id": userId, "fb_id": userFbId, "user_name": userFbName, "email": fbEmail, "user_image": userPicture, "access_token": accessToken}
                            ]};
                            res.jsonp(response);
                        });

                    }
                    else {
                        var sql = "UPDATE `users` SET `device_token`=?, `last_login_timestamp`=? WHERE `user_id`=?";
                        connection.query(sql, [devicetoken, datetime, results[0].user_id], function (err, responseUpdate) {
                        });
                        var sql = "SELECT `user_id`,`fb_id`,`user_name`,`email`,`access_token`,  `user_image` FROM `users` WHERE fb_id=? LIMIT 1";
                        connection.query(sql, [userFbId], function (err, results) {
                            var response = {"data": results};
                            res.jsonp(response);
                        });
                    }

                });


            }
        });

    }

};

/* ............................................................................................................................................................................................       * ------------------------------------------------------
 *  Authenticate a Fbuser
 *  Input:Fbid
 *  Output: User_id Or 0 if not Authenticate{check in database for Unique Fbid if the value is present return corrosponding userid else 0}
 * ------------------------------------------------------
 */
function checkUserExistThroughFbId(userFbId, callback) {
    var sql = "SELECT `user_id` FROM `users` WHERE `fb_id`=? LIMIT 1";
    connection.query(sql, [userFbId], function (err, results) {
        if (results.length > 0) {
            return callback(results);
        }
        else {

            return callback(0);
        }
    });
}
exports.updateDeviceToken = function (req, res) {
    var accesstoken = req.body.accesstoken;
    var devicetoken = req.body.devicetoken;
    var manValues = [accesstoken, devicetoken];
    var checkData = func.checkBlank(manValues);
    if (checkData == 1) {
        res.type('json');
        var response = {"error": 'Mandatory fields are not filled!'};
        res.jsonp(response);
    }
    else {
        var extradata = [];
        func.authenticateAccessTokenAndReturnExtraData(accesstoken, extradata, function (results) {
            if (results == 0) {
                var response = {"error": 'Invalid access token.'};
                res.jsonp(response);
            }
            else {
                var sql = "UPDATE `users` SET `device_token`=? WHERE user_id=? LIMIT 1";
                connection.query(sql, [devicetoken, results[0].user_id], function (err, responseUpdate) {
                });
                var response = {"log": ' Token changed.'};
                res.jsonp(response);
            }
        });
    }
}







