
package app.hackathon.blessup;

import java.util.Arrays;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.hardware.Camera;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import com.facebook.LoggingBehavior;
import com.facebook.Request;
import com.facebook.Response;
import com.facebook.Session;
import com.facebook.SessionLoginBehavior;
import com.facebook.SessionState;
import com.facebook.Settings;
import com.facebook.model.GraphUser;
import com.google.android.gcm.GCMRegistrar;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

public class MainActivity extends Activity {

    Button login;
    ProgressDialog fbdialog;
    Session session;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        try {
            registerGCM(MainActivity.this);
        } catch (Exception e1) {
            // TODO Auto-generated catch block
            e1.printStackTrace();
        }
        Session.setActiveSession(null);
        login=(Button)findViewById(R.id.loginbyfacebook);
        if(getPreference(getApplicationContext(),"app_access_token").length()!=0)
        {
        if (!AppStatus.getInstance(getApplicationContext()).isOnline(getApplicationContext()))
        {
            Toast.makeText(getApplicationContext(), "Please, Check Your internet connection.", 500)
                    .show();
        }
        else
        {
            GetData();
        }
        }
        
       // Toast.makeText(getApplicationContext(), ""+getPreference(getApplicationContext(),"app_access_token"), 500).show();
       
        login.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                int totalCameras = Camera.getNumberOfCameras();
                Log.v("totalCameras"," = "+totalCameras);
                   if(totalCameras>0){
                //if(Data.isDeviceSupportCamera(Login.this)){
                      
                if (!AppStatus.getInstance(MainActivity.this).isOnline(MainActivity.this)) {
                    Log.e("no net", "==");
                    dialog_popup(getResources().getString(R.string.internet_check));
                } else {
                    Log.i(" connection", " connection");
                    session = new Session(MainActivity.this);
                    Session.setActiveSession(session);
                    Settings.addLoggingBehavior(LoggingBehavior.INCLUDE_RAW_RESPONSES);
                    Session.OpenRequest openRequest = null;
                    openRequest = new Session.OpenRequest(MainActivity.this);
                    openRequest.setPermissions(Arrays.asList("email","user_friends", "user_photos"));
                    try {
                        if (isSystemPackage(getPackageManager().getPackageInfo(
                                "com.facebook.katana", 0))) {
                            openRequest
                                    .setLoginBehavior(SessionLoginBehavior.SUPPRESS_SSO);
                        } else {
                            openRequest
                                    .setLoginBehavior(SessionLoginBehavior.SSO_WITH_FALLBACK);
                        }
                    } catch (NameNotFoundException e) {
                        e.printStackTrace();
                    }

                    openRequest.setCallback(new Session.StatusCallback() {
                        @Override
                        public void call(Session session, SessionState state,
                                Exception exception) {
                            if (session.isOpened()) {
                                Session.openActiveSession(MainActivity.this, true,
                                        new Session.StatusCallback() {
                                            @SuppressWarnings("deprecation")
                                            @Override
                                            public void call(
                                                    final Session session,
                                                    SessionState state,
                                                    Exception exception) {

                                                if (session.isOpened()) {
                                                    Log.e("heyyy",
                                                            "Logged in..."
                                                                    + session
                                                                            .getAccessToken());
                                                    String acctoken = session
                                                            .getAccessToken();
                                                    Log.i("token..111",
                                                            acctoken + "...1");
                                                } else if (session.isClosed()) {
                                                    Log.e("heyy",
                                                            "Logged out...");
                                                }
                                                Log.v("app id",
                                                        ""
                                                                + session
                                                                        .getApplicationId());
                                                if (session.isOpened()) {
                                                    fbdialog = ProgressDialog
                                                            .show(MainActivity.this,
                                                                    "",
                                                                    "Loading... ",
                                                                    true);
                                                    String acctoken = session
                                                            .getAccessToken();
                                                    Request.executeMeRequestAsync(
                                                            session,
                                                            new Request.GraphUserCallback() {
                                                                @Override
                                                                public void onCompleted(
                                                                        GraphUser user,
                                                                        Response response) { // fetching
                                                                    if (user != null) {
                                                                        Log.i("data",
                                                                                "username"
                                                                                        + user.getName()
                                                                                        + "fbid!"
                                                                                        + user.getId()
                                                                                        + " firstname "
                                                                                        + user.getFirstName()
                                                                                        + " lastname "
                                                                                        + user.getLastName()
                                                                                        + "  ");

                                                                        user.getFirstName();
                                                                        Log.i("res",
                                                                                response.toString());
                                                                        Log.i("TAG",
                                                                                "User ID "
                                                                                        + user.getId());
                                                                        Log.i("TAG",
                                                                                "Email "
                                                                                        + user.asMap()
                                                                                                .get("email"));
                                                                        Log.i("TAG",
                                                                                "birth day "
                                                                                        + user.asMap()
                                                                                                .get("birthday"));
                                                                        Log.i("TAG",
                                                                                "location "
                                                                                        + user.asMap()
                                                                                                .get("location"));
                                                                        Log.i("TAG",
                                                                                "birth day "
                                                                                        + user.getBirthday());

                                                                        Log.d("response==",
                                                                                response.toString());

                                                                        Log.e("response==",
                                                                                "."
                                                                                        + response
                                                                                                .getGraphObject());

                                                                        String user_name = user
                                                                                .asMap()
                                                                                .get("name")
                                                                                + "";
                                                                        String firstname = user
                                                                                .asMap()
                                                                                .get("first_name")
                                                                                + "";

                                                                    Data.fbaccesstoken = session.getAccessToken();
                                                                    Data.fbid  = user.getId();
                                                                    Data.fbname = ""+user.asMap().get("name");
                                                                        try {
                                                                        Data.email = ""+user.asMap().get("email");
                                                                            if (Data.email.equals("null"))
                                                                                Data.email = user.asMap().get("username")+ "@facebook.com";
                                                                        } catch (Exception e2) {
                                                                            e2.printStackTrace();
                                                                        }
                                                                        fbdialog.cancel();
                                                                    
                                                                         if
                                                                         (!AppStatus.getInstance(getApplicationContext()).isOnline(getApplicationContext()))
                                                                         {
                                                                             Toast.makeText(getApplicationContext(), "Please, Check Your internet connection.",500).show();
                                                                         }
                                                                         else
                                                                         {
                                                                        
                                                                             //startActivity(new Intent(MainActivity.this,HomePage.class));
                                                                        Facebook_Register();
                                                                     
                                                                        
                                                                         }

                                                                    }

                                                                }

                                                            });

                                                }

                                            }

                                        });

                            } else if (session.isClosed()) {

                            }

                        }

                    });

                    session.openForRead(openRequest);

                }
            }else
            {
               // Toast.makeText(getApplicationContext(), ""+getResources().getString(R.string.camera), 1000).show();
            }
            }

        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    private boolean isSystemPackage(PackageInfo pkgInfo) {

        return ((pkgInfo.applicationInfo.flags & ApplicationInfo.FLAG_SYSTEM) != 0) ? true

                : false;

    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {

        try {

            super.onActivityResult(requestCode, resultCode, data);

            Session.getActiveSession().onActivityResult(this, requestCode,

            resultCode, data);

        } catch (Exception e) {

            e.printStackTrace();

        }

    }
 // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void Facebook_Register() {
        final ProgressDialog dialog = ProgressDialog.show(MainActivity.this, "",
                getResources().getString(R.string.loading), true);

        registerGCM(MainActivity.this);
        Log.v("fbid","fbid = "+Data.fbid);
        Log.v("fbname","fbname = "+Data.fbname);
        Log.v("fbaccesstoken","fbaccesstoken = "+Data.fbaccesstoken);
        Log.v("email","email = "+Data.email);
        Log.v("regId","regId = "+Data.regId);
        
        RequestParams params = new RequestParams();
        params.put("fbid", Data.fbid);
        params.put("fbname", Data.fbname);
        params.put("fbaccesstoken", Data.fbaccesstoken);
        params.put("email", Data.email);
        params.put("devicetoken", Data.regId);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath+"registration_or_login_through_facebook",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                         Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            JSONArray info = null;
                            res = new JSONObject(response_str);
                            info = res.getJSONArray("data");

                           ////////////////////////////////##############
                            Data.app_access_token=info.getJSONObject(0).getString("access_token");
                          //  Toast.makeText(getApplicationContext(), "......"+Data.app_access_token, 500).show();
                            setPreference(getApplicationContext(),Data.app_access_token,"app_access_token");
                            setPreference(getApplicationContext(),Data.fbid,"fb_id");
                            setPreference(getApplicationContext(),Data.fbaccesstoken,"fb_token");
                            setPreference(getApplicationContext(),info.getJSONObject(0).getString("user_name"),"user_name");
                            setPreference(getApplicationContext(),info.getJSONObject(0).getString("user_image"),"user_image");
                            if(Data.app_access_token.length()!=0)
                            {
                            Toast.makeText(
                                    getApplicationContext(),
                                    "login",
                                    500).show();
                            dialog.cancel();
                            startActivity(new Intent(MainActivity.this,HomePage.class));
                            }
                            else
                            {
                                Toast.makeText(
                                        getApplicationContext(),
                                        "Something went wrong",
                                        500).show();
                            }

                        } catch (Exception e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                            // Log.e("errorr at response", "" + e.toString());
                            Toast.makeText(
                                    getApplicationContext(),
                                    "Server not responding.Please try again later.",
                                    500).show();
                        }

                    }

                    @Override
                    public void onFailure(Throwable arg0) {
                        dialog.cancel();
                        Toast.makeText(getApplicationContext(),"Server not responding.",500).show();
                    }
                });
    }
    
    
    
    
    
    
 // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void GetData() {
        final ProgressDialog dialog = ProgressDialog.show(MainActivity.this, "",
                getResources().getString(R.string.loading), true);

        registerGCM(MainActivity.this);
        Log.v("fbid","fbid = "+Data.fbid);
        Log.v("fbname","fbname = "+Data.fbname);
        Log.v("fbaccesstoken","fbaccesstoken = "+Data.fbaccesstoken);
        Log.v("email","email = "+Data.email);
        Log.v("regId","regId = "+Data.regId);
        
        RequestParams params = new RequestParams();
       
       
        params.put("accesstoken", Data.app_access_token);
       
        params.put("devicetoken", Data.regId);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath+"update_devicetoken",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                         Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            JSONArray info = null;
                            res = new JSONObject(response_str);
//                            info = res.getJSONArray("data");

                           ////////////////////////////////##############
//                            Data.app_access_token=info.getJSONObject(0).getString("access_token");
//                            Toast.makeText(getApplicationContext(), "......"+Data.app_access_token, 500).show();
//                            setPreference(getApplicationContext(),Data.app_access_token,"app_access_token");
//                            setPreference(getApplicationContext(),Data.fbid,"fb_id");
//                            setPreference(getApplicationContext(),Data.fbaccesstoken,"fb_token");
//                            setPreference(getApplicationContext(),info.getJSONObject(0).getString("user_name"),"user_name");
//                            setPreference(getApplicationContext(),info.getJSONObject(0).getString("user_image"),"user_image");
//                            if(Data.app_access_token.length()!=0)
//                            {
//                            Toast.makeText(
//                                    getApplicationContext(),
//                                    "login",
//                                    500).show();
//                            dialog.cancel();
//                            startActivity(new Intent(MainActivity.this,HomePage.class));
//                            }
//                            else
//                            {
//                                Toast.makeText(
//                                        getApplicationContext(),
//                                        "Something went wrong",
//                                        500).show();
//                            }
                            
                            if(getPreference(getApplicationContext(),"app_access_token").length()!=0)
                            {
                                Data.fbid=getPreference(getApplicationContext(),"fb_id");
                                Data.fbaccesstoken=getPreference(getApplicationContext(),"fb_token");
                                Data.app_access_token=getPreference(getApplicationContext(),"app_access_token");
                                finish();
                                startActivity(new Intent(MainActivity.this,HomePage.class));
                            }
                            

                        } catch (Exception e) {
                            // TODO Auto-generated catch block
                            e.printStackTrace();
                            // Log.e("errorr at response", "" + e.toString());
                            Toast.makeText(
                                    getApplicationContext(),
                                    "Server not responding.Please try again later.",
                                    500).show();
                        }

                    }

                    @Override
                    public void onFailure(Throwable arg0) {
                        dialog.cancel();
                        Toast.makeText(getApplicationContext(),"Server not responding.",500).show();
                    }
                });
    }
    
    
    
    /**
     * Function to register device with Google Cloud Messaging Services and
     * receive Device Token
     * 
     * @param cont
     *            application context
     */
    public void registerGCM(Context cont) {
        try { // registering GCM services
            GCMRegistrar.checkManifest(cont);
            Data.regId = GCMRegistrar.getRegistrationId(cont);
            if (Data.regId.equals("")) {
                GCMRegistrar.register(cont, Data.GCMAppId);
                Data.regId = GCMRegistrar.getRegistrationId(cont);
                //Toast.makeText(getApplicationContext(), ""+Data.regId, 1000).show();
                Log.e("reg_id in if.......", " >" + Data.regId + " ");
            } else {
                Log.v("GCM", "Already registered");
                Log.e("reg_id..............in else........", " >" + Data.regId
                        + " ");
                Log.e("reg_id....length", Data.regId.length() + " ");
            }
        } catch (Exception e) {
            Log.e("exception GCM", e.toString() + " " + e.toString());
        }
    }
    /**
     * Displays default android dialog for displaying alert message to user
     * @param message string
     */
    void dialog_popup(String message) {
        AlertDialog.Builder builder = new AlertDialog.Builder(MainActivity.this);
        builder.setMessage("" + message).setTitle(R.string.app_name);
       //builder.setIcon(R.drawable.tobuy_icon);
        builder.setCancelable(false);
        builder.setPositiveButton(getResources().getString(R.string.ok), new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
            }
        });
        AlertDialog alertDialog = builder.create();
//      alertDialog.getWindow().getAttributes().windowAnimations = R.style.Animations_SmileWindow;
        alertDialog.show();
    }
    static public boolean setPreference(Context c, String value, String key) {
        SharedPreferences settings = c.getSharedPreferences("bless", 0);
        settings = c.getSharedPreferences("bless", 0);
        SharedPreferences.Editor editor = settings.edit();
        editor.putString(key, value);
        return editor.commit();
    }

    static public String getPreference(Context c, String key) {
        SharedPreferences settings = c.getSharedPreferences("bless", 0);
        settings = c.getSharedPreferences("bless", 0);
        String value = settings.getString(key, "");
        return value;
    }
}
