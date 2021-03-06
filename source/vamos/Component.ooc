import vamos/[Entity, Scene]

/**
 * Used for shared behaviour in entities
 */
Component: abstract class {
	
	name: String
	entity: Entity
	scene: Scene { get {entity scene} }
	active := true
	
	init: func
	
	reset: func
	added: func
	removed: func
	
	update: func (dt:Float)
	
}