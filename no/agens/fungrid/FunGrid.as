﻿package no.agens.fungrid{	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Sprite;	import flash.geom.Point;	import flash.geom.Rectangle;	/*	Copyright (c) 2011, Agens AS <post@agens.no> http://agens.no		Permission to use, copy, modify, and/or distribute this software for any	purpose with or without fee is hereby granted, provided that the above	copyright notice and this permission notice appear in all copies.		THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.	*/	/**	 * <h1>FunGrid V1.5</h1>	 * <p>Lightweight 2D scrolling game API.</p>	 * <p>	 * 1. Create an instance of FunGrid <br/>	 * 2. Add gameObjects with addGameObject()<br/>	 * 3. Call update() to update movement, usually on ENTER_FRAME.<br/>	 * 4. Use setFutureViewport() to scroll to a new position, or moveViewport() for imidiate movement.	 * </p>	 * <p>Developed by Agens AS - For the latest version and more info check http://agens.no/fungrid/</p>	 *	 * @author Peter Måseide, Agens AS	 * @date 26. aug 2011	 */	public class FunGrid {		public var gameObjects:Vector.<HardCoreGameObject > ;		private var polyLineGameObjects:Vector.<PolyLineGameObject > ;		private var zoneGameObjects:Vector.<ZoneGameObject > ;		private var lastAdded:HardCoreGameObject;		/** The Sprite where the scrolling of the gameObjects take place*/		private var baseSprite:Sprite;		/** Sprite to contain baseSprite or bitmapRenderCanvas */		public var parentSprite:Sprite;		/** Current origo and width/height of the visible area of the grid */		public var viewport:Rectangle;		/** Desired position (x,y) of the viewport some time in the future ("where we are scrolling") */		private var futureViewport:Point;		/** Border rectangle for scrolling. Viewport will not move outside this rectangle. Optional. If you want borders only on one of the axis, set the width or height to 0 for the axis without borders. */		public var borderRectangle:Rectangle;		/** Share of the distance between current an future position of the viewport to be moved for each update */		public var distanceFactor:Number = 0.3;		/** Max scroll distance for each update */		public var maxScrollSpeed:Number = 200;		/** If the gameObjects are supposed to be rendered on the bitmapRenderCanvas instead of baseSprite. Default: false  */		private var bitmapRender:Boolean;		/** The Bitmap where the gameObjects are rendered if bitmapRender == true */		private var bitmapRenderCanvas:Bitmap;		/** How many times the update() method has been called */		public var updateCounter:uint = 0;		/** Delete settings - true/false switches two different models for destroying objects. */		public var deleteMaxOneObjectEachFrame:Boolean = false;		/** BitmapData where BlitGameObjects are rendered */		public var blittingCanvas:BitmapData;		/** Reference to the Bitmap containing blittingBitmap */		public var blittingBitmap:Bitmap;				/**		 * Constructor 		 * @param parentSprite Where baseSprite or bitmapRenderCanvas is added		 * @param viewport Defines origo and width/height of the visible area of the grid 		 * @param bitmapRender If the gameObjects are supposed to be rendered on the bitmapRenderCanvas instead of baseSprite. Default: false		 * @return 		 * 		 */		public function FunGrid(parentSprite:Sprite, viewport:Rectangle, bitmapRender:Boolean = false) {			this.parentSprite = parentSprite;			this.viewport = viewport;			this.bitmapRender = bitmapRender;			futureViewport = new Point();			baseSprite = new Sprite();			if (bitmapRender) {				var bmd:BitmapData = new BitmapData(viewport.width,viewport.height,false);				bitmapRenderCanvas = new Bitmap(bmd);				parentSprite.addChild(bitmapRenderCanvas);			} else {				parentSprite.addChild(baseSprite);			}			gameObjects = new Vector.<HardCoreGameObject>();			zoneGameObjects = new Vector.<ZoneGameObject>();			polyLineGameObjects = new Vector.<PolyLineGameObject>();			setFutureViewport(viewport.left,viewport.top);		}		/**		 * Updates the viewport and all gameObjects.		 * Call the function as often as you want to want to update movement, usually on enterFrame. 		 * 		 */		public function update():void {			updateCounter +=1;			updateViewport();			if (blittingCanvas) {				blittingCanvas.fillRect(blittingCanvas.rect,0);				blittingCanvas.unlock();			}			updateGameObjects();			if (blittingCanvas) {				blittingCanvas.lock();			}			if (bitmapRender) {				renderBitmap();			}		}		/**		 * Renders the gameObjects on baseSprite onto bitmapRenderCanvas		 */		private function renderBitmap():void {			bitmapRenderCanvas.bitmapData.unlock();			bitmapRenderCanvas.bitmapData.draw(baseSprite);			bitmapRenderCanvas.bitmapData.lock();		}		/**		 *  Check if a point is inside any zoneGameObjects.		 * 		 * @param p Point that we want to check if it's inside any zoneGameObjects		 * @param type May be used for collision checking. The ZGO may take spesific actios for spesific types.		 * @param returnsIdInsteadOfType Return id String instead of type String for the ZGOs containing the point.		 * @param typeZGO If set, it only check for ZGOs with matching type property		 * @return Returns a Vector of strings describing the types (or id) of zoneGameObjects containing the point.		 * 		 */		public function zonesContainsPoint(p:Point, type:String="", returnIdInsteadOfType:Boolean = false, typeZGO:String=""):Vector.<String >  {			var r:Vector.<String >  = new Vector.<String >();			var l:int = zoneGameObjects.length;			for (var i:int = 0; i<l; i++) {				if (typeZGO == "" || typeZGO == zoneGameObjects[i].type) {					if (zoneGameObjects[i].containsPoint(p,type)) {						if (returnIdInsteadOfType) {							r.push(zoneGameObjects[i].id);						} else {							r.push(zoneGameObjects[i].type);						}					}				}			}			return r;		}		/**		 *  Check if a rectangle intersects any RectangleZoneGameObjects.		 * 		 * @param rect Rectangle that we want to check if it's intersecting any RectangleZoneGameObjects		 * @param type May be used for collision checking. The RZGO may take spesific actios for spesific types.		 * @param returnsIdInsteadOfType Return id String instead of type String for the RZGOs containing the point.		 * @param typeRZGO If set, it only check for RZGOs with matching type property		 * @return Returns a Vector of strings describing the types (or id) of zoneGameObjects containing the point.		 * 		 */		public function rectZonesIntersectsRectangle(rect:Rectangle, type:String="", returnIdInsteadOfType:Boolean = false, typeRZGO:String=""):Vector.<String >  {			var r:Vector.<String >  = new Vector.<String >();			var l:int = zoneGameObjects.length;			for (var i:int = 0; i<l; i++) {				if (zoneGameObjects[i] is RectangleZoneGameObject) {					if (typeRZGO == "" || typeRZGO == zoneGameObjects[i].type) {						if (RectangleZoneGameObject(zoneGameObjects[i]).rectIntersects(rect,type)) {							if (returnIdInsteadOfType) {								r.push(zoneGameObjects[i].id);							} else {								r.push(zoneGameObjects[i].type);							}						}					}				}			}			return r;		}		/**		 * Check if a movement from one Point to another collides with any polyLineGameObjects.		 * 		 * @param from Movement start on this Point		 * @param to Movement try to end on this Point		 * @param checkOutsideViewport If we are going to check collisions outside of the viewport (more CPU intensive).		 * @return Returns a PolyLineCollision object. If the movement does several collison, the collison to the from Point is returned.		 * 		 */		public function polyLineCollision(from:Point, to:Point, checkOutsideViewport:Boolean = false):PolyLineCollision {			var closestCollision:PolyLineCollision;			var l:int = polyLineGameObjects.length;			var col:PolyLineCollision;			for (var i:int = 0; i<l; i++) {				col = polyLineGameObjects[i].collision(from,to,checkOutsideViewport);				if (col) {					if (closestCollision) {						if (Point.distance(col.point,from) < Point.distance(closestCollision.point,from)) {							closestCollision = col;						}					} else {						closestCollision = col;					}				}			}			return closestCollision;		}		/**		* Adds a blitting canvas to the baseSprite		* Only one can be added.		*/		public function addBlittingCanvas():BitmapData {			blittingCanvas = new BitmapData(viewport.width, viewport.height);			blittingBitmap = new Bitmap(blittingCanvas);			baseSprite.addChild(blittingBitmap);			return blittingCanvas;		}		/**		 * Adds a GameObject to the FunGrid.		 * @param go GameObject to be added		 * @param alternativeBaseSprite If we want the GameObject rendered on another Sprite than the baseSprite.		 * @return Returns the GameObject added.		 * 		 */		public function addGameObject(go:HardCoreGameObject, alternativeBaseSprite:Sprite=null):HardCoreGameObject {			gameObjects.push(go);			if (go is PolyLineGameObject) {				polyLineGameObjects.push(go);			} else if (go is ZoneGameObject) {				zoneGameObjects.push(go);			}			if (alternativeBaseSprite == null) {				if (go.displayObject != null) {					baseSprite.addChild(go.displayObject);				}				go.setFunGrid(this, baseSprite);			} else {				// For å legge til objektet andre stader enn standard scrollAreaSprite				if (go.displayObject != null) {					alternativeBaseSprite.addChild(go.displayObject);				}				go.setFunGrid(this, alternativeBaseSprite);			}			lastAdded = go;			return go;		}		/** Returns the last added GameObject */		public function lastAddedGameObject():HardCoreGameObject {			return lastAdded;		}		/**		 * Updates all GameObjects.		 * Removes deleted objects. 		 * 		 */		protected function updateGameObjects():void {			var deleteObject:int = -1;			var l:int = gameObjects.length;			var ll:int;			var i:int;			var ii:int;			for (i = 0; i<l; i++) {				if (gameObjects[i]) {					if (! gameObjects[i].update()) {						if (deleteMaxOneObjectEachFrame) {							// Delete maximum one object on each update							deleteObject = i;						} else {							// Delete every object supposed to be deleted each update							if (gameObjects[i] is PolyLineGameObject) {							ll = polyLineGameObjects.length;							for (ii=0; ii<ll; ii++) {								if (gameObjects[i] == polyLineGameObjects[ii]) {									polyLineGameObjects.splice(ii,1);									ii = ll;								}							}						} else if (gameObjects[i] is ZoneGameObject) {							ll = zoneGameObjects.length;							for (ii=0; ii<ll; ii++) {								if (gameObjects[i] == zoneGameObjects[ii]) {									zoneGameObjects.splice(ii,1);									ii = ll;								}							}						}						gameObjects[i].destroy();						gameObjects[i] = null;						gameObjects.splice(i,1);						i--;						l--;						}					}				}			}			if (deleteMaxOneObjectEachFrame) {			if (deleteObject > -1) {				var go:Vector.<HardCoreGameObject >  = gameObjects.splice(deleteObject,1);				if (go[0] is PolyLineGameObject) {					deleteObject = -1;					l = polyLineGameObjects.length;					for (i=0; i<l; i++) {						if (go[0] == polyLineGameObjects[i]) {							deleteObject = i;						}					}					if (deleteObject > -1) {						polyLineGameObjects.splice(deleteObject,1);					}				} else if (go[0] is ZoneGameObject) {					deleteObject = -1;					l = zoneGameObjects.length;					for (i=0; i<l; i++) {						if (go[0] == zoneGameObjects[i]) {							deleteObject = i;						}					}					if (deleteObject > -1) {						zoneGameObjects.splice(deleteObject,1);					}				}				go[0].destroy();				go[0] = null;			}			}		}		/**		 * Update the position of the viewport. 		 * Tweens the position towards the futureViewport Point.		 * 		 */		protected function updateViewport():void {			var dx:Number = futureViewport.x - viewport.x;			var dy:Number = futureViewport.y - viewport.y;			var r:Number = Math.sqrt(dx * dx + dy * dy) * distanceFactor;			if (r < .5) {				moveViewport(futureViewport.x,futureViewport.y);			} else {				if (r > maxScrollSpeed) {					r = maxScrollSpeed;				}				var v:Number = Math.atan2(dy,dx);				viewport.offset(r*Math.cos(v),r*Math.sin(v));			}			// Check if viewport is outside of borderRectangle;			if (borderRectangle) {				if (borderRectangle.width != 0) {					if (viewport.x < borderRectangle.x) {						viewport.x = borderRectangle.x;					}					if (viewport.x + viewport.width > borderRectangle.x + borderRectangle.width) {						viewport.x = borderRectangle.x + borderRectangle.width - viewport.width;					}				}				if (borderRectangle.height != 0) {					if (viewport.y < borderRectangle.y) {						viewport.y = borderRectangle.y;					}					if (viewport.y + viewport.height > borderRectangle.y + borderRectangle.height) {						viewport.y = borderRectangle.y + borderRectangle.height - viewport.height;					}				}			}		}		/**		 * Move the viewport to a new position. 		 * @param x		 * @param y		 * 		 */		public function moveViewport(x:Number, y:Number):void {			viewport.x = x;			viewport.y = y;			setFutureViewport(x,y);		}		/**		 * Change the futureViewport point		 * @param x		 * @param y		 * 		 */		public function setFutureViewport(x:Number, y:Number):void {			if (borderRectangle) {				if (borderRectangle.width != 0) {					if (x < borderRectangle.x) {						x = borderRectangle.x;					}					if (x + viewport.width > borderRectangle.x + borderRectangle.width) {						x = borderRectangle.x + borderRectangle.width - viewport.width;					}				}				if (borderRectangle.height != 0) {					if (y < borderRectangle.y) {						y = borderRectangle.y;					}					if (y + viewport.height > borderRectangle.y + borderRectangle.height) {						y = borderRectangle.y + borderRectangle.height - viewport.height;					}				}			}			futureViewport.x = x;			futureViewport.y = y;		}		/**		 * Move the viewport to a new position by a point supposed to be in the center of the viewport. 		 * @param centerX		 * @param centerY		 * 		 */		public function moveViewportCenter(centerX:Number, centerY:Number):void {			moveViewport(centerX-viewport.width*0.5, centerY-viewport.height*0.5);		}		/**		 * 		 * @return Returns true if the viewport has reached the futureViewport position.		 * 		 */		public function viewportIsInFuturePosition():Boolean {			if (futureViewport.x == viewport.x && futureViewport.y == viewport.y) {				return true;			} else {				return false;			}		}		/**		 * Change the futureViewport point by a point supposed to be in the center of the viewport. 		 * @param centerX		 * @param centerY		 * 		 */		public function setFutureViewportCenter(centerX:Number, centerY:Number):void {			setFutureViewport(centerX-viewport.width*0.5, centerY-viewport.height*0.5);		}		/**		 * Returns the first GameObject with the id from gameObjects or null if no GameObject is found		 * @param id		 * @return Returns the first GameObject with the id from gameObjects or null		 * 		 */		public function gameObjectFromId(id:String):HardCoreGameObject {			var l:int = gameObjects.length;			for (var i:int = 0; i<l; i++) {				if (gameObjects[i].id == id) {					return gameObjects[i];				}			}			trace("GameObject with id '"+id+"' not found!");			return null;		}						/**		* Sorts GameObjects on depthIndex and swap depths on objects where doDepthSorting is true		* Call this function after update() on each frame.		* Does not work with blitting objects!		*/		public function depthSorting():void {			var sorted:Vector.<HardCoreGameObject >  = gameObjects.sort(sortDepths);			var l:uint = sorted.length;			for (var i:uint = 0; i<l; i++) {				if (sorted[i] is GameObject) {					if (sorted[i].displayObject.visible && GameObject(sorted[i]).doDepthSorting) {						sorted[i].baseSprite.setChildIndex(sorted[i].displayObject, i);					}				}			}		}		/** Sorting function for gameObjects.sort() - Lowest depthIndex first. */		private function sortDepths(go1:HardCoreGameObject, go2:HardCoreGameObject):int {			/* New version - avoid error when trying to sort non GameObjects */			if(go1 is GameObject && go2 is GameObject) {				var d1:int = GameObject(go1).depthIndex;				var d2:int = GameObject(go2).depthIndex;			if (d1 < d2) {				return -1;			} else if (d1>d2) {				return 1;			} else {				return 0;			}			} else {				return 0;			}			/* Old version: go1 & go2 are GameObject			if (go1.depthIndex < go2.depthIndex) {				return -1;			} else if (go1.depthIndex>go2.depthIndex) {				return 1;			} else {				return 0;			}			*/		}		/**		 * Removes all displayObjects from parentSprite, and destroys all gameObjects. 		 */		public function destroy():void {			if (blittingCanvas) {				baseSprite.removeChild(blittingBitmap);			}			if (bitmapRender) {				parentSprite.removeChild(bitmapRenderCanvas);			} else {				parentSprite.removeChild(baseSprite);			}			while (gameObjects.length>0) {				var go:HardCoreGameObject = gameObjects.pop();				go.destroy();				go = null;			}			gameObjects = new Vector.<HardCoreGameObject>();		}	}}