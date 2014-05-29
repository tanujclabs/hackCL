
/**
 * Module dependencies.
 */
 
var express = require('express'),
  request = require('request'),
  jsdom = require('jsdom'),
  http = require('http'),
  path = require('path');
  
  var multiparty = require('multiparty');
  
conn = require('./routes/conn');
var users =require('./routes/users');
var chrone=require('./routes/chrone');
var attendance=require('./routes/attendance');
var admin=require('./routes/admin');

var app = express();
app.configure(function(){
  app.set('port', process.env.PORT || 2000);
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

app.get('/automatic_entry', chrone.AutomaticAbsentEntriesInMorning);

// example of multiparty parsing
//app.post('/attendance_entry', function(req, res) {
//    
//    console.log(req.files);
//    
//    var form = new multiparty.Form();
//    form.parse(req);
//});



app.post('/list_users', users.ListUsersToIOS);
app.post('/add_new_user', users.AddNewUserFromWebPanel);
app.post('/attendance_entry', attendance.AttendanceEntryFromIOS);
app.post('/view_today_attendance', admin.ViewTodayAttendanceWebPanel);
app.post('/edit_present_absent_flag_web_panel', admin.EditPresentAbsentFlagWebPanel);
app.post('/unapprove_attendance_entry_web_panel', admin.UnapproveAttendanceEntryWebPanel);



http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});

