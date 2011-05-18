package no.agens.keyboard
{
	import flash.events.KeyboardEvent;
	import flash.display.Stage;
	/*
	Copyright (c) 2011, Agens AS <post@agens.no> http://agens.no
	
	Permission to use, copy, modify, and/or distribute this software for any
	purpose with or without fee is hereby granted, provided that the above
	copyright notice and this permission notice appear in all copies.
	
	THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
	WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
	MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
	ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
	WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
	ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
	OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
	*/
	/**
	 * <h1>KeyController</h1>
	 * <p>Calls functions on desired keyboard events and checks if keyboard keys are up or down. </p>
	 * <p>
	 * 1. Create an instance of KeyController<br/>
	 * 2. Add the keys you want to listen to with addKey(keyCode)<br/>
	 * 3. Add up or down functions to your keys addUpFunction(keyCode, f)/addDownFunction(keyCode, f), or just check their status with isDown(keyKode)<br/>
	 * 4. Remember to remove functions when not longer in use!
	 * </p>
	 * <p>Developed by Agens AS - http://agens.no</p>
	 * 
	 * @author Knut Clausen & Peter Måseide, Agens AS
	 * @date 24. jan. 2011
	 */
	public class KeyController {
		
		public var focusStage:Stage;
		var keys:Array;
		/**
		 * Constructor 
		 * @param focusStage focus stage of your swf
		 * 
		 */		
		public function KeyController(focusStage:Stage) {
			this.focusStage = focusStage;
			keys = new Array();
			focusStage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			focusStage.addEventListener(KeyboardEvent.KEY_UP, keyReleased);
		}
		/**
		 * Use this function to addKeys to be able to listen to their status with isDown(keyKode) 
		 * @param keyCode
		 * 
		 */		
		public function addKey(keyCode:Number):void{			
			var k=new ControlledKey();
			keys[keyCode] = k;			
		}
		/**
		 * Assign a function f to the release of a certain key on the keyboard.
		 * @param keyCode
		 * @param f
		 * 
		 */		
		public function addUpFunction(keyCode:Number, f:Function):void {
			if (!keys[keyCode]) {
				addKey(keyCode);
			}
			keys[keyCode].addUpFunction(f);
		}
		/**
		 * Assign a function f to the downpress of a certain key on the keyboard.
		 * @param keyCode
		 * @param f
		 * 
		 */	
		public function addDownFunction(keyCode:Number, f:Function):void {
			if (!keys[keyCode]) {
				addKey(keyCode);
			}
			keys[keyCode].addDownFunction(f);
		}
		/**
		 * Removes the function from a key.
		 * @param keyCode
		 * @param f
		 * 
		 */	
		public function removeDownFunction(keyCode:Number, f:Function):void {
			if (!keys[keyCode]) {
				return;
			}
			keys[keyCode].removeDownFunction(f);
		}
		/**
		 * Removes the function from a key.
		 * @param keyCode
		 * @param f
		 * 
		 */	
		public function removeUpFunction(keyCode:Number, f:Function):void {
			if (!keys[keyCode]) {
				return;
			}
			keys[keyCode].removeUpFunction(f);
		}
		/**
		 * Returns true if the korresponding key for keyCode is down. You must add the key with addKey(keyCode) first to be able to do this check. 
		 * @param keyCode
		 * @return 
		 * 
		 */		
		public function isDown(keyCode:Number):Boolean {
			if (keys[keyCode]) {
				return keys[keyCode].isDown;
			}
			trace(keyCode+" is not a keyCode to an added key");
			return false;
		}
		private function keyPressed(evt:KeyboardEvent):void {
			if (keys[evt.keyCode]!=undefined)keys[evt.keyCode].press();
		}
		private function keyReleased(evt:KeyboardEvent):void {
			if (keys[evt.keyCode]!=undefined)keys[evt.keyCode].release();
		}
		/**
		 * Removes all listeners/functions. 
		 * 
		 */		
		public function destroy():void{
			for (var t in keys){
				keys[t].destroy();
			}
			focusStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyPressed);
			focusStage.removeEventListener(KeyboardEvent.KEY_UP, keyReleased);	
			keys=null;
		}
	}
}