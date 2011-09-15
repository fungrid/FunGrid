﻿package no.agens.fungrid {	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.geom.Point;	import flash.geom.Rectangle;	/*	Copyright (c) 2011, Agens AS <post@agens.no> http://agens.no		Permission to use, copy, modify, and/or distribute this software for any	purpose with or without fee is hereby granted, provided that the above	copyright notice and this permission notice appear in all copies.		THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.	*/	/**	 * <h1>HardCoreGameObject</h1>	 * <p>The grandmother of all GameObjects! Only essential functionality.</p>	 * 	 * Usgae: Create HardCoreGameObjects and add them to the FunGrid!	 * You may use HardCoreGameObject if you don't need the functionality of the CoreGameObject.	 * 	 * @author Peter Måseide, Agens AS	 * @date 4. may. 2011	 */	public class HardCoreGameObject {		/** A string you can use to identify the GO */		public var id:String;		/** Reference to the FunGrid the GO is added on */		public var fg:FunGrid;		/** The visual part of the GameObject. Is added to baseSprite on FunGrid when GO is added to the FunGrid */		public var displayObject:DisplayObject;		/** Positon for the GO on the FunGrid*/		public var pos:Point;		/** How the GO follows GameGrid.baseSprite when scrolling. (Default: x:1 y:1 - Use values below 1 to scroll backgrounds slower, and values above 1 to scroll things in the foreground faster.) */		public var scrollFactor:Point;		/** BoundingRectangle for the visible part of the Sprite*/		public var boundRect:Rectangle;		/** Reference to the baseSprite on the FunGrid */		public var baseSprite:Sprite;		/** True if we want to render the DisplayObject even if it's outside the FunGrid viewport. neverHide overrides hide */		public var neverHide:Boolean = false;		/** True if we don't want to render the DisplayObject even if it's inside the viewport. */		public var hide:Boolean = false;		/** True if the GO is supposed to be removed from the GameGrid */		public var destroyMe:Boolean = false;		/** Interval defining min and max for displayObject.x */		public var viewportPositionIntervalX:Interval;		/** Interval defining min and max for displayObject.y */		public var viewportPositionIntervalY:Interval;				/**		 * Constructor 		 * @param id A string you can use to identify the GO		 * @param displayObject The visual part of the GameObject. Is added to baseSprite on FunGrid when GO is added to the FunGrid		 * @param initPos Positon for the GO on the FunGrid		 * @param scrollFactor How the GO follows GameGrid.baseSprite when scrolling. (Default: x:1 y:1 - Use values below 1 to scroll backgrounds slower, and values above 1 to scroll things in the foreground faster.)		 * 		 */				public function HardCoreGameObject(id:String,displayObject:DisplayObject,initPos:Point,scrollFactor:Point=null) {			this.id = id;			this.displayObject = displayObject;			if (displayObject) {				displayObject.x = -displayObject.width*2;				displayObject.y = -displayObject.height*2;				boundRect = displayObject.getBounds(displayObject);			}			if (scrollFactor == null) {				this.scrollFactor = new Point(1,1);			} else {				this.scrollFactor = scrollFactor;			}			pos = new Point(initPos.x/this.scrollFactor.x,initPos.y/this.scrollFactor.y);		}				/** Updates the position on the grid and the displayObjects position in the viewport, and then render... */		public function update():Boolean {			if (destroyMe) {				return false;			}			customEarlyUpdate();			updateRenderPositon();			render();						return true;		}		/** Custom update before anything else is updated */		protected function customEarlyUpdate():void {		}		/** Shows the displayObject if the displayObject is inside the viewport */		protected function render():void {			if (displayObject) {				if (neverHide) {					customRender();					displayObject.visible = true;				} else if (hide) {					displayObject.visible = false;				} else if (inViewport() && !destroyMe) {					customRender();					displayObject.visible = true;				} else {					displayObject.visible = false;				}			}		}		/** Custom render */		protected function customRender():void {		}		/**		 * Used by the FunGrid when adding the GO.		 * @param fg FunGrid		 * @param baseSprite FunGrid baseSprite		 * 		 */				public function setFunGrid(fg:FunGrid,baseSprite:Sprite):void {			this.fg = fg;			this.baseSprite = baseSprite;		}		/** Updates the position of the displayObject relative to the viewport */		public function updateRenderPositon():void {			if (displayObject) {				if (scrollFactor.x != 0) {					displayObject.x=scrollFactor.x*(pos.x-fg.viewport.x);				} else {					displayObject.x = pos.x;				}				if (viewportPositionIntervalX) {					displayObject.x = viewportPositionIntervalX.forceIntoInterval(displayObject.x);				}				if (scrollFactor.y != 0) {					displayObject.y=scrollFactor.y*(pos.y-fg.viewport.y);				} else {					displayObject.y = pos.y;				}				if (viewportPositionIntervalY) {					displayObject.y = viewportPositionIntervalY.forceIntoInterval(displayObject.y);				}			}		}		/** If displayObject is inside the viewport */		public function inViewport():Boolean {			return boundRect.x+displayObject.x<=fg.viewport.width/fg.parentSprite.scaleX&&boundRect.right+displayObject.x>=0&&boundRect.top+displayObject.y<=fg.viewport.height/fg.parentSprite.scaleY&&boundRect.bottom+displayObject.y>=0;		}		/** Make it possible for FunGrid to remove this GameObject */		public function pleaseDestroy():void {			destroyMe = true;			displayObject.visible = false;		}		/** Used by the FunGrid when destroying the GO. */		public function destroy():void {			customDestroy();			if (baseSprite) {				baseSprite.removeChild(displayObject);			}			displayObject=null;		}		/** Custom destroy actions */		protected function customDestroy():void {		}	}}