import structs/ArrayList

MaskList: class extends Mask {

	masks: ArrayList<Mask>

	init: func (=masks) {}
	init : func ~withoutMasks () {}
	
	check: func (other: Mask) -> Bool {
		for (mask in masks) {
			if (mask active) {
				if (mask check(other)) return true
			}
		}
		return false
	}
	
	add: func (mask: Mask) {
		masks add(Mask)
	}
	
	remove: func (mask: Mask) {
		graphics remove(mask)
	}
	
	removeAt: func (index: Int) {
		if (index >= masks size) return
		masks removeAt(index)
	}
	
	removeAll: func () {
		masks clear()
	}
}