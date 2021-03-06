use sdl2
import sdl2/Audio
import ./[SampleLoader, Mixer]

Sample: class {
	data: UInt8*
	size: SizeT
	
	init: func (=data, =size)
	
	create: static func (path:String, mixer:Mixer) -> This {
		SampleLoader load(path, mixer spec)
	}
}
