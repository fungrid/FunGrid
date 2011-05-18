﻿package no.agens.fungrid{	import flash.geom.Rectangle;	import flash.geom.Point;	import flash.display.Sprite;	/*	Copyright (c) 2011, Agens AS <post@agens.no> http://agens.no		Permission to use, copy, modify, and/or distribute this software for any	purpose with or without fee is hereby granted, provided that the above	copyright notice and this permission notice appear in all copies.		THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.	*/	/**	 * <h1>RectangleZoneGameObject</h1>	 * <p>GameObject on the FunGrid containing a Rectangle for checking for intersections or if a point is inside or outside of the zone.</p>	 * 	 * Usage: Create and place it on the FunGrid!	 * 	 * @author Peter Måseide, Agens AS	 * @date 28. mar. 2011	 */	public class RectangleZoneGameObject extends ZoneGameObject {		public var rectangle:Rectangle;		/**		 * Constructor 		 * @param id A string you can use to identify the RZGO		 * @param sprite The visual part of the RZGO. Is added to baseSprite on FunGrid when RZGO is added to the FunGrid		 * @param pos Positon for the RZGO on the FunGrid		 * @param rectangle The Rectangle defining the zone		 * @param scrollFactor How the RZGO follows GameGrid.baseSprite when scrolling. (Default: x:1 y:1 - Use values below 1 to scroll backgrounds slower, and values above 1 to scroll things in the foreground faster.)		 * @param moveable True if this RZGO is supposed to move on the GameGrid with speed/acceleration		 * @param repeatSettings Repeat settings		 * @param speed x and y speed of the GO on the GameGrid. Measured in pixels pr update (frame)		 * @param acc x and y acceleration of the GO on the GameGrid. Measures change in speed in pixels pr update (frame).		 * 		 */		public function RectangleZoneGameObject(id:String,sprite:Sprite,pos:Point,rectangle:Rectangle, scrollFactor:Point=null, moveable:Boolean = true, repeatSettings:GameObjectRepeatSettings=null, speed:Point=null, acc:Point=null) {			super(id,sprite,pos,new PolyLine(new Point(rectangle.x, rectangle.y), new Point(rectangle.x+rectangle.width,rectangle.y), new Point(rectangle.x+rectangle.width,rectangle.y+rectangle.height), new Point(rectangle.x,rectangle.y+rectangle.height)),scrollFactor, moveable, repeatSettings, speed, acc);			this.rectangle = rectangle;		}		/**		 * True if rectangle intersects another Rectangle		 * @param rect Rectangle for checking		 * @param type May be used for collision checking. The RZGO may take spesific action at spesific types.		 * @return 		 * 		 */		public function rectIntersects(rect:Rectangle, type:String):Boolean {			if (!zoneEnabled) {				return false;			}			var r:Rectangle = rectangle.clone();			r.x += pos.x;			r.y += pos.y;			if (r.intersects(rect)) {				customIfRectIntersects(type);				return true;			}			return false;		}		/** Your own custom actions if rectangle intersects rect */		protected function customIfRectIntersects(type:String=""):void {		}	}	}