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
//public class GCMIntentService extends GCMBaseIntentService {
//    
//    static Intent notiIntent;  
//    static String notimsg;
//    
//    static Context cont;
//    
//    
//        protected void onError(Context arg0, String arg1) {
//             Log.e("Registration", "Got an error1!");
//             Log.e("Registration",arg1.toString());
//        }
//
//        protected boolean onRecoverableError(Context context, String errorId){
//            Log.d("onRecoverableError", errorId);
//            return false;       
//        }
//
//        
//      
//        
//        protected void onMessage(Context context, Intent arg1) {
//            try{
//                 
//             Log.e("Recieved a message...", ","+arg1.getStringExtra("message"));
//             
//             cont=context;
//             notimsg =arg1.getStringExtra("message") ;
//             notificationManager(context,arg1.getStringExtra("message"));
//                 Log.v("gcm message: ", ""+arg1.getStringExtra("message"));
//                 Log.v("gcm message: ", ""+arg1.getExtras());
//           // Toast.makeText(context, "msg recived!!", 1000).show();
//                 ActivityManager activityManager = (ActivityManager) this.getSystemService(ACTIVITY_SERVICE);
//                 List<RunningAppProcessInfo> procInfos = activityManager.getRunningAppProcesses();
//
//                 for (int i = 0; i < procInfos.size(); i++) {
//                      Log.e("pos=" + i, "" + procInfos.get(i).processName);
////                     if (procInfos.get(i).processName.equals("com.velletechnology.frattracker")) {
////                         // app is running
////                     }
//                 }
//                 
//             
//             }
//             catch(Exception e){
//                 Log.e("Recieved exception message arg1...", ","+arg1);
//                 Log.e("exception", ","+e);
//             }
//
//             
//        }
//
//      
//        @SuppressWarnings("deprecation")
//        private void notificationManager(Context context, String message) {
//            
//            long when = System.currentTimeMillis();
//            NotificationManager notiManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//            Log.v("message",","+message);
//            
////           PackageManager pm = getPackageManager();
////           notificationIntent = pm.getLaunchIntentForPackage(getApplicationContext().getPackageName());
////          Intent notificationIntent = new Intent(context, pushnotification.class);
////
////            notificationIntent.addCategory(Intent.CATEGORY_LAUNCHER);
////            notificationIntent.setAction(Intent.ACTION_MAIN);
////            notification.flags = Notification.FLAG_AUTO_CANCEL;
////            
////
////            PendingIntent intent = PendingIntent.getActivity(context, 0,notificationIntent, 0);
//            
//                
//                try {
//                    notiIntent = new Intent(context, Class.forName("app.hackathon.blessup.RandomBliss"));
//                } catch (ClassNotFoundException e) {
//                    // TODO Auto-generated catch block
//                    e.printStackTrace();
//                }
//                Log.v("notification_message",","+notimsg);
//            Notification notification = new Notification(R.drawable.app_icon, notimsg, when);
//            String title = "New Notification.";
//            
//            // set intent so it does not start a new activity
//            notiIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//            PendingIntent intent = PendingIntent.getActivity(context, 1, notiIntent, 0);
//            notification.setLatestEventInfo(context, title, notimsg, intent);
//            notification.flags |= Notification.FLAG_AUTO_CANCEL;
//            
//             // Play default notification sound
//            notification.defaults |= Notification.DEFAULT_SOUND;
//            // Vibrate if vibrate is enabled
//            notification.defaults |= Notification.DEFAULT_VIBRATE;
//            notiManager.notify(0, notification);
//            
//        }
//
//        protected void onRegistered(Context arg0, String arg1) {
//             Log.e("Registration", "!");
//             Log.e("Registration", arg1.toString());
//             Data.regId = arg1.toString();
//        }
//
//        protected void onUnregistered(Context arg0, String arg1) {
//             Log.e("Registration", "Got an error4!");
//             Log.e("Registration", arg1.toString());
//        }
//
//         
//        
//
//
//
//}

