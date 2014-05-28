package app.hackathon.blessup;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;

import com.androidquery.AQuery;
import com.androidquery.callback.ImageOptions;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.squareup.picasso.Picasso;
import com.vinayrraj.flipdigit.lib.Flipmeter;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import app.hackathon.blessup.HomePage.FriendsAdapter;
import app.hackathon.blessup.HomePage.FriendsAdapterRegistered;
import app.hackathon.blessup.HomePage.ViewHolder;
import app.hackathon.blessup.HomePage.ViewHolder2;

public class FriendOfFriends  extends Activity {
    Button backbtn;
    FriendsAdapter adapter;
    Typeface face1;
    Typeface face2;
    Typeface face3;
    Typeface face4;
    ListView friendsList;
    TextView reg,nonreg;
    
    ArrayList<String> reg_frand_id = new ArrayList<String>();
    ArrayList<String> frand_user_id = new ArrayList<String>();
    ArrayList<String> frand_name = new ArrayList<String>();
    ArrayList<String> frand_image = new ArrayList<String>();
    ArrayList<String> frand_fb_id = new ArrayList<String>();
    ArrayList<String> reg_frand_name = new ArrayList<String>();
    ArrayList<String> reg_frand_image = new ArrayList<String>();
    ArrayList<String> reg_frand_fb_id = new ArrayList<String>();
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.friendoffriend);
        backbtn=(Button)findViewById(R.id.backbtn);
        face1 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L003.otf");
        face2 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L004.otf");
        face3 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L005.otf");
        face4 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L006.otf");
        reg= (TextView) findViewById(R.id.registered);
        nonreg= (TextView) findViewById(R.id.unregistered);
        reg.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                friendsList.setAdapter(new FriendsAdapter());
                friendsList.setVisibility(0);
               // nonreglist.setVisibility(8);
                nonreg.setBackgroundResource(R.drawable.send_blessings_normal);
                reg.setBackgroundResource(R.drawable.invite_frnds_click);

            }
        });
        nonreg.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                friendsList.setVisibility(8);
               // nonreglist.setVisibility(0);
                friendsList.setAdapter(new FriendsAdapterRegistered());
                nonreg.setBackgroundResource(R.drawable.send_blessings_click);
                reg.setBackgroundResource(R.drawable.invite_frnds_normal);

            }
        });
        backbtn.setOnClickListener(new View.OnClickListener() {
            
            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                finish();
            }
        });
        if(!AppStatus.getInstance(getApplicationContext()).isOnline(getApplicationContext()))
        {
       Toast.makeText(getApplicationContext(), "Please, Check Your internet connection.",500).show();
        }
        else
        {
         Fetch_Facebook_Friends();
        }
    }
    
    
    // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void Fetch_Facebook_Friends() {
        final ProgressDialog dialog = ProgressDialog.show(FriendOfFriends.this, "",
                getResources().getString(R.string.loading), true);

        Log.v("pressed_user_id","pressed_user_id = "+Data.pressed_user_id);
        
        Log.v("app_access_token","app_access_token = "+Data.app_access_token);
     
        
        RequestParams params = new RequestParams();
       
        params.put("userid", Data.pressed_user_id);
        params.put("fbid",  Data.pressed_fb_id);
        params.put("accesstoken", Data.app_access_token);
       
        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath+"get_fb_friends_of_friend",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                         Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            res = new JSONObject(response_str);

                            frand_name.clear();
                            frand_image.clear();

                            JSONArray val = res.getJSONArray("unregistered");
                            JSONArray reg = res.getJSONArray("registered_fb_friends");
                            for (int i = 0; i < reg.length(); i++)
                            {
                                JSONObject c2 = reg.getJSONObject(i);
                                reg_frand_image.add(c2.getString("user_image"));
                                reg_frand_name.add(c2.getString("user_name"));
                                reg_frand_fb_id.add(c2.getString("user_id"));
                                reg_frand_id.add(c2.getString("fb_id"));
                               

                            }
                            // for(int i=val.length()-1;i>=0;i--)
                            for (int i = 0; i < val.length(); i++)
                            {
                                JSONObject c1 = val.getJSONObject(i);
                                frand_image.add(c1.getString("image"));
                                frand_name.add(c1.getString("name"));
                                frand_fb_id.add(c1.getString("id"));
                               

                            }
                            //Log.i("...",frand_image+"..");
                            friendsList.setAdapter(new FriendsAdapterRegistered());
                            dialog.cancel();
//                            adapter=new FriendsAdapter();
//                            friendsList.setAdapter(adapter);
                            dialog.cancel();
                           // startActivity(new Intent(HomePage.this,HomePage.class));

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
    
    
    public class FriendsAdapter extends BaseAdapter {

        private  LayoutInflater inflater;
        ViewHolder holder;
        boolean flag = true;
        
        public FriendsAdapter(){
            inflater = (LayoutInflater)getApplicationContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
//            if(!AppStatus.getInstance(FriendsAdapter.this).isOnline(FriendsAdapter.this))
//                flag = false;
        }
        @Override
        public int getCount() {
            //  
            
            return frand_fb_id.size();
        }
        
        @Override
        public Object getItem(int position) {
            //  
            return position;
        }

        @Override
        public long getItemId(int position) {
            //  
            return position;
        }
 
        
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            //  
                if(convertView == null){
                    
                    convertView = inflater.inflate(R.layout.friend_list_item, null);
                
                    holder = new ViewHolder();
                    holder.fl = (LinearLayout) convertView.findViewById(R.id.listlayout);
                    holder.textView = (TextView) convertView.findViewById(R.id.namefield); 
                   
                    
                   
                    holder.pic = (ImageView) convertView.findViewById(R.id.friendprofimage);
                   
                   
//                    holder.fl.setLayoutParams(new ListView.LayoutParams(720, 240));
//                    ASSL.DoMagic(holder.fl);
                    
                    holder.pic.setTag(holder);
                    holder.textView.setTag(holder);
                    holder.fl.setTag(holder);
                    
                    convertView.setTag(holder);
            }else{
                    holder = (ViewHolder) convertView.getTag();
            }
            
               
                
               // String url="https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-frc1/t31.0-8/905689_490227854365332_1106635553_o.jpg";
                if(frand_image.get(position).length()!=0)
                {
                    Log.i("inside...", frand_image.get(position)+"..");
                    Picasso.with(FriendOfFriends.this).load(frand_image.get(position).toString()).into(holder.pic);
                }
                else
                {
                    String url="https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-frc1/t31.0-8/905689_490227854365332_1106635553_o.jpg";
                    Picasso.with(FriendOfFriends.this).load(url).into(holder.pic);
                }
                    holder.textView.setText(frand_name.get(position));
               
//                    Picasso.with(getApplicationContext())
//
//                    .load(frand_image.get(position))
//
//                    .transform(new utils.CircleTransform()).fit()
//
//                    .into(holder.pic);
              
                
              
                
                
                holder.fl.setOnClickListener(new View.OnClickListener() {
                    
                    @Override
                    public void onClick(View v) {
                        holder = (ViewHolder) v.getTag();
                        int pos = holder.x;
                      
                    }
                });
                holder.fl.setOnLongClickListener(new View.OnLongClickListener() {
                    
                    @Override
                    public boolean onLongClick(View v) {
                        Toast.makeText(getApplicationContext(), "bbbbb", 500).show();
                        // TODO Auto-generated method stub
                        return false;
                       
                    }
                });
                
               
    
            return convertView;
 
        }

    }
    
    public class ViewHolder{
        
        TextView textView;
       
        LinearLayout fl;
       
        ImageView pic;
        int x;
    }
    
    
    public class FriendsAdapterRegistered extends BaseAdapter {

        private LayoutInflater inflater;
        ViewHolder2 holder;
        boolean flag = true;
        ImageOptions options;

        public FriendsAdapterRegistered() {
            options = new ImageOptions();
            options.round = 100;
            options.fileCache = true;
            options.memCache = true;
            options.targetWidth = 100;
            options.fallback = R.drawable.ic_launcher;
            inflater = (LayoutInflater) getApplicationContext().getSystemService(
                    Context.LAYOUT_INFLATER_SERVICE);
            // if(!AppStatus.getInstance(FriendsAdapter.this).isOnline(FriendsAdapter.this))
            // flag = false;
        }

        @Override
        public int getCount() {
            //

            return reg_frand_fb_id.size();
        }

        @Override
        public Object getItem(int position) {
            //
            return position;
        }

        @Override
        public long getItemId(int position) {
            //
            return position;
        }

        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            //
            if (convertView == null) {

                convertView = inflater.inflate(R.layout.friend_list_item, null);

                holder = new ViewHolder2();
                holder.fl = (LinearLayout) convertView.findViewById(R.id.listlayout);
                holder.textView = (TextView) convertView.findViewById(R.id.namefield);
                holder.blessimage = (ImageView) convertView.findViewById(R.id.blessimage);

                holder.pic = (ImageView) convertView.findViewById(R.id.friendprofimage);

                // holder.fl.setLayoutParams(new ListView.LayoutParams(720,
                // 240));
                // ASSL.DoMagic(holder.fl);

                holder.pic.setTag(holder);
                holder.textView.setTag(holder);
                holder.fl.setTag(holder);

                convertView.setTag(holder);
            } else {
                holder = (ViewHolder2) convertView.getTag();
            }

            // String
            // url="https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-frc1/t31.0-8/905689_490227854365332_1106635553_o.jpg";
            holder.blessimage.setBackgroundResource(R.drawable.blessup_btn_norma);
            holder.textView.setTypeface(face1);
            AQuery fbQuery = new AQuery(convertView);
            fbQuery.id(holder.pic).image(reg_frand_image.get(position), options);

            holder.textView.setText(reg_frand_name.get(position));

        
             holder.fl.setOnLongClickListener(new View.OnLongClickListener() {
            
             @Override
             public boolean onLongClick(View v) {
            
             Data.pressed_user_id = reg_frand_fb_id.get(position);
             Data.profilemyself= reg_frand_image.get(position);
             Data.pressed_fb_id=reg_frand_id.get(position);
             startActivity(new Intent(FriendOfFriends.this, FriendOfFriends.class));
             // Toast.makeText(getApplicationContext(), "bbbbb",
             // 500).show();
             // TODO Auto-generated method stub
             return false;
            
             }
             });
            holder.fl.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    holder = (ViewHolder2) v.getTag();
                    int pos = holder.x;
                    Data.pressed_user_id = reg_frand_fb_id.get(position);
                    Data.blessed_user_name = reg_frand_name.get(position);
                    if (!AppStatus.getInstance(getApplicationContext()).isOnline(
                            getApplicationContext()))
                    {
                        Toast.makeText(getApplicationContext(),
                                "Please, Check Your internet connection.", 500).show();
                    }
                    else
                    {
                        BlessFriend();
                    }

                }
            });
         

            return convertView;

        }

    }

    public class ViewHolder2 {

        public ImageView blessimage;

        TextView textView;

        LinearLayout fl;

        ImageView pic;
        int x;
    }
    
    // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void BlessFriend() {
        final ProgressDialog dialog = ProgressDialog.show(FriendOfFriends.this, "",
                getResources().getString(R.string.loading), true);

        Log.v("fbid", "pressed_user_id = " + Data.pressed_user_id);

        Log.v("fbaccesstoken", "fbaccesstoken = " + Data.app_access_token);

        RequestParams params = new RequestParams();

        params.put("accesstoken", Data.app_access_token);
        params.put("userid", Data.pressed_user_id);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath + "bless_user",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                        Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            String log="",error="";
                            res = new JSONObject(response_str);

                             try {
                                log=res.getString("log");
                            } catch (Exception e) {
                                // TODO Auto-generated catch block
                                e.printStackTrace();
                                log="";
                            }
                          
                            if (log.equals("User blessed successfully."))
                            {
                                Toast.makeText(getApplicationContext(),
                                        "Blessing sent to " + Data.blessed_user_name, 500).show();
                            }
                            else
                            {
                             
                                    Toast.makeText(getApplicationContext(),
                                            "You already blessed " + Data.blessed_user_name, 500).show(); 
                              
                            }
                            dialog.cancel();
                            // startActivity(new
                            // Intent(HomePage.this,HomePage.class));

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
                        Toast.makeText(getApplicationContext(), "Server not responding.", 500)
                                .show();
                    }
                });
    }
}
