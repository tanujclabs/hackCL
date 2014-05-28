<%@ Page Language="C#" AutoEventWireup="true" %>

<% if(Request.QueryString["q"]=="newpro"){
       if(Request.QueryString["name"]!=""){
           acnt a = new acnt();
         a.username= Request.QueryString["name"];
         acnt rtn = acnt.inserts(a);
        %>
<%= rtn.username %>
<%} }%>