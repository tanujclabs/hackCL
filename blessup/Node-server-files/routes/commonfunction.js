var gcm = require('node-gcm');
/**
 * @ Description : Functions.class.php contains class Functions.
 * It include all the functions.
 * @ Developed by : Click Labs Pvt. Ltd.
 */
/*
 * ------------------------------------------------------
 * Check if manadatory fields are not filled
 * INPUT : array of field names which need to be mandatory
 * OUTPUT : Error if mandatory fields not filled
 * ------------------------------------------------------
 */

exports.checkBlank = function (arr) {
    var arrlength = arr.length;
    for (var i = 0; i < arrlength; i++) {
        if (arr[i] == '') {
            return 1;
            break;
        }

    }
    return 0;
};

/*
 * ------------------------------------------------------
 * Authenticate a user through Access token and return extra data
 * Input:Access token{Optional Extra data}
 * Output: User_id Or Json error{Optional Extra data}
 * ------------------------------------------------------
 */
exports.authenticateAccessTokenAndReturnExtraData = function (accesstoken, arr, callback) {
    var sql = "SELECT `user_id`";
    arr.forEach(function (entry) {
        sql += "," + entry;
    });
    sql += " FROM `users`";
    sql += " WHERE `access_token`=? LIMIT 1";
    connection.query(sql, [accesstoken], function (err, result) {
        if (result.length > 0) {
            return callback(result);
        } else {
            return callback(0);
        }
    });

}
/*
 * ------------------------------------------------------
 * Get user data Through user id
 * Input:User id{Optional Extra data}
 * Output: User_id Or Json error{Optional Extra data}
 * ------------------------------------------------------
 */
exports.getUserDataFromUserId = function (userIdArray, arr, callback) {
    var i = 0;
    var checkLength = 0;
    var response = new Array();
    userIdArray.forEach(function (value) {
        var sql = "SELECT `user_id`";
        for (var k in arr) {
            sql += "," + arr[k] + " AS " + k;
        }
        sql += " FROM `users`";
        sql += " WHERE `user_id`=? LIMIT 1";

        connection.query(sql, [value], function (err, result) {
            response[i] = result;
            ++checkLength;
            if (checkLength == userIdArray.length) {
                return(callback(response));
            }
            i++;
        });
    });


}
/*
 * ------------------------------------------------------
 * Check an element exist in array or not
 * Input:array and element to search
 * Output: True or false
 * ------------------------------------------------------
 */
exports.in_array = function (array, id) {
    for (var i = 0; i < array.length; i++) {
        if (array[i][0] === id) {
            return true;
        }
    }
    return false;
}

/*
 * ------------------------------------------------------
 * Authenticate fb user
 * ------------------------------------------------------
 */

exports.authenticateFbuserThroughFbAcessToken = function (userFbId, fbAccessToken, callback) {
    var request = require('request');
    var urls = "https://graph.facebook.com/" + userFbId + "?fields=updated_time&access_token=" + fbAccessToken;
    request(urls, function (error, response, body) {
        if (!error && response.statusCode == 200) {
            var output = JSON.parse(body);
            if (output['error']) {
                return callback(0);
            }
            else {
                return callback(1);
            }
        }
        else {
            return callback(0);

        }
    });
};

/*
 * ------------------------------------------------------
 *  Authenticate a user
 *  INPUT : user_access_token
 *  OUTPUT : user_id
 * ------------------------------------------------------
 */

exports.authenticateUser = function (userAccessToken, callback) {
    var sql = "SELECT `user_id` FROM `tb_users` WHERE `user_access_token`=? LIMIT 1";
    connection.query(sql, [userAccessToken], function (err, result) {

        if (result.length > 0) {
            return callback(result);
        } else {
            return callback(0);
        }
    });
};

/*
 * -----------------------------------------------------------------------------
 * Uploading image to s3 bucket
 * INPUT : file parameter
 * OUTPUT : image path
 * -----------------------------------------------------------------------------
 */
exports.uploadImageToS3Bucket = function (file, folder, callback) {
    var fs = require('fs');
    var math = require('mathjs');
    var AWS = require('aws-sdk');


    var filename = file.name; // actual filename of file
    var path = file.path; //will be put into a temp directory
    var mimeType = file.type;

    fs.readFile(path, function (error, file_buffer) {
        if (error) {
            return callback(0);
        }

        filename = file.name;

        AWS.config.update({accessKeyId: 'AKIAJTIGKXNQVTRBU45A', secretAccessKey: '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'});
        var s3bucket = new AWS.S3();
        var params = {Bucket: 'votechat', Key: folder + '/' + filename, Body: file_buffer, ACL: 'public-read', ContentType: mimeType};

        s3bucket.putObject(params, function (err, data) {
            if (err) {
                return callback(0);
            }
            return callback(filename);
        });
    });

};

/*
 * -----------------------------------------------------------------------------
 * Uploading image to s3 bucket
 * INPUT : file parameter
 * OUTPUT : image path
 * -----------------------------------------------------------------------------
 */
exports.uploadOriginalSizeImageToS3Bucket = function (file, text, folder, callback) {
    var fs = require('fs');
    var AWS = require('aws-sdk');
    var filename = file.file1.name; // actual filename of file
    var path = file.file1.path; //will be put into a temp directory
    var mimeType = file.file1.type;
    fs.readFile(path, function (error, file_buffer) {
        if (error) {
            return callback(0);
        }
        filename = text + "-" + file.file1.name;
        AWS.config.update({accessKeyId: 'AKIAICBNMK4N2BGIIXKA', secretAccessKey: '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'});
        var s3bucket = new AWS.S3();
        var params = {Bucket: 'chooser-game', Key: folder + '/' + filename, Body: file_buffer, ACL: 'public-read', ContentType: mimeType};
        s3bucket.putObject(params, function (err, data) {
            if (err) {
                return callback(0);
            }
            return callback(filename);
        });
    });

};
/*
 * -----------------------------------------------------------------------------
 * sorting an array in ascending order
 * INPUT : array and key according to which sorting is to be done
 * OUTPUT : sorted array
 * -----------------------------------------------------------------------------
 */
exports.sortByKeyAsc = function (array, key) {
    return array.sort(function (a, b) {
        var x = a[key];
        var y = b[key];
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    });
};
/*
 * -----------------------------------------------------------------------------
 * sorting an array in descending order
 * INPUT : array and key according to which sorting is to be done
 * OUTPUT : sorted array
 * -----------------------------------------------------------------------------
 */
exports.sortByKeyDesc = function (array, key) {
    return array.sort(function (a, b) {
        var x = a[key];
        var y = b[key];
        return ((x > y) ? -1 : ((x < y) ? 1 : 0));
    });
};
/*
 * -----------------------------------------------------------------------------
 * Getting name and image of user from user id
 * INPUT : user id
 * OUTPUT : name and image of user
 * -----------------------------------------------------------------------------
 */
exports.getNameImageFromUserId = function (userId, callback) {
    var sql1 = "SELECT `user_name`,`user_image`,`user_fb_id` FROM `tb_users` WHERE `user_id`=? LIMIT 1";
    connection.query(sql1, [userId], function (err, results) {
        if (results[0].user_fb_id == 0) {
            results[0].user_image = userPicBaseUrl + results[0].user_image;
        }
        delete results[0].user_fb_id;
        var nameImage = {"user_name": results[0].user_name, "user_image": results[0].user_image};
        return callback(nameImage);

    });

};

exports.getNameFromUserId = function (userId, callback) {
    var sql11 = "SELECT `user_id`,`user_name` FROM `tb_users` WHERE `user_id`=? LIMIT 1";
    connection.query(sql11, [userId], function (err, results) {

        var name = {"user_name": results[0].user_name};
        return callback(name);

    });

};
/*
 * -----------------------------------------------------------------------------
 * return time difference of cur date and another time
 * INPUT : time
 * OUTPUT : diff of 2 times
 * -----------------------------------------------------------------------------
 */
exports.getTimeDifference = function (time) {
    var Math = require('mathjs');
    var today = new Date();
    var diffMs = (today - time); // milliseconds between now & post date

    var diffDays = Math.floor(diffMs / 86400000); // days
    var diffHrs = Math.floor((diffMs % 86400000) / 3600000); // hours
    var diffMins = Math.round(((diffMs % 86400000) % 3600000) / 60000); // minutes
    var postTime = {"days": diffDays, "hours": diffHrs, "minutes": diffMins};

    return postTime;

};

/*
 * -----------------------------------------------------------------------------
 * Encryption code
 * INPUT : string
 * OUTPUT : crypted string
 * -----------------------------------------------------------------------------
 */
exports.encrypt = function (text) {
    var crypto = require('crypto');
    var cipher = crypto.createCipher('aes-256-cbc', 'd6F3Efeq');
    var crypted = cipher.update(text, 'utf8', 'hex');
    crypted += cipher.final('hex');
    return crypted;
}
/*
 * -----------------------------------------------------------------------------
 * Sending push notification to devices
 * INPUT : iosDeviceToken,message
 * OUTPUT : Notification send
 * -----------------------------------------------------------------------------
 */
exports.sendPushNotification = function (iosDeviceToken, message, flag, groupId, groupName) {

    var apns = require('apn');

    var options = {
        cert: 'VotePushNew.pem',
        certData: null,
        key: 'VotePushNew.pem',
        keyData: null,
        passphrase: 'click',
        ca: null,
        pfx: null,
        pfxData: null,
        gateway: 'gateway.push.apple.com',
        port: 2195,
        rejectUnauthorized: true,
        enhanced: true,
        cacheLength: 100,
        autoAdjustCache: true,
        connectionTimeout: 0,
        ssl: true
    }

    var sql = "SELECT badge_no FROM tb_users WHERE user_ios_device_token=? LIMIT 1";
    connection.query(sql, [iosDeviceToken], function (err, resultBadge) {


        var deviceToken = new apns.Device(iosDeviceToken);
        var apnsConnection = new apns.Connection(options);
        var note = new apns.Notification();

        note.expiry = Math.floor(Date.now() / 1000) + 3600;
        note.badge = (resultBadge[0].badge_no + 1);
        note.sound = 'ping.aiff';
        note.alert = message;
        if (flag == 1) {
            note.payload = {'flag': 1};

        }
        else {
            note.payload = {'flag': 2, 'group_id': groupId, 'group_name': groupName};
        }

        apnsConnection.pushNotification(note, deviceToken);

        // i handle these events to confirm the notification gets
        // transmitted to the APN server or find error if any

        //        function log(type) {
        //            return function() {
        //                console.log(type, arguments);
        //            }
        //        }

        apnsConnection.on('transmitted', function () {

            var sql = "UPDATE tb_users SET badge_no=badge_no+1 WHERE user_ios_device_token=? LIMIT 1";
            connection.query(sql, [iosDeviceToken], function (err, resultBadgeUpdate) {
            });
        });

        //        apnsConnection.on('error', log('error'));
        //        apnsConnection.on('transmitted', log('transmitted'));
        //        apnsConnection.on('timeout', log('timeout'));
        //        apnsConnection.on('connected', log('connected'));
        //        apnsConnection.on('disconnected', log('disconnected'));
        //        apnsConnection.on('socketError', log('socketError'));
        //        apnsConnection.on('transmissionError', log('transmissionError'));
        //        apnsConnection.on('cacheTooSmall', log('cacheTooSmall'));
    });
};

exports.sendEmail = function (receiverMailId, message, subject, callback) {
    var nodemailer = require("nodemailer");
    var smtpTransport = nodemailer.createTransport("SMTP", {
        service: "Gmail",
        auth: {
            user: "contact@votechat.me",
            pass: "click#chat"
        }
    });

    // setup e-mail data with unicode symbols
    var mailOptions = {
        from: "Votechat Admin", // sender address
        to: receiverMailId, // list of receivers
        subject: subject, // Subject line
        text: message // plaintext body
        //html: "<b>Hello world ?</b>" // html body
    }

    // send mail with defined transport object
    smtpTransport.sendMail(mailOptions, function (error, response) {
        if (error) {

            return callback(0);
        } else {

            return callback(1);
        }

        // if you don't want to use this transport object anymore, uncomment following line
        //smtpTransport.close(); // shut down the connection pool, no more messages
    });
};

exports.generateRandomString = function () {
    var math = require('mathjs');

    var text = "";
    var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

    for (var i = 0; i < 6; i++)
        text += possible.charAt(math.floor(math.random() * possible.length));

    return text;
};
/*
 * -----------------------------------------------------------------------------
 * Inserting In-App notifications into DB
 * INPUT : userId, senderId, groupId,groupName,postId,notId,read
 * OUTPUT : Notification Inserted
 * -----------------------------------------------------------------------------
 */
exports.insertNotification = function (userId, senderId, groupId, groupName, postId, notId, read, cycleId) {


    var sql = "INSERT INTO `tb_notifications`( `user_id`, `sender_id`, `group_id`,`group_name`,`post_id`, `not_id`, `read`,`cycle_id`) VALUES(?,?,?,?,?,?,?,?)";
    connection.query(sql, [userId, senderId, groupId, groupName, postId, notId, read, cycleId], function (err, result) {

    });

    var sql4 = "UPDATE `tb_users` SET `user_notification_count`=`user_notification_count`+1 WHERE `user_id`=? LIMIT 1";
    connection.query(sql4, [userId], function (err, update) {

    });

};
exports.sendAndroidPushNotifications = function(deviceToken, message, username, userimage ,blessedid, type,callback)
{
    console.log(blessedid);
    var message = new gcm.Message({
        collapseKey: 'demo',
        delayWhileIdle: true,
        timeToLive: 3,
        data: {
            message: message,
            name: username,
            image: userimage,
            bless: blessedid,
            type: type
        }
    });
    var sender = new gcm.Sender('AIzaSyCogRSgEQC99_U0OicaY7W8CIszzgsOxHs');
    var registrationIds = [];
    registrationIds.push(deviceToken);
    sender.sendNoRetry(message, registrationIds, function(err, result) {
        //console.log(result);
        if (err) {
            return callback(0);
        } else {
            return callback(1);
        }
    });
}