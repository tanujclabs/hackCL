
/**
 * Module dependencies.
 */
 
var express = require('express'),
  request = require('request'),
  jsdom = require('jsdom'),
  http = require('http'),
  path = require('path');


  
conn = require('./routes/sqlConnection');
var userlogin =require('./routes/userlogin');
var friends =require('./routes/friends');
var bless =require('./routes/bless');




var app = express();
userBaseImage='http://chooser-game.s3.amazonaws.com/userImages/';
app.configure(function(){
  app.set('port', process.env.PORT || 1339);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});



app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/test', function(req, res){
  res.render('test');
});

app.post('/registration_or_login_through_facebook', userlogin.registerOrLoginUserByFacebook);
app.post('/get_fb_friends', friends.getFbFriendsFromFbIdAndFbAccessToken);
app.post('/get_fb_friends_of_friend', friends.getFbFriendsFromUserIdAndAccessToken);
app.post('/bless_user', bless.blessUserFromAccessToken);
app.post('/view_user_blessing_profile', bless.viewUserBlessingProfileFromAccessToken);
app.post('/view_feed', bless.viewFeedFromAccessToken);
app.post('/update_bless_view_status', bless.updateBlessViewStatusFromAcessToken);
app.post('/update_bless_view_time', bless.updateBlessViewTimeFromAcessToken);
app.post('/update_push_status', bless.updatePushStatusFromAcessToken);
app.get('/cron', bless.cronForPush);
app.post('/update_devicetoken', userlogin.updateDeviceToken);





http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

