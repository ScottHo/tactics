class_name TargetTypes

static var SELF = "Self"
static var ALLIES = "Allied Units"
static var OTHER_ALLIES = "Other Allied Units"
static var ENEMIES = "Enemy Units"
static var ANY = "Any Unit"
static var ALL_ENEMIES = "All Enemy Units"
static var ALL_ALLIES = "All Units"
static var ALL = "All Units"
static var EMPTY = "Empty Tiles"

static var ALLIES_LIST: Array = [SELF, ALLIES, OTHER_ALLIES, ANY, ALL_ALLIES, ALL]
static var ENEMIES_LIST: Array = [ENEMIES, ANY, ALL_ENEMIES, ALL]
static var SELF_OK: Array = [SELF, ALLIES, ANY, ALL_ALLIES, ALL]
static var NO_BFS: Array = [ALL_ENEMIES, ALL_ALLIES, ALL]
