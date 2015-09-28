use sdl2
use ooc-utf8
import sdl2/[Core, TTF]
import structs/HashMap
import vamos/[Graphic, Entity]
import vamos/display/[Color, Texture, Screen, Font]

TTFLabel: class extends Graphic{
    font: Font

    texture: Texture

    text: String = ""
    angle: Double

	dstRect: SdlRect
	srcRect: SdlRect
	origin: SdlPoint

    utf: UTF8 = UTF8 new()

    init: func(path: String, pix: Int){ font = Font new(path, pix) }

    text: func(s: String){
        text(utf toUTF(s))
    }

    text: func ~array (s: UInt32[]){
        if(texture) texture free()
        texture = font draw(s)
		dstRect w = texture width
		dstRect h = texture height
		srcRect w = texture width
		srcRect h = texture height
    }


	center: func {
		origin x = srcRect w * 0.5
		origin y = srcRect h * 0.5
	}

	draw: func (screen:Screen, entity:Entity, x, y: Double) {
        if(texture){
            dstRect x = x - origin x
            dstRect y = y - origin y
            if (angle == 0) {
                screen drawTexture(texture, srcRect&, dstRect&)
            } else {
                screen drawTexture(texture, srcRect&, dstRect&, angle, null, SDL_FLIP_NONE)
            }
        }
	}

    close: func{ if(font) font free() }
}
