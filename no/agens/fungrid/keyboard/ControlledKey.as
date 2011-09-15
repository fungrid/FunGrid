package no.agens.fungrid.keyboard
{
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
	 * <h1>ControlledKey</h1>
	 * <p>Class for each key the KeyController controls. This class should only be used by the KeyController!</p>
	 * <p>Developed by Agens AS - http://agens.no</p>
	 * 
	 * @author Knut Clausen & Peter Måseide, Agens AS
	 * @date 24. jan. 2011
	 */
	public class ControlledKey {
		
		private var upFunctions:Array;
		private var downFunctions:Array;
		public var isUp:Boolean=true;
		public var isDown:Boolean=false;
		
		public function ControlledKey() {
			upFunctions=new Array();
			downFunctions=new Array();
		}
		public function addUpFunction(f:Function):void {
			if (isInArray(f,upFunctions)) return;
			upFunctions.push(f);
		}
		public function addDownFunction(f:Function):void {
			if (isInArray(f,downFunctions)) return;
			downFunctions.push(f);
		}
		public function removeUpFunction(f:Function):void {
			var newUpFunctions:Array=new Array();	
			
			for (var t in upFunctions){					
				if (upFunctions[t]!=f)newUpFunctions.push(upFunctions[t]);
			}				
			upFunctions=newUpFunctions;
		}
		public function removeDownFunction(f:Function):void {
			var newDownFunctions:Array=new Array();
			
			for (var i in downFunctions){					
				if (downFunctions[i]!=f)newDownFunctions.push(downFunctions[i]);
			}				
			downFunctions=newDownFunctions;	
		}
		public function press():void{
			if (isDown) return;
			for (var t in downFunctions){				
				downFunctions[t]();
			}
			isUp=false;
			isDown=true;	
			
		}
		public function release():void{	
			if (isUp)return;
			for (var t in upFunctions){				
				upFunctions[t]();
			}	
			isUp=true;
			isDown=false;
		}
		public function isInArray(o:Object, a:Array):Boolean{
			if (a.indexOf(o)>-1)return true;
			return false;
		}
		public function destroy():void{
			upFunctions=null;
			downFunctions=null;
		}
	}
}