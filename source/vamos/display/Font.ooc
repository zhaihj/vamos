use sdl2
use vamos
import structs/[ArrayList, HashMap]
import sdl2/[Core, TTF]
import vamos/display/Texture
import ./Color

FontStyle: enum{
    Solid, Shaded, Blended
}

FontInfo: class{
    minx, miny, maxx, maxy: Int
    advance: Int

    init: func

    getRect: func -> SdlRect{ (0, 0, maxx - minx, maxy - miny) as SdlRect }
    getSize: func -> Int{ (maxx - minx) * (maxy - miny) }
}

Font: class{
    font: TTFFont
    surface: SdlSurface*

    fontCache := HashMap<Int32, Pointer> new()
    fontInfo := HashMap<Int32, FontInfo> new()

    color: SdlColor = (255, 255, 255, 255) as SdlColor
    shadeColor: SdlColor = (0, 0, 0, 0) as SdlColor
    lineskip: Int = 0

    fontStyle: FontStyle = FontStyle Solid

    init: func(path: String, ptSize: Int, ls: Int = 0){
        font = TTFFont new(path, ptSize)
        if(ls == 0) lineskip = font lineSkip()
        else lineskip = ls
    }

    free: func{
        for((i,j) in fontCache){ SDL freeSurface(j) }
        if(surface) SDL freeSurface(surface)
        font close()
    }

    draw: func(rtext: UInt32[]) -> Texture{
        if(!font) return null
        (width, height) := (0, lineskip)
        col := 0
        for(i in 0..rtext length){
            c := rtext[i]
            if(c == 10){ // \n
                height += lineskip
                if(col > width) width = col
                col = 0
            } else if(c == 13){
                col = 0
            } else {
                fi := fontInfo[c]
                if(!fi){
                    fi = FontInfo new()
                    font glyphMetrics(c as UInt16, fi minx&,
                        fi maxx&, fi miny&, fi maxy&, fi advance&)
                    fontInfo put(c, fi)
                    match(fontStyle){
                        case FontStyle Solid =>
                            fontCache put(c, font renderGlyphSolid(c as UInt16, color))
                        case FontStyle Shaded =>
                            fontCache put(c, font renderGlyphShaded(c as UInt16, color, shadeColor))
                        case FontStyle Blended =>
                            fontCache put(c, font renderGlyphBlended(c as UInt16, color))
                        case => Exception new("Unknown Font Style") throw()
                    }
                }
                col += fi advance
            }
        }
        if(col > width) width = col

        retsurface := SDL createRGBSurface(0, width, height, 32,
                0x000000FF, 0x0000FF00, 0x00FF0000, 0xFF000000)

        dstRect := (0, 0, 0, 0) as SdlRect

        for(i in 0..rtext length){
            c := rtext[i]
            if(c == 10){
                dstRect x = 0
                dstRect y += lineskip
                continue
            } else if(c == 13){
                dstRect x = 0
                continue
            }
            fs := (fontCache[c] as SdlSurface*)@
            fi := fontInfo[c]
            dstRect w = fs w
            dstRect h = fs h
            SDL blitSurface(fs&, ((0, 0, fs w, fs h) as SdlRect)&, retsurface, dstRect&)
            dstRect x += fi advance
        }

        Texture new(retsurface)
    }

}
