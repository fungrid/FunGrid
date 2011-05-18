package no.agens.fungrid
{
	import flash.geom.Point;
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
	 * <h1>PhysicsGameObject</h1>
	 * <p>Object to define a collision with a PolyLineGameObject</p>
	 * 
	 * @author Peter Måseide, Agens AS
	 * @date 18. jan. 2011
	 */
	public class PolyLineCollision {
		public var point:Point;
		public var parameter:Number;
		public var plgo:PolyLineGameObject;
		public function PolyLineCollision() {
		}
	}
}