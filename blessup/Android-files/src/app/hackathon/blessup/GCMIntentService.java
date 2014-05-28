package app.hackathon.blessup;

import java.util.List;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

import com.google.android.gcm.GCMBaseIntentService;

public class GCMIntentService extends GCMBaseIntentService {
    
    static Intent notificationIntent;  
    static String notification_message;
    
    static Context cont;
    
    
        protected void onError(Context arg0, String arg1) {
             Log.e("Registration", "Got an error1!");
             Log.e("Registration",arg1.toString());
        }

        protected boolean onRecoverableError(Context context, String errorId){
            Log.d("onRecoverableError", errorId);
            return false;       
        }

        
        protected void onMessage(Context context, Intent arg1) {
            try{
             Log.e("Recieved a message...", ","+arg1.getExtras());
             
             cont=context;
             notification_message = arg1.getStringExtra("message") ;
             notificationManager(context, arg1.getStringExtra("name"), arg1.getStringExtra("image"),arg1.getStringExtra("bless"),arg1.getStringExtra("type"));
                 Log.v("gcm message: ", ""+arg1.getStringExtra("message"));// 
                 Log.v("gcm name: ", ""+arg1.getStringExtra("name"));// 
                 Log.v("gcm image: ", ""+arg1.getStringExtra("image"));// 
                 Log.v("gcm bless: ", ""+arg1.getStringExtra("bless"));// 
                 
                 ActivityManager activityManager = (ActivityManager) this.getSystemService(ACTIVITY_SERVICE);
                    List<RunningAppProcessInfo> procInfos = activityManager.getRunningAppProcesses();

                    for (int i = 0; i < procInfos.size(); i++) {
                         Log.e("pos=" + i, "" + procInfos.get(i).processName);
                        if (procInfos.get(i).processName.equals("com.app.tobuy")) {
                            // app is running
                        }
                    }
                    
                    
                    
                
             }
             catch(Exception e){
                 Log.e("Recieved exception message arg1...", ","+arg1);
                 Log.e("exception", ","+e);
             }

             
        }

      
        @SuppressWarnings("deprecation")
        private void notificationManager(Context context, String name, String image,String bless,String type) {
            
            long when = System.currentTimeMillis();
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            Data.name = name;
          Data.image = image;
          Data.blessid=bless;
          Data.type=type;
            
            //notificationIntent = new Intent(context, Login.class);
            try {
                Data.push = true;
                
                if(type.equals("1"))
                {
                    Data.fromnotification=true;
                notificationIntent = new Intent(context, Class.forName("app.hackathon.blessup.HomePage")); 
                }
                else
                {
                    Data.fromnotification=false;
                    notificationIntent = new Intent(context, Class.forName("app.hackathon.blessup.RandomBliss"));
                }
            } catch (ClassNotFoundException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            Log.v("notification_message",","+notification_message);
            
            Notification notification = new Notification(R.drawable.app_icon, notification_message, when);
            //String title = "New Notification.";
            String title = "Blessup";
            
            // set intent so it does not start a new activity
            notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            
            PendingIntent intent = PendingIntent.getActivity(context, 0, notificationIntent, 0);

            notification.setLatestEventInfo(context, title, notification_message, intent);
            notification.flags |= Notification.FLAG_AUTO_CANCEL;
            // Play default notification sound
            notification.defaults |= Notification.DEFAULT_SOUND;
            // Vibrate if vibrate is enabled
            notification.defaults |= Notification.DEFAULT_VIBRATE;
            notificationManager.notify(0, notification);
            
        }

        protected void onRegistered(Context arg0, String arg1) {
             Log.e("Registration", "!");
             Log.e("Registration", arg1.toString());
             Data.regId = arg1.toString();
        }

        protected void onUnregistered(Context arg0, String arg1) {
             Log.e("Registration", "Got an error4!");
             Log.e("Registration", arg1.toString());
        }

         
        



}




//package app.hackathon.blessup;
//
//import java.util.List;
//
//import android.app.ActivityManager;
//import android.app.ActivityManager.RunningAppProcessInfo;
//import android.app.Notification;
//import android.app.NotificationManager;
//import android.app.PendingIntent;
//import android.content.Context;
//import android.content.Intent;
//import android.util.Log;
//
//import com.google.android.gcm.GCMBaseIntentService;
//
///**
// * Project Name :- ToBuy Purpose of file :- This file used to show the push
// * notification in the app. Developed by Clicklabs Pvt. Ltd. Developer:- Gurmail
// * Singh Kang. Link:- http://www.click-labs.com
// */
//
//public class GCMIntentService extends GCMBaseIntentService {
//
//    static Intent notificationIntent;
//    static String notification_message;
//
//    static Context cont;
//
//    protected void onError(Context arg0, String arg1) {
//        Log.e("Registration", "Got an error1!");
//        Log.e("Registration", arg1.toString());
//    }
//
//    protected boolean onRecoverableError(Context context, String errorId) {
//        Log.d("onRecoverableError", errorId);
//        return false;
//    }
//
//    protected void onMessage(Context context, Intent arg1) {
//        try {
//            Log.e("Recieved a message...", "," + arg1.getExtras());
//
//            cont = context;
//            notification_message = arg1.getStringExtra("message");
////            notificationManager(context, arg1.getStringExtra("message"),
////                    arg1.getStringExtra("name"), arg1.getStringExtra("image"));
//            notificationManager(getApplicationContext(),
//                    arg1.getStringExtra("name"), arg1.getStringExtra("image"));
//            Log.v("gcm message: ", "" + arg1.getStringExtra("message"));//
//            Log.v("gcm name: ", "" + arg1.getStringExtra("name"));//
//            Log.v("gcm image: ", "" + arg1.getStringExtra("image"));//
//            ActivityManager activityManager = (ActivityManager) this
//                    .getSystemService(ACTIVITY_SERVICE);
//            List<RunningAppProcessInfo> procInfos = activityManager.getRunningAppProcesses();
//            for (int i = 0; i < procInfos.size(); i++) {
//                Log.e("pos=" + i, "" + procInfos.get(i).processName);
//                if (procInfos.get(i).processName.equals("com.app.tobuy")) {
//                    // app is running
//                }
//            }
//
//        } catch (Exception e) {
//            Log.e("Recieved exception message arg1...", "," + arg1);
//            Log.e("exception", "," + e);
//        }
//
//    }
//
//    @SuppressWarnings("deprecation")
//    private void notificationManager(Context context, String name, String image) {
//        long when = System.currentTimeMillis();
//        NotificationManager notificationManager = (NotificationManager) context
//                .getSystemService(Context.NOTIFICATION_SERVICE);
//
//
//        // notificationIntent = new Intent(context, Login.class);
//        try {
//            Data.name = name;
//            Data.image = image;
//            Data.push = true;
//            notificationIntent = new Intent(getApplicationContext(),
//                    Class.forName("app.hackathon.blessup.HomePage"));
//        } catch (ClassNotFoundException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//        Log.v("notification_message", "," + notification_message);
//        // if(notification_message.equals("Admin wants more information."))
//        // {
//        // //notification_message = "Admin wants more information.";
//        // notification_message = "Administraci—n quiere m‡s informaci—n.";
//        // }
//        // else
//        // if(notification_message.equals("Your Product information is available now."))
//        // {
//        // //notification_message =
//        // "Your Product information is available now.";
//        // notification_message =
//        // "Su informaci—n del producto ya est‡ disponible.";
//        // }
//        // else
//        // {
//        //
//        // }
//        //
//
//        Notification notification = new Notification(R.drawable.app_icon, notification_message,
//                when);
//        // String title = "New Notification.";
//        String title = "Bless up notification.";
//        // notificationIntent.putExtra("NotificationMessage", result);
//        notificationIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
//                | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//
//        PendingIntent intent = PendingIntent.getActivity(context, 0, notificationIntent, 0);
//
//        notification.setLatestEventInfo(context, title, notification_message, intent);
//        notification.flags |= Notification.FLAG_AUTO_CANCEL;
//        // Play default notification sound
//        notification.defaults |= Notification.DEFAULT_SOUND;
//        // Vibrate if vibrate is enabled
//        notification.defaults |= Notification.DEFAULT_VIBRATE;
//        notificationManager.notify(0, notification);
//
//    }
//
//    protected void onRegistered(Context arg0, String arg1) {
//        Log.e("Registration", "!");
//        Log.e("Registration", arg1.toString());
//        Data.regId = arg1.toString();
//    }
//
//    protected void onUnregistered(Context arg0, String arg1) {
//        Log.e("Registration", "Got an error4!");
//        Log.e("Registration", arg1.toString());
//    }
//
//}