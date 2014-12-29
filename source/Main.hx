package;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import flixel.FlxGame;
import flixel.FlxState;

class ServerApiImpl extends haxe.remoting.AsyncProxy<ServerApi> {
}

class Main extends Sprite implements ClientApi {
	
	var host : String = "localhost";
	var port : Int = 1024;
	var api : ServerApiImpl;
	
	var gameWidth:Int = 320; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 240; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = MenuState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	
	// You can pretty much ignore everything from here on - your code should go in your states.
	
	public static function main():Void {	
		Lib.current.addChild(new Main());
	}
	
	public function new() {
		super();
		
		if (stage != null) {
			init();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}
	
	private function init(?E:Event):Void {
		if (hasEventListener(Event.ADDED_TO_STAGE)) {
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		setupNet();
	}
	
	private function setupNet():Void {
		//Setup the client socket to recieve and send info over
		#if flash9
			var s = new flash.net.XMLSocket();
			s.addEventListener(flash.events.Event.CONNECT, onConnect);
			s.addEventListener(flash.events.IOErrorEvent.IO_ERROR, onFailed);
			s.connect(host, port);
		#elseif sys
			var s = new sys.net.Socket();
			var connected:Bool = false;
			try {
				s.connect(new sys.net.Host(host), port);
				connected = true;
			}
			catch (e : Dynamic) {
				onFailed();
			}
		#end
			
		//Create remoting object used to communicate
		var context = new haxe.remoting.Context();
		context.addObject("client",this);
		var scnx = haxe.remoting.SocketConnection.create(s, context);
		api = new ServerApiImpl(scnx.api);
		
		#if sys
		if (connected) {
			onConnect();
		}
		#end
	}
	
	function onConnect(event:flash.events.Event=null):Void{
		setupGame();
	}
	
	function onFailed(event:flash.events.Event=null):Void{
		trace("Failed to connect");
	}
	
	private function setupGame():Void {
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1) {
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
	}
		
	public function userJoin( name : String ) : Void {
		
	}
	
	public function userLeave( name : String ) : Void {
		
	}
}