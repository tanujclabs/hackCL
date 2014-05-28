using UnityEngine;
using System.Collections;
using System.Net;
using System.Net.Sockets;
using System.Net.NetworkInformation;
using System.IO;

public class ConnectivityTest : MonoBehaviour {

	private WebClient _CLIENT;
	private Stream _SR;	
	public string TESTURL;
	
	public string _IP;
	public int _port;
	
	public bool CheckConnectionViaStream()
	{
		try
		{
			_CLIENT = new WebClient();
			_SR = _CLIENT.OpenRead( TESTURL );
			Debug.Log( "Connection Working" );
			return true;
		}
		
		catch ( System.Exception e )
		{
			Debug.Log( e.Message );
			Debug.Log( "No response from server" );
			return false;
		}
		
	}
	
	public bool CheckConnectionViaTCPSocket()
	{
		Debug.Log( _IP );
		Socket _S = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		try
		{
			_S.Connect( _IP, _port );
			Debug.Log( "Success" );
			return true;
		}
			
		catch ( System.Exception e )
		{
			Debug.Log( e.Message );
			Debug.Log( "Exception Encountered" );
			return false;
		}
	}
	
	
	// NOt working now
	public bool CheckConnectionViaPing()
	{
		Debug.Log( _IP );
		System.Net.NetworkInformation.Ping _X = new System.Net.NetworkInformation.Ping();
		PingReply _REPLY = _X.Send( _IP );
		if( _REPLY.Status == IPStatus.Success )
		{
			Debug.Log( "Ping Success" );
			return true;
		}
		
		else
		{
			Debug.Log( "Ping Faliure. Address isn't accessible" );
			return false;
		}
	}
	
	public bool CheckConnectionViaTCPClientSocket()
	{
		Debug.Log( _IP );
		System.Net.Sockets.TcpClient client = new TcpClient();
		try
		{
		    client.Connect( System.Net.IPAddress.Parse( _IP ), _port );
		    Debug.Log("Connection open, host active");
			return true;
		} 
		catch (SocketException ex)
		{
		    Debug.Log("Connection could not be established due to: \n" + ex.Message);
			return false;
		}
		finally
		{
		    client.Close();
		}
	}
	
	/*public bool CheckConnectionViaSSL()
	{
		bool _SSL, _SUCCESS;
		_SSL = false;
		int maxWaitMillisec;
		maxWaitMillisec = 20000;
		Socket _socket = new Socket( AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp );
		
		_SUCCESS = _socket.Connect(_IP,_port,_SSL,maxWaitMillisec);
		
		
		if (_SUCCESS != true) {
		
		   Debug.Log(_socket.LastErrorText);
		    return false;
		}
		else
			return true;
	}*/
}
	

	
	
