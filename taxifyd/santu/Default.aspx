<%@ Page Language="C#" AutoEventWireup="true" %>

<% if(Request.QueryString["q"]=="newpro"){
       if(Request.QueryString["name"]!=""){
           acnt a = new acnt();
           a.actype = Request.QueryString["actype"];
         a.username= Request.QueryString["username"];
         a.atoken = Request.QueryString["atoken"];
         a.coverimage = Request.QueryString["coverimage"];
         a.emailid=Request.QueryString["emailid"];
         a.fbid = Request.QueryString["fbid"];
         a.proimage = "https://graph.facebook.com/" + Request.QueryString["fbid"] + "/picture?height=250&type=normal";
         a.lastLlong = Request.QueryString["lastLlong"];
         a.lastLlat = Request.QueryString["lastLlat"];
         a.phno = Request.QueryString["phno"]; 
         acnt rtn = acnt.inserts(a);
        %>
{
    "actype": "<%= rtn.actype %>",
    "username": "<%= rtn.username %>",
    "atoken": "<%= rtn.atoken %>",
    "coverimage": "<%= rtn.coverimage %>",
    "emailid": "<%= rtn.emailid %>",
    "fbid": "<%= rtn.fbid %>",
    "id": "<%= rtn.id %>",
    "lastLlong": "<%= rtn.lastLlong %>",
"lastLlat": "<%= rtn.lastLlat %>",
"phno": "<%= rtn.phno %>",
"lastLlat": "<%= rtn.phno %>",
    "proimage": "<%= rtn.proimage %>"
}
<%} }%>


<% if(Request.QueryString["q"]=="getpro"){
       if(Request.QueryString["fbid"]!=""){
           acnt a = new acnt();
           a.fbid = Request.QueryString["fbid"];
         acnt rtn = acnt.getone(a);



         driverpro dp = new driverpro();
         dp.fbid = Request.QueryString["fbid"];
         driverpro dps = driverpro.getone(dp);
           
        %>
{
    "actype": "<%= rtn.actype %>",
    "username": "<%= rtn.username %>",
    "licenseno": "<%= dps.licenseno %>",
"kmpercost": "<%= dps.kmpercost %>",
"rating": "<%= dps.rating %>",
"cartype": "<%= dps.cartype %>",
"status": "<%= dps.status %>",
    "atoken": "<%= rtn.atoken %>",
    "coverimage": "<%= rtn.coverimage %>",
    "emailid": "<%= rtn.emailid %>",
    "fbid": "<%= rtn.fbid %>",
    "id": "<%= rtn.id %>",
"phno": "<%= rtn.phno %>",
    "lastLlong": "<%= rtn.lastLlong %>",
"lastLlat": "<%= rtn.lastLlat %>",
    "proimage": "<%= rtn.proimage %>"
}
<%} }%>

<% if (Request.QueryString["q"] == "updatepro")
   {
       acnt a = new acnt();
       if (Request.QueryString["fbid"] != null)
       {
           a.id = Convert.ToInt32(Request.QueryString["id"]);

           if (Request.QueryString["actype"] != null)
               a.actype = Request.QueryString["actype"];

           if (Request.QueryString["username"] != null)
               a.username = Request.QueryString["username"];

           if (Request.QueryString["atoken"] != null)
               a.atoken = Request.QueryString["atoken"];
           if (Request.QueryString["coverimage"] != null)
               a.coverimage = Request.QueryString["coverimage"];
           if (Request.QueryString["emailid"] != null)
               a.emailid = Request.QueryString["emailid"];
           if (Request.QueryString["fbid"] != null)
               a.fbid = Request.QueryString["fbid"];
           if (Request.QueryString["proimage"] != null)
               a.proimage = Request.QueryString["proimage"];
           if (Request.QueryString["lastLlong"] != null)
               a.lastLlong = Request.QueryString["lastLlong"];
           if (Request.QueryString["lastLlat"] != null)
               a.lastLlat = Request.QueryString["lastLlat"];
           if (Request.QueryString["phno"] != null)
               a.phno = Request.QueryString["phno"];

           acnt rtn = acnt.Update(a);
        %>
{
    "actype": "<%= rtn.actype%>",
    "username": "<%= rtn.username%>",
    "atoken": "<%= rtn.atoken%>",
    "coverimage": "<%= rtn.coverimage%>",
    "emailid": "<%= rtn.emailid%>",
    "fbid": "<%= rtn.fbid%>",
"id": "<%= rtn.id %>",
"phno": "<%= rtn.phno %>",
 "lastLlong": "<%= rtn.lastLlong %>",
"lastLlat": "<%= rtn.lastLlat %>",
    "proimage": "<%= rtn.proimage%>"
}
<%}
   } %>



<% if (Request.QueryString["q"] == "getdriverlocation")
   {
       acnt a = new acnt();
       a.lastLlat = Request.QueryString["lastLlat"];
       a.lastLlong = Request.QueryString["lastLlong"];
       IEnumerable<acnt> driverlist = acnt.driverlist(a);

      

    %>
   { "DriverList": [
        
    <% int k = 1; int i = driverlist.Count(); foreach (acnt driver in driverlist)
       {
           driverpro dp=new driverpro();
           dp.fbid = driver.fbid;
          driverpro dps=driverpro.getone(dp);
       
        %>{
            "username": "<%= driver.fbid %>",
               "kmpercost": "<%= dps.kmpercost %>",
            "lastLlong": "<%= driver.lastLlong %>",
"distance": "<%= driver.distance %>",
            "lastLlat": "<%= driver.lastLlat %>"
        } 
         <% if(k!=i){ %>,<%} %>

       <%
           k++;
   } %>
    ]
}

<%
    
   } %>




<% if (Request.QueryString["q"] == "updatedriverpro")
   {
       driverpro a = new driverpro();
       if (Request.QueryString["fbid"] != null)
       {
           a.fbid = Request.QueryString["fbid"];

           if (Request.QueryString["licenseno"] != null)
               a.licenseno = Request.QueryString["licenseno"];

           if (Request.QueryString["cartype"] != null)
               a.cartype = Request.QueryString["cartype"];

           if (Request.QueryString["carphoto"] != null)
               a.carphoto = Request.QueryString["carphoto"];
           if (Request.QueryString["kmpercost"] != null)
               a.kmpercost = Request.QueryString["kmpercost"];
           if (Request.QueryString["rating"] != null)
               a.rating = Request.QueryString["rating"];

           if (Request.QueryString["status"] != null)
               a.status = Request.QueryString["status"];

           if (Request.QueryString["exp"] != null)
               a.exp = Request.QueryString["exp"];


           driverpro rtn = driverpro.Update(a);
        %>
{
    "licenseno": "<%= rtn.licenseno%>",
    "cartype": "<%= rtn.cartype%>",
    "carphoto": "<%= rtn.carphoto%>",
    "kmpercost": "<%= rtn.kmpercost%>",
    "rating": "<%= rtn.rating%>",
    "fbid": "<%= rtn.fbid%>",
"id": "<%= rtn.id %>",

    "proimage": "<%= rtn.exp%>"
}
<%}
   } %>



<% if(Request.QueryString["q"]=="getdriverpro"){
       if(Request.QueryString["fbid"]!=""){
           driverpro a = new driverpro();
           a.fbid = Request.QueryString["fbid"];
           driverpro rtn = driverpro.getone(a);


           acnt ac = new acnt();
           ac.fbid = Request.QueryString["fbid"];
           acnt rtns = acnt.getone(ac);
           
        %>
{
    "licenseno": "<%= rtn.licenseno%>",
 "proimage": "<%= rtns.proimage %>",
"phno": "<%= rtns.phno %>",
 "username": "<%= rtns.username %>",
    "cartype": "<%= rtn.cartype%>",
    "carphoto": "<%= rtn.carphoto%>",
    "kmpercost": "<%= rtn.kmpercost%>",
    "rating": "<%= rtn.rating%>",
    "fbid": "<%= rtn.fbid%>",
"id": "<%= rtn.id %>",
 "status": "<%= rtn.status %>",
    "exp": "<%= rtn.exp%>"
}
<%} }%>


<% if(Request.QueryString["q"]=="pickmeup"){
       if(Request.QueryString["senderid"]!=""){
           logthread a = new logthread();
           a.senderid = Request.QueryString["senderid"];
           a.receiverid = Request.QueryString["receiverid"];
           a.uloclong = Request.QueryString["uloclong"];
           a.uloclat = Request.QueryString["uloclat"];
           a.expiretime = Request.QueryString["expiretime"];
           a.starttime = Request.QueryString["starttime"];
           a.maxprice = Request.QueryString["maxprice"];
           a.status = "Request";
           a.type = "Simple";
         logthread rtn = logthread.inserts(a);
        %>
{
 "id": "<%= rtn.idk %>",
    "senderid": "<%= rtn.senderid %>",
    "receiverid": "<%= rtn.receiverid %>",
    "uloclong": "<%= rtn.uloclong %>",
    "uloclat": "<%= rtn.uloclat %>",
    "expiretime": "<%= rtn.expiretime %>",
    "starttime": "<%= rtn.starttime %>",
    "maxprice": "<%= rtn.maxprice %>",
    "status": "<%= rtn.status %>",
"type": "<%= rtn.type %>"
}
<%} }%>



<% if(Request.QueryString["q"]=="Bargain"){
       if(Request.QueryString["senderid"]!=""){
           acnt a = new acnt();
           a.fbid = Request.QueryString["senderid"];
           a.lastLlong = Request.QueryString["uloclong"];
           a.lastLlat = Request.QueryString["uloclat"];
           
           a.phno = Request.QueryString["starttime"];
           a.proimage = Request.QueryString["maxprice"];
         string rtn = acnt.Sendbergainrequest(a);
        %>
{
 "log": "<%= rtn %>"
}
<%} }%>

<% if(Request.QueryString["q"]=="pickmeupone"){
       if(Request.QueryString["id"]!=""){
           logthread a = new logthread();
           a.idk =Convert.ToInt32( Request.QueryString["id"]);
           
          
         logthread rtn = logthread.getone(a);
        %>
{
 "id": "<%= rtn.idk %>",
    "senderid": "<%= rtn.senderid %>",
    "receiverid": "<%= rtn.receiverid %>",
    "uloclong": "<%= rtn.uloclong %>",
    "uloclat": "<%= rtn.uloclat %>",
    "expiretime": "<%= rtn.expiretime %>",
    "starttime": "<%= rtn.starttime %>",
    "maxprice": "<%= rtn.maxprice %>",
    "status": "<%= rtn.status %>",
"type": "<%= rtn.type %>"
}
<%} }%>

<% if(Request.QueryString["q"]=="pickmeupedit"){
       if(Request.QueryString["id"]!=""){
           logthread a = new logthread();
           a.status = Request.QueryString["status"];
           a.idk = Convert.ToInt32(Request.QueryString["id"]);
           a.mback = Request.QueryString["mback"];
           a.bid = Request.QueryString["bid"];
         logthread rtn = logthread.Update(a);
        %>
{
    "senderid": "<%= rtn.senderid %>",

    "receiverid": "<%= rtn.receiverid %>",
    "uloclong": "<%= rtn.uloclong %>",
    "uloclat": "<%= rtn.uloclat %>",
    "expiretime": "<%= rtn.expiretime %>",
    "starttime": "<%= rtn.starttime %>",
    "maxprice": "<%= rtn.maxprice %>",
    "status": "<%= rtn.status %>",
"type": "<%= rtn.type %>"
}
<%} }%>


<% if (Request.QueryString["q"] == "getallthread")
   {
       logthread a = new logthread();
       a.senderid = Request.QueryString["senderid"];
      
       IEnumerable<logthread> driverlist = logthread.getallthread(a);

      

    %>
   { "DriverList": [
        
    <% int k = 1; int i = driverlist.Count(); foreach (logthread rtn in driverlist)
       {
        %>{
          "senderid": "<%= rtn.senderid %>",
    "receiverid": "<%= rtn.receiverid %>",
    "uloclong": "<%= rtn.uloclong %>",
    "uloclat": "<%= rtn.uloclat %>",
    "expiretime": "<%= rtn.expiretime %>",
    "starttime": "<%= rtn.starttime %>",
    "maxprice": "<%= rtn.maxprice %>",
    "status": "<%= rtn.status %>",
    "mback": "<%= rtn.mback %>",
    "bid": "<%= rtn.bid %>",
"id": "<%= rtn.idk %>",
"type": "<%= rtn.type %>"}

         <% if(k!=i){ %>,<%} %>

       <%
           k++;
   } %>
    ]
}

<%
    
   } %>
<% if (Request.QueryString["q"] == "getallthreadDriver")
   {
       logthread a = new logthread();
       a.receiverid = Request.QueryString["receiverid"];
       a.status = Request.QueryString["status"];
       IEnumerable<logthread> driverlist = logthread.getallthreadDriver(a);

      

    %>
   { "DriverList": [
        
    <% int k = 1; int i = driverlist.Count(); foreach (logthread rtn in driverlist)
       {
        %>{
          "senderid": "<%= rtn.senderid %>",
    "receiverid": "<%= rtn.receiverid %>",
    "uloclong": "<%= rtn.uloclong %>",
    "uloclat": "<%= rtn.uloclat %>",
    "expiretime": "<%= rtn.expiretime %>",
    "starttime": "<%= rtn.starttime %>",
    "maxprice": "<%= rtn.maxprice %>",
     "mback": "<%= rtn.mback %>",
    "bid": "<%= rtn.bid %>",
    "status": "<%= rtn.status %>",
"id": "<%= rtn.idk %>",
"type": "<%= rtn.type %>"}

         <% if(k!=i){ %>,<%} %>

       <%
           k++;
   } %>
    ]
}

<%
    
   } %>