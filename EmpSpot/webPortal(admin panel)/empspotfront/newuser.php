<html>
    <head>



        <link rel="stylesheet" type="text/css" href="css/bootstrap.css">

        <script type="text/javascript" language="javascript" src="js/jquery.js"></script>
        <script type="text/javascript" language="javascript" src="js/bootstrap.js"></script>


        <style>

            @font-face
            {
                font-family:track;
                src: url(font/Track.ttf);
            }


            body{
                background-color:#EEEFF5;
            }
            .form-inline .form-control {


                width:750px;
                height:43px;
                margin-bottom: 10px;

            }
            #new_user_form{
                width: 750px;
                margin: 0 auto;

            }
            .menu_tab{
                float:left;
                background:#fff;
                width: 200px;
                height: 40px;
            }
            .menu_tab a{
                font-family:track;
                font-size:22px;
            }

            .glyphicon-user:before {

                font-size: 98px;
            }
            .panel{
                width: 250px;
                height: 75px;
                border:0px;
            }
            .symbol{
                height: 75px;
                width: 75px;
                text-align: center;
                padding-top: 16px;
                font-size: 36px;
                background:#49BDF0;
            }
            .value{

                font-family: track;
                font-size: 18px;
                color: #49BDF0;
                padding-top: 26px;
                padding-left: 20px;

            }

        </style>

        <script>
            $('document').ready(function() {
                var iSize = 0;
                $("#upload_pic").change(function()
                {
                    iSize = ($("#upload_pic")[0].files[0].size / 1024);
                    if (iSize / 1024 > 1)
                    {
                        if (((iSize / 1024) / 1024) > 1)
                        {
                            iSize = (Math.round(((iSize / 1024) / 1024) * 100) / 100);
                            //            $("#lblSize").html( iSize + "Gb"); 
                        }
                        else
                        {
                            iSize = (Math.round((iSize / 1024) * 100) / 100)
                            //            $("#lblSize").html( iSize + "Mb"); 
                        }
                    }
                    else
                    {
                        iSize = (Math.round(iSize * 100) / 100)
                        //        $("#lblSize").html( iSize  + "kb"); 
                    }
                    alert(iSize);
                });

                $('#add_new').click(function() {


                    var Username = $('#Username').val();
                    var email = $('#email').val();
                    var phone = $('#phone').val();

                    //Code Starts






                    if (Username.length == 0 && email.length == 0 && phone.length == 0 && iSize == 0) {
                        alert("Fill all the marked fields.");
                    }
                    else if (Username.length == 0) {
                        alert("Enter username");
                    }
                    else if (email.length == 0) {
                        alert("Enter email address");
                    }
                    else if (phone.length == 0) {
                        alert("Enter phone number");
                    }
                    else if (iSize == 0) {
                        alert("Upload a picture.");
                    }
                    else {
                        var formData = new FormData(document.forms.namedItem("imagform"));
                        formData.append("user_name", Username);
                        formData.append("email_id", email);
                        formData.append("phone", phone);
                        formData.append("pic", 1);




                        $.ajax({
                            type: "Post",
                            url: "http://67.202.34.113:2000/add_new_user",
                            dataType: "JSON",
                            async: false,
                            data: formData,
                            processData: false,
                            contentType: false,
//                            processData: false,
                            success: function(data) {
                                console.log(data);

                            },
                            error: function(error) {
                                alert("hellllllllo");
                            }

                        });

                    }
                });
            });

        </script>
    </head>
    <body>

        <div style="margin-top:6%;">
            <div style="float:left">
                <div>
                    <a href="#">
                        <section class="panel">
                            <div class="symbol terques" style="float:left">
                                <span class="glyphicon glyphicon-plus"></span>
                            </div>
                            <div class="value" style="float:left">
                                New Entry
                            </div>
                            <div style="clear:both"></div>
                        </section>
                    </a>
                </div>

                <div>
                    <a href="http://67.202.34.113/nodeTraining/empspotfront/today.html">
                        <section class="panel">
                            <div class="symbol terques" style="float:left">
                                <span class="glyphicon glyphicon-time"></span>
                            </div>
                            <div class="value" style="float:left">
                                Today
                            </div>
                            <div style="clear:both"></div>
                        </section>
                    </a>
                </div>
                <div>
                    <a href="http://67.202.34.113/nodeTraining/empspotfront/approval.html">
                        <section class="panel">
                            <div class="symbol terques" style="float:left">
                                <span class="glyphicon glyphicon-th"></span>
                            </div>
                            <div class="value" style="float:left">
                                Approve
                            </div>
                            <div style="clear:both"></div>
                        </section>
                </div>
                </a>
                <div style="clear:both"></div>
            </div>



            <div class="form-inline" id="new_user_form">
                <div class="form-group">
                    <label class="sr-only" for="Username">   </label>
                    <input type="text" class="form-control" id="Username" placeholder="Username">
                </div>
                <br />
                <div class="form-group">
                    <label class="sr-only" for="email"></label>
                    <input type="text" class="form-control" id="email" placeholder="Email Address">
                </div>
                <br />
                <div class="form-group">
                    <label class="sr-only" for="phone"></label>
                    <input type="text" class="form-control" id="phone" placeholder="Phone No.">
                </div>
                <br />

                <div class="form-group">
                    <form name="imagform" id="imagform" enctype="multipart/form-data">
                        <input type="file" name="image" accept="image/*" id="upload_pic">
                    </form>
                </div>
                <br />
                <div class="form-group">

                    <input type="button" class="btn btn-default" value="Add" id="add_new" style="width: 350px;margin-top:20px;background:#49BDF0;border-radius:4px;border:0px;color:#fff;height: 52px;font-family: track;letter-spacing: 1px;font-size: 26px;padding-top: 12px;">

                </div>
            </div>
        </div>

    </body>
</html>