
package app.hackathon.blessup;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import org.json.JSONArray;
import org.json.JSONObject;



import com.androidquery.AQuery;
import com.androidquery.callback.ImageOptions;
import com.facebook.AccessToken;
import com.facebook.FacebookException;
import com.facebook.FacebookOperationCanceledException;
import com.facebook.Session;
import com.facebook.widget.WebDialog;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.squareup.picasso.Picasso;

import com.vinayrraj.flipdigit.lib.Flipmeter;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

public class HomePage extends Activity implements OnClickListener {

    Button profilebtn, settingsbtn, feedbtn, friendbtn;
    RelativeLayout profilelayout, settinglayout, feedlayout, friendlayout;
    int value = 000000;
    Flipmeter flipMeter = null;
    FriendsAdapter adapter;
    FeedAdapter feedadapter;
    ListView friendsList,nonreglist;
    ListView feedlist;
    
    ArrayList<String> reg_frand_id = new ArrayList<String>();
    ArrayList<String> frand_user_id = new ArrayList<String>();
    ArrayList<String> frand_name = new ArrayList<String>();
    ArrayList<String> frand_image = new ArrayList<String>();
    ArrayList<String> frand_fb_id = new ArrayList<String>();
    ArrayList<String> reg_frand_name = new ArrayList<String>();
    ArrayList<String> reg_frand_image = new ArrayList<String>();
    ArrayList<String> reg_frand_fb_id = new ArrayList<String>();
    ArrayList<String> feed_name = new ArrayList<String>();
    ArrayList<String> feed_image = new ArrayList<String>();
    ArrayList<String> feedtext = new ArrayList<String>();
    ArrayList<String> feedtime = new ArrayList<String>();
    Typeface face1;
    Typeface face2;
    Typeface face3;
    Typeface face4;
    TextView l1, l2, l3, l4, l10, l11, profilehead, c1, c2, c3, c4,reg,nonreg;
    String profileimage;
    Button set;
    Session.StatusCallback scb;
    private int mYear, mMonth, mDay, mHour, mMinute;
    LinearLayout timelay;
    TextView picker;
    String notificationtime;
    TimePicker timepicker;
    Button pushnotice;
    String pushflag = "1";
    ImageView profile_image, profile_image_back;
    ImageLoader1 imageLoader1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.mainscreen);
        profilebtn = (Button) findViewById(R.id.profilebtn);
        settingsbtn = (Button) findViewById(R.id.settingsbtn);
        feedbtn = (Button) findViewById(R.id.feedsbtn);
        friendbtn = (Button) findViewById(R.id.friendsbtn);
        profilelayout = (RelativeLayout) findViewById(R.id.profilelayout);
        settinglayout = (RelativeLayout) findViewById(R.id.settingslayout);
        feedlayout = (RelativeLayout) findViewById(R.id.feedlayout);
        friendlayout = (RelativeLayout) findViewById(R.id.friendlayout);
        timelay = (LinearLayout) findViewById(R.id.timelay);
        set = (Button) findViewById(R.id.settime);
        l1 = (TextView) findViewById(R.id.label1);
        l2 = (TextView) findViewById(R.id.label2);
        l3 = (TextView) findViewById(R.id.label3);
        l4 = (TextView) findViewById(R.id.label4);
        l10 = (TextView) findViewById(R.id.label10);
        l11 = (TextView) findViewById(R.id.label11);
        picker = (TextView) findViewById(R.id.picker);
        c1 = (TextView) findViewById(R.id.counter1);
        c2 = (TextView) findViewById(R.id.counter2);
        c3 = (TextView) findViewById(R.id.counter3);
        c4 = (TextView) findViewById(R.id.counter4);
        picker = (TextView) findViewById(R.id.picker);
        reg= (TextView) findViewById(R.id.registered);
        nonreg= (TextView) findViewById(R.id.unregistered);
        pushnotice = (Button) findViewById(R.id.onoff);
        friendbtn.setBackgroundResource(R.drawable.frnds_click_btn);
        settingsbtn.setBackgroundResource(R.drawable.settings_normal_btn);
        profilebtn.setBackgroundResource(R.drawable.profile_normal_btn);
        feedbtn.setBackgroundResource(R.drawable.feed_normal_btn);
        profile_image_back = (ImageView) findViewById(R.id.profile_image_back);
        profile_image = (ImageView) findViewById(R.id.profile_image);

        timepicker = (TimePicker) findViewById(R.id.timePicker);
        timepicker.setIs24HourView(true);
        profilehead = (TextView) findViewById(R.id.counterlabel);

        flipMeter = (Flipmeter) findViewById(R.id.Flipmeter);
        flipMeter.setValue(value, true);

        friendsList = (ListView) findViewById(R.id.frndlist);
        feedlist = (ListView) findViewById(R.id.feedlist);
        nonreglist= (ListView) findViewById(R.id.frndlistnon);
        face1 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L003.otf");
        face2 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L004.otf");
        face3 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L005.otf");
        face4 = Typeface.createFromAsset(getAssets(),
                "TitilliumText22L006.otf");
        l1.setTypeface(face1);
        l2.setTypeface(face1);
        l3.setTypeface(face1);
        l4.setTypeface(face1);
        l10.setTypeface(face2);
        l11.setTypeface(face2);
        picker.setTypeface(face3);
        reg.setBackgroundResource(R.drawable.invite_frnds_normal);
        nonreg.setBackgroundResource(R.drawable.send_blessings_click);
        //Toast.makeText(getApplicationContext(), ""+Data.type+"  "+Data.fromnotification, 500).show();
        if(Data.fromnotification==true)
        {
            Data.fromnotification=false;
            profilelayout.setVisibility(View.GONE);
            settinglayout.setVisibility(View.GONE);
            feedlayout.setVisibility(View.VISIBLE);
            friendlayout.setVisibility(View.GONE);
            friendbtn.setBackgroundResource(R.drawable.frnds_normal_btn);
            settingsbtn.setBackgroundResource(R.drawable.settings_normal_btn);
            profilebtn.setBackgroundResource(R.drawable.profile_normal_btn);
            feedbtn.setBackgroundResource(R.drawable.feed_click_btn);
            if (!AppStatus.getInstance(getApplicationContext()).isOnline(
                    getApplicationContext()))
            {
                Toast.makeText(getApplicationContext(),
                        "Please, Check Your internet connection.", 500).show();
            }
            else
            {
                Fetch_Feeds();
            }
        }
        else
        {
            profilelayout.setVisibility(View.GONE);
            settinglayout.setVisibility(View.GONE);
            feedlayout.setVisibility(View.GONE);
            friendlayout.setVisibility(View.VISIBLE);
            friendbtn.setBackgroundResource(R.drawable.frnds_click_btn);
            settingsbtn.setBackgroundResource(R.drawable.settings_normal_btn);
            profilebtn.setBackgroundResource(R.drawable.profile_normal_btn);
            feedbtn.setBackgroundResource(R.drawable.feed_normal_btn);
            if (!AppStatus.getInstance(getApplicationContext()).isOnline(getApplicationContext()))
            {
                Toast.makeText(getApplicationContext(), "Please, Check Your internet connection.", 500)
                        .show();
            }
            else
            {
                Fetch_Facebook_Friends();
            }
        }
        
       

        reg.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                friendsList.setAdapter(new FriendsAdapter());
                friendsList.setVisibility(0);
                nonreglist.setVisibility(8);
                nonreg.setBackgroundResource(R.drawable.send_blessings_normal);
                reg.setBackgroundResource(R.drawable.invite_frnds_click);

            }
        });
        nonreg.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                friendsList.setVisibility(8);
                nonreglist.setVisibility(0);
                friendsList.setAdapter(new FriendsAdapterRegistered());
                nonreg.setBackgroundResource(R.drawable.send_blessings_click);
                reg.setBackgroundResource(R.drawable.invite_frnds_normal);

            }
        });
        picker.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {

                timelay.setVisibility(0);

            }
        });
        set.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub

                Toast.makeText(getBaseContext(),
                        "Time Selected : " + timepicker.getCurrentHour() + ":"
                                + timepicker.getCurrentMinute(), Toast.LENGTH_SHORT).show();
                picker.setText(timepicker.getCurrentHour() + ":" + timepicker.getCurrentMinute());
                //
                Calendar c = Calendar.getInstance();
                System.out.println("Current time => " + c.getTime());

                SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                String formattedDate = df.format(c.getTime());
                notificationtime = formattedDate + " " + timepicker.getCurrentHour() + ":"
                        + timepicker.getCurrentMinute() + ":00";
                if (!AppStatus.getInstance(getApplicationContext()).isOnline(
                        getApplicationContext()))
                {
                    Toast.makeText(getApplicationContext(),
                            "Please, Check Your internet connection.", 500).show();
                }
                else
                {
                    BlessTime();
                }

                // timelay.setVisibility(8);
            }
        });

        pushnotice.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub

                if (!AppStatus.getInstance(getApplicationContext()).isOnline(
                        getApplicationContext()))
                {
                    Toast.makeText(getApplicationContext(),
                            "Please, Check Your internet connection.", 500).show();
                }
                else
                {
                    PushNotice();
                }
            }
        });
        profilebtn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                profilelayout.setVisibility(View.VISIBLE);
                settinglayout.setVisibility(View.GONE);
                feedlayout.setVisibility(View.GONE);
                friendlayout.setVisibility(View.GONE);
                friendbtn.setBackgroundResource(R.drawable.frnds_normal_btn);
                settingsbtn.setBackgroundResource(R.drawable.settings_normal_btn);
                profilebtn.setBackgroundResource(R.drawable.profile_click_btn);
                feedbtn.setBackgroundResource(R.drawable.feed_normal_btn);
               
                if (!AppStatus.getInstance(getApplicationContext()).isOnline(
                        getApplicationContext()))
                {
                    Toast.makeText(getApplicationContext(),
                            "Please, Check Your internet connection.", 500).show();
                }
                else
                {
                    GetProfile();
                }

            }
        });
        settingsbtn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                profilelayout.setVisibility(View.GONE);
                settinglayout.setVisibility(View.VISIBLE);
                feedlayout.setVisibility(View.GONE);
                friendlayout.setVisibility(View.GONE);
                friendbtn.setBackgroundResource(R.drawable.frnds_normal_btn);
                settingsbtn.setBackgroundResource(R.drawable.settings_click_btn);
                profilebtn.setBackgroundResource(R.drawable.profile_normal_btn);
                feedbtn.setBackgroundResource(R.drawable.feed_normal_btn);
                ImageOptions options;
                options = new ImageOptions();
                options.round = 100;
                options.fileCache = true;
                options.memCache = true;
                options.targetWidth = 100;
                options.fallback = R.drawable.ic_launcher;
                ImageOptions options2 = null;
                options2 = new ImageOptions();
                options2.fileCache = true;
                options2.memCache = true;
                options2.targetWidth = 100;
                options2.fallback = R.drawable.ic_launcher;
//                AQuery fbQuery = new AQuery(getApplicationContext());
//                fbQuery.id(profile_image).image(
//                        getPreference(getApplicationContext(), "user_image"), options);
//                imageLoader1.DisplayImage(getPreference(getApplicationContext(), "user_image"),HomePage.this,profile_image);
                AQuery aq = new AQuery(HomePage.this);
                aq.id(profile_image).image(
                        getPreference(getApplicationContext(), "user_image"), options);
                aq.id(R.id.profile_image_back).image(getPreference(getApplicationContext(), "user_image"), true, true, 0, 0, null, AQuery.FADE_IN_NETWORK, 1.0f);
               
             // imageLoader1.DisplayImage(getPreference(getApplicationContext(), "user_image"),HomePage.this,profile_image);
            }
        });
        feedbtn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                // TODO Auto-generated method stub
                profilelayout.setVisibility(View.GONE);
                settinglayout.setVisibility(View.GONE);
                feedlayout.setVisibility(View.VISIBLE);
                friendlayout.setVisibility(View.GONE);
                friendbtn.setBackgroundResource(R.drawable.frnds_normal_btn);
                settingsbtn.setBackgroundResource(R.drawable.settings_normal_btn);
                profilebtn.setBackgroundResource(R.drawable.profile_normal_btn);
                feedbtn.setBackgroundResource(R.drawable.feed_click_btn);
                if (!AppStatus.getInstance(getApplicationContext()).isOnline(
                        getApplicationContext()))
                {
                    Toast.makeText(getApplicationContext(),
                            "Please, Check Your internet connection.", 500).show();
                }
                else
                {
                    Fetch_Feeds();
                }
            }
        });
        friendbtn.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                //Data.fromnotification=false;
                // TODO Auto-generated method stub
                profilelayout.setVisibility(View.GONE);
                settinglayout.setVisibility(View.GONE);
                feedlayout.setVisibility(View.GONE);
                friendlayout.setVisibility(View.VISIBLE);
                friendbtn.setBackgroundResource(R.drawable.frnds_click_btn);
                settingsbtn.setBackgroundResource(R.drawable.settings_normal_btn);
                profilebtn.setBackgroundResource(R.drawable.profile_normal_btn);
                feedbtn.setBackgroundResource(R.drawable.feed_normal_btn);

                if (!AppStatus.getInstance(getApplicationContext()).isOnline(getApplicationContext()))
                {
                    Toast.makeText(getApplicationContext(), "Please, Check Your internet connection.", 500)
                            .show();
                }
                else
                {
                    Fetch_Facebook_Friends();
                }
            }
        });

    }

    public class FriendsAdapter extends BaseAdapter {

        private LayoutInflater inflater;
        ViewHolder holder;
        boolean flag = true;
        ImageOptions options;
        boolean check[] ;

        public FriendsAdapter() {
            options = new ImageOptions();
            options.round = 100;
            options.fileCache = true;
            options.memCache = true;
            options.targetWidth = 100;
            options.fallback = R.drawable.ic_launcher;
            inflater = (LayoutInflater) getApplicationContext().getSystemService(
                    Context.LAYOUT_INFLATER_SERVICE);
            check = new boolean[frand_fb_id.size()];
            for (int i = 0; i < frand_fb_id.size(); i++) {
                if (check[i] == true) {
                    check[i] = false;

                }
              
            }
            // if(!AppStatus.getInstance(FriendsAdapter.this).isOnline(FriendsAdapter.this))
            // flag = false;
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
            if (convertView == null) {

                convertView = inflater.inflate(R.layout.unregistered_list, null);

                holder = new ViewHolder();
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
                holder = (ViewHolder) convertView.getTag();
            }

            // String
            // url="https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-frc1/t31.0-8/905689_490227854365332_1106635553_o.jpg";
           // holder.blessimage.setBackgroundResource(R.drawable.blessup_btn_norma);
            holder.textView.setTypeface(face1);
            AQuery fbQuery = new AQuery(convertView);
            fbQuery.id(holder.pic).image(frand_image.get(position), options);

            holder.textView.setText(frand_name.get(position));

            // Picasso.with(getApplicationContext())
            //
            // .load(frand_image.get(position))
            //
            // .transform(new utils.CircleTransform()).fit()
            //
            // .into(holder.pic);

            holder.fl.setOnClickListener(new View.OnClickListener() {

                @Override
                public void onClick(View v) {
                    holder = (ViewHolder) v.getTag();
                    int pos = holder.x;
                    Data.pressed_user_id = frand_fb_id.get(position);
                    Data.blessed_user_name = frand_name.get(position);
                   
                    
                    if (check[position] == false) {
                        check[position] = true;
                        // requestids=requestids+","+fb_ids[position];
                        // Log.i("requestids111", requestids+"..");
                        if (!AppStatus.getInstance(getApplicationContext()).isOnline(
                                getApplicationContext()))
                        {
                            Toast.makeText(getApplicationContext(),
                                    "Please, Check Your internet connection.", 500).show();
                        }
                        else
                        {
                            Wallpost(frand_fb_id.get(position));
                        }

                       
                    } else {
                        check[position] = false;
                     
                       
                    }
                    notifyDataSetChanged();

                }
            });
            
            if (check[position] == true) {
                // check[position]=true;
                holder.blessimage.setBackgroundResource(R.drawable.check_select);
            } else {
                // check[position]=false;
                holder.blessimage
                        .setBackgroundResource(R.drawable.check_normal);
            }
            // holder.fl.setOnLongClickListener(new View.OnLongClickListener() {
            //
            // @Override
            // public boolean onLongClick(View v) {
            //
            // Data.pressed_user_id = frand_fb_id.get(position);
            // startActivity(new Intent(HomePage.this, FriendOfFriends.class));
            // // Toast.makeText(getApplicationContext(), "bbbbb",
            // // 500).show();
            // // TODO Auto-generated method stub
            // return false;
            //
            // }
            // });

            return convertView;

        }

    }

    public class ViewHolder {

        public ImageView blessimage;

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

//        
//             holder.fl.setOnLongClickListener(new View.OnLongClickListener() {
//            
//             @Override
//             public boolean onLongClick(View v) {
//            
//             Data.pressed_user_id = reg_frand_fb_id.get(position);
//             Data.profilemyself= reg_frand_image.get(position);
//             Data.pressed_fb_id=reg_frand_id.get(position);
//             startActivity(new Intent(HomePage.this, FriendOfFriends.class));
//             // Toast.makeText(getApplicationContext(), "bbbbb",
//             // 500).show();
//             // TODO Auto-generated method stub
//             return false;
//            
//             }
//             });
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
    public void Fetch_Facebook_Friends() {
        final ProgressDialog dialog = ProgressDialog.show(HomePage.this, "",
                getResources().getString(R.string.loading), true);

        Log.v("fbid", "fbid = " + Data.fbid);

        Log.v("fbaccesstoken", "fbaccesstoken = " + Data.fbaccesstoken);

        RequestParams params = new RequestParams();
        params.put("fbid", Data.fbid);

        params.put("fbaccesstoken", Data.fbaccesstoken);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath + "get_fb_friends",
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
                            frand_fb_id.clear();

                            reg_frand_image.clear();
                            reg_frand_name.clear();
                            reg_frand_fb_id.clear();
                            reg_frand_id.clear();
                            
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
                            // Log.i("...",frand_image+"..");
                           // adapter = new FriendsAdapter();
                            nonreglist.setAdapter(new FriendsAdapterRegistered());
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

    // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void Fetch_Feeds() {
        final ProgressDialog dialog = ProgressDialog.show(HomePage.this, "",
                getResources().getString(R.string.loading), true);
        Data.fbid=getPreference(getApplicationContext(),"fb_id");
        Data.fbaccesstoken=getPreference(getApplicationContext(),"fb_token");
        Data.app_access_token=getPreference(getApplicationContext(),"app_access_token");
        Log.v("fbid", "fbid = " + Data.fbid);

        Log.v("fbaccesstoken", "fbaccesstoken = " + Data.app_access_token);

        RequestParams params = new RequestParams();
        // params.put("fbid", Data.fbid);

        params.put("accesstoken", Data.app_access_token);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath + "view_feed",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                        Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            res = new JSONObject(response_str);

                            feed_name.clear();
                            feed_image.clear();
                            feedtime.clear();
                            feedtext.clear();

                            JSONArray val = res.getJSONArray("data");

                            if (val.length() != 0)
                            {
                                // for(int i=val.length()-1;i>=0;i--)
                                for (int i = 0; i < val.length(); i++)
                                {
                                    JSONObject c1 = val.getJSONObject(i);
                                    feed_name.add(c1.getString("user_name"));
                                    feed_image.add(c1.getString("user_image"));
                                    feedtime.add(c1.getString("timestamp"));
                                    feedtext.add(c1.getString("text"));

                                }
                                // Log.i("...",frand_image+"..");
                                feedadapter = new FeedAdapter();
                                feedlist.setAdapter(feedadapter);
                            }
                            else
                            {
                                Toast.makeText(getApplicationContext(), "You have no feeds", 500)
                                        .show();
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

    // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void GetProfile() {
        final ProgressDialog dialog = ProgressDialog.show(HomePage.this, "",
                getResources().getString(R.string.loading), true);

        Log.v("fbid", "fbid = " + Data.fbid);

        Log.v("fbaccesstoken", "fbaccesstoken = " + Data.app_access_token);

        RequestParams params = new RequestParams();
        // params.put("fbid", Data.fbid);

        params.put("accesstoken", Data.app_access_token);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath + "view_user_blessing_profile",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                        Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            JSONArray info = null, bless = null;
                            res = new JSONObject(response_str);
                            info = res.getJSONArray("data");
                            bless = info.getJSONObject(0).getJSONArray("bless");
                            profileimage = info.getJSONObject(0).getString("user_image");

                            c1.setText(bless.getJSONObject(0).getString("today"));
                            c2.setText(bless.getJSONObject(0).getString("month"));
                            c3.setText(bless.getJSONObject(0).getString("week"));
                            c4.setText(bless.getJSONObject(0).getString("year"));
                            flipMeter.setValue(Integer.parseInt(bless.getJSONObject(0).getString("total")), true);
                           // c4.setText(bless.getJSONObject(0).getString("year"));
                            //flipMeter.setValue(Integer.parseInt(bless.getJSONObject(0).getString("total")), true);
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

    public class FeedAdapter extends BaseAdapter {

        private LayoutInflater inflater;
        ViewHolder1 holder;
        boolean flag = true;
        ImageOptions options;

        public FeedAdapter() {
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

            return feedtext.size();
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

                convertView = inflater.inflate(R.layout.feedlistitem, null);

                holder = new ViewHolder1();
                holder.fl = (LinearLayout) convertView.findViewById(R.id.listlayout);
                holder.name = (TextView) convertView.findViewById(R.id.namefield);
                holder.text1 = (TextView) convertView.findViewById(R.id.feedtext1);
                holder.text2 = (TextView) convertView.findViewById(R.id.feedtext2);

                holder.image = (ImageView) convertView.findViewById(R.id.feedprofimage);

                // holder.fl.setLayoutParams(new ListView.LayoutParams(720,
                // 240));
                // ASSL.DoMagic(holder.fl);

                holder.image.setTag(holder);
                holder.name.setTag(holder);
                holder.text1.setTag(holder);
                holder.text2.setTag(holder);
                holder.fl.setTag(holder);

                convertView.setTag(holder);
            } else {
                holder = (ViewHolder1) convertView.getTag();
            }

            if (feed_image.get(position).length() != 0)
            {
                String url = "https://fbcdn-sphotos-b-a.akamaihd.net/hphotos-ak-frc1/t31.0-8/905689_490227854365332_1106635553_o.jpg";

                Picasso.with(getApplicationContext())

                        .load(feed_image.get(position))

                        .into(holder.image);
                // Picasso.with(getApplicationContext())
                //
                // .load(frand_image.get(position))
                //
                // .transform(new utils.CircleTransform()).fit()
                //
                // .into(holder.pic);
                // AQuery fbQuery = new AQuery(convertView);
                // fbQuery.id(holder.pic).image("http://graph.facebook.com/762089740508469/picture?width=160&height=160 ",
                // options);
                holder.image.setVisibility(0);
            }
            else
            {
                holder.image.setVisibility(8);
            }
            if (feed_name.get(position).length() != 0)
            {
                holder.name.setVisibility(0);
                holder.name.setText(feed_name.get(position));
            }
            else
            {
                holder.name.setVisibility(8);
            }
            if (feedtext.get(position).length() != 0)
            {
                holder.text1.setText(feedtext.get(position));
                holder.text1.setVisibility(0);
            }
            else
            {
                holder.text1.setVisibility(8);
            }
            if (feedtime.get(position).length() != 0)
            {
                holder.text1.setVisibility(0);
                holder.text2.setText(feedtime.get(position));
            }
            else
            {
                holder.text2.setVisibility(8);
            }

            holder.text1.setTypeface(face1);
            holder.text2.setTypeface(face1);
            holder.name.setTypeface(face1);

            return convertView;

        }

    }

    public class ViewHolder1 {

        TextView name, text1, text2;

        LinearLayout fl;

        ImageView image;
        int x;
    }

    // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void BlessFriend() {
        final ProgressDialog dialog = ProgressDialog.show(HomePage.this, "",
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

    // ********************Used for sinup through fb//********************
    /**
     * Register user on our server.
     */
    public void BlessTime() {
        final ProgressDialog dialog = ProgressDialog.show(HomePage.this, "",
                getResources().getString(R.string.loading), true);

        Log.v("fbid", "fbid = " + Data.fbid);

        Log.v("fbaccesstoken", "fbaccesstoken = " + Data.app_access_token);
        Log.v("notificationtime", "notificationtime = " + notificationtime);

        RequestParams params = new RequestParams();

        params.put("accesstoken", Data.app_access_token);
        params.put("timestamp", notificationtime);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath + "update_bless_view_time",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                        Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            res = new JSONObject(response_str);

                            if (res.getString("log").equals("Settings changed."))
                            {
                                Toast.makeText(getApplicationContext(), "Successfully changed", 500)
                                        .show();
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

    /**
     * Register user on our server.
     */
    public void PushNotice() {
        final ProgressDialog dialog = ProgressDialog.show(HomePage.this, "",
                getResources().getString(R.string.loading), true);

        Log.v("fbid", "fbid = " + Data.fbid);

        Log.v("fbaccesstoken", "fbaccesstoken = " + Data.app_access_token);
        Log.v("notificationtime", "notificationtime = " + notificationtime);

        RequestParams params = new RequestParams();

        params.put("accesstoken", Data.app_access_token);
        params.put("flag", pushflag);

        AsyncHttpClient client = new AsyncHttpClient();
        client.setTimeout(10000);
        client.post(Data.BasePath + "update_push_status",
                params, new AsyncHttpResponseHandler() {
                    private JSONObject res;

                    @Override
                    public void onSuccess(String response_str) {
                        Log.v("request succesfull", "response = " + response_str);
                        dialog.cancel();
                        try {
                            res = new JSONObject(response_str);
                            Log.v("request getString", res.getString("log") + "..");
                            String log;
                            try {
                                log = res.getString("log");
                            } catch (Exception e) {
                                // TODO Auto-generated catch block
                                e.printStackTrace();
                                log = "";
                            }

                            if (log.equals(" Push settings changed."))
                            {
                                String prevStatus = getPreference(getApplicationContext(), "status");
                                if (prevStatus.equals("") || prevStatus.equals("0"))
                                {
                                    setPreference(getApplicationContext(), "1", "status");
                                    pushnotice.setBackgroundResource(R.drawable.on_btn);

                                }
                                else
                                {
                                    setPreference(getApplicationContext(), "0", "status");
                                    pushnotice.setBackgroundResource(R.drawable.off_btn);
                                }
                            }
                            else
                            {
                                // String error = res.getString("error");
                                // if(error.equals("User already blessed."))
                                {
                                    Toast.makeText(getApplicationContext(), "Some Error Occured",
                                            500).show();
                                }
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

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub

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
    
    public void Wallpost(String ids) {

        // TODO Auto-generated method stub

        Session session = Session.getActiveSession();

        if (session == null) {

            session = new Session(HomePage.this);

            // Check if there is an existing token to be migrated
//            SharedPreferences pref = getSharedPreferences("MyPref", 0);
//
//            String fb_access_token = pref
//                    .getString("facebook_access_token", "");

            AccessToken accessToken = AccessToken

            .createFromExistingAccessToken(

            Data.fbaccesstoken, null, null,

            null, null);

            // statusCallback: Session.StatusCallback implementation

            session.open(accessToken, scb);

            Session.setActiveSession(session);

        } else {

            Log.v("hello in else ", "hello in else");

        }

        // ************************************

        Bundle params = new Bundle();

        params.putString("to", ids);

        params.putString("message", "Check out this great app!");

        showDialogWithoutNotificationBar("apprequests", params);

    }

    private void showDialogWithoutNotificationBar(String action, Bundle params) {

        WebDialog webdialog = new WebDialog.Builder(HomePage.this,

        Session.getActiveSession(), action, params)

        .setOnCompleteListener(new WebDialog.OnCompleteListener() {

            @Override
            public void onComplete(Bundle values, FacebookException error) {

                if (values == null) {

                   

                } else {

                    try {

                        Log.e("bundle===", "" + values);
                        Toast.makeText(getApplicationContext(),

                                "Request Sent", 200).show();

                    } catch (Exception e1) {

                        // TODO Auto-generated catch block

                        e1.printStackTrace();

                    }

                    if (error != null

                    && !(error instanceof FacebookOperationCanceledException)) {

                        Toast.makeText(getApplicationContext(),

                        "Network Error!", 200).show();

                    } else {

                      

                    }

                }

            }

        }).build();
        webdialog.show();

    }
}
