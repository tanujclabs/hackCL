using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Linq.Mapping;
using System.Data.Linq;
using System.Web.Configuration;
/// <summary>
/// Summary description for acnt
/// </summary>
/// 

[Table]
public partial class acnt
{
    [Column(IsPrimaryKey = true, IsDbGenerated = true)]
    public int id { get; set; }
    [Column]
    public string fbid { get; set; }
    [Column]
    public string atoken { get; set; }
    [Column]
    public string username { get; set; }
    [Column]
    public string proimage { get; set; }
    [Column]
    public string coverimage { get; set; }
    [Column]
    public string emailid { get; set; }
    [Column]
    public string actype { get; set; }
   
}

public partial class acnt
{
    static string conString = WebConfigurationManager.ConnectionStrings["dicoor"].ConnectionString;
    public static acnt inserts(acnt st)
    {
        DataContext db = new DataContext(conString);
        db.GetTable<acnt>().InsertOnSubmit(st);
        db.SubmitChanges();

        return st;
    }
    public static acnt Update(acnt newMovie)
    {
        DataContext db = new DataContext(conString);
        acnt movieToDeletes = db.GetTable<acnt>().Single(m => m.id == newMovie.id);
        if(newMovie.fbid!=null)
        movieToDeletes.fbid = newMovie.fbid;

        movieToDeletes.atoken = newMovie.atoken;
        movieToDeletes.username = newMovie.username;
        movieToDeletes.proimage = newMovie.proimage;
        movieToDeletes.coverimage = newMovie.coverimage;
        movieToDeletes.emailid = newMovie.emailid;
        movieToDeletes.actype = newMovie.actype;
        db.SubmitChanges();
        return movieToDeletes;
    }
}