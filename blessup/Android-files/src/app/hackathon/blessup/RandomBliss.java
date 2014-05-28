package app.hackathon.blessup;

import org.json.JSONArray;
import org.json.JSONObject;

import com.androidquery.AQuery;
import com.androidquery.callback.ImageOptions;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

public class RandomBliss extends Activity{
    
    ImageView prof_img,profile_image_back,profile_fimage;
    TextView prof_name;
    ImageOptions options;
    Button back;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.random_bliss);
        onNewIntent(getIntent());
        back=(Button) findViewById(R.id.backbtn);
        back.setOnClickListener(new View.OnClickListener() {
            
            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                finish();
            }
        });
    }
    @Override
    public void onNewIntent(Intent intent){
            
        
        prof_img=(ImageView)findViewById(R.id.profile_image);
        profile_image_back=(ImageView)findViewById(R.id.profile_image_back);
        profile_fimage=(ImageView)findViewById(R.id.profile_fimage);
        prof_name=(TextView)findViewById(R.id.label10);
                // extract the extra-data in the Notification
        
        
        // [{"user_name":"bravesoldier.pu","user_image":"http:\/\/graph.facebook.com\/100001513782830\/picture?width=160&height=160"}]
        if (!AppStatus.getInstance(getApplicationContext()).isOnline(getApplicationContext()))
        {
            Toast.makeText(getApplicationContext(), "Please, Check Your internet connection.", 500)
                    .show();
        }
        else
        {
            PushNotice();
        }
                
            }
    // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void PushNotice() {
        final ProgressDialog dialog = ProgressDialog.show(RandomBliss.this, "",
                getResources().getString(R.string.loading), true);

       //registerGCM(MainActivity.this);
       
        Log.v("request succesfull", "response = " + Data.blessid);
        Log.v("request succesfull", "response = " + Data.app_access_token);
        RequestParams params = new RequestParams();
       
       
        params.put("accesstoken", Data.app_access_token);
       
        params.put("blessid", Data.blessid);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath+"update_bless_view_status",
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

                            String error;
                            try {
                                error = res.getString("error");
                            } catch (Exception e) {
                                // TODO Auto-generated catch block
                                e.printStackTrace();
                                error="";
                            }
                                   if(error.equals("time out"))
                                   {
                                       prof_name.setText("Sorry, Notification Timeout");
                                       prof_name.setVisibility(8);
                                       profile_fimage.setVisibility(8);
                                   }
                                   else
                                   {
                                       prof_name.setVisibility(0);
                                       profile_fimage.setVisibility(0);
                                       options = new ImageOptions();
                                       options.round = 100;
                                       options.fileCache = true;
                                       options.memCache = true;
                                       options.targetWidth = 100;
                                       options.fallback = R.drawable.ic_launcher;
                                     
//                                       txtView = (TextView) findViewById(R.id.txtMessage);
                                       prof_name.setText(Data.name);
                                       AQuery fbQuery = new AQuery(getApplicationContext());
                                       fbQuery.id(prof_img).image(Data.image, options);
                                       fbQuery.id(R.id.profile_image_back).image(Data.image, true, true, 0, 0, null, AQuery.FADE_IN_NETWORK, 1.0f);
                                   }
                            
                    
                            
                            
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
}
