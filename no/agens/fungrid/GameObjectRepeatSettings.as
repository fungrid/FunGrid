﻿package no.agens.fungrid {		public class GameObjectRepeatSettings {		/** The distance in pixels between every repeat in the x direction. Default value undefined means no repetition. */		public var repeatEveryX:Number;		/** The distance in pixels between every repeat in the y direction. Default value undefined means no repetition. */		public var repeatEveryY:Number;		public var noRepeatBeforeX:Number;		public var noRepeatAfterX:Number;		public var noRepeatBeforeY:Number;		public var noRepeatAfterY:Number;		public function GameObjectRepeatSettings(repeatEveryX:Number=undefined, noRepeatBeforeX:Number=undefined, noRepeatAfterX:Number=undefined,repeatEveryY:Number=undefined, noRepeatBeforeY:Number=undefined, noRepeatAfterY:Number=undefined) {			this.repeatEveryX = repeatEveryX;			this.noRepeatBeforeX = noRepeatBeforeX;			this.noRepeatAfterX = noRepeatAfterX;			this.repeatEveryY = repeatEveryY;			this.noRepeatBeforeY = noRepeatBeforeY;			this.noRepeatAfterY = noRepeatAfterY;		}	}	}