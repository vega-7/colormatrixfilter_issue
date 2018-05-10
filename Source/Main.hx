package;


import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;


import openfl.utils.Assets;

class Main extends Sprite {
	
	var w:Float = 0;
	var h:Float = 0;
	var h_half:Float = 0;
	
	var y_max:Float = 0;
	
	public var bg:Bitmap;
	
	public var hasFilter:Bool = false;
	
	
		public static var colorMatrixFilter:Array<Float> = [0.212671,0.715160, 0.072169, 0, 0,
								0.212671, 0.715160, 0.072169, 0, 0,
								0.212671, 0.715160, 0.072169, 0, 0,
								0, 0, 0, 1, 0];
		/*@:final public static function desaturate(obj:DisplayObject)
		{
		
	
			if (obj.filters.length>0)
				obj.filters.push(new ColorMatrixFilter(colorMatrixFilter));
			else
				obj.filters= [new ColorMatrixFilter(colorMatrixFilter)];
		}*/
	
	public var obj_moving:Map<String,Bitmap> = [
		"astronauta.png"=>new Bitmap(),
		"astronauta2.png"=>new Bitmap(),
		"bombillo01.png"=>new Bitmap(),
		"isla-escritorio.png"=>new Bitmap()
	];
	
	public function new () {
		
		super ();
		
		w = Lib.application.window.width ;
		h = Lib.application.window.height;
		h_half = h * .5;
		
		//- - - - - 
		
		
		addBgAndSclToWindows();
		
		addMovingObj();
		
		
		this.addEventListener(MouseEvent.MOUSE_UP, onMousePress);
		
		
	}
	
	private function onMousePress(e:MouseEvent):Void 
	{
		var colorMatrixFilter_ :Array<BitmapFilter>=  (!hasFilter)?[new ColorMatrixFilter(colorMatrixFilter)]:[];
		
		bg.filters = colorMatrixFilter_;
		
		for (i in obj_moving) 
			i.filters = colorMatrixFilter_;
		
			
		hasFilter = !hasFilter;
	}
	
	

	
	public function addBgAndSclToWindows():Void
	{
		bg = new Bitmap(Assets.getBitmapData("assets/bg.jpg"));
		bg.smoothing = true;
		
		var scl:Float = w / bg.bitmapData.width;
		
		bg.width = bg.bitmapData.width * scl;
		bg.height = bg.bitmapData.height * scl;
		
		y_max =-bg.height + h;
		
		this.addChild(bg);
		
		this.addEventListener(Event.ENTER_FRAME, moveBgAndObjs); //move the 
	}
	
	public function addMovingObj():Void 
	{	
		var j:Int = 0;
		var y_last:Float = 0;
		
		for (i in obj_moving.keys()) 
		{
			//trace("assets/"+ Assets.getBitmapData(i));
			var obj = new Bitmap( Assets.getBitmapData("assets/" + i));
			
			obj.name =i ;
			obj.x = Math.random() * w;
			obj.y = y_last;
			
			obj_moving[i] = obj;
		
			y_last = obj.y + obj.height;
			
			this.addChild(obj);
		}
	}
	
	private function moveBgAndObjs(e:Event):Void 
	{
		//trace(mouseY,h_half);
		if (mouseY > h_half )
		{	
			bg.y -= 10;
		}
		else
		{
			bg.y += 10;
		}
		
		
		for (i in obj_moving) 
		{
			
			i.x += 2;
			//if (i.x < 0) i.x = h;
			//else 
			if (i.x > w) i.x = -i.width;
		}
		
		if (bg.y > 0) bg.y = 0;
		else if (bg.y <y_max) bg.y =y_max;
	}
	
	
}