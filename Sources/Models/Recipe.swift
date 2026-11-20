import Foundation

struct Recipe: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let nameLV: String
    let description: String
    let ingredients: [RecipeIngredient]
    let steps: [String]
    let prepTimeMinutes: Int
    let cookTimeMinutes: Int
    let servings: Int
    let caloriesPerServing: Int
    let proteinPerServing: Double
    let carbsPerServing: Double
    let fatsPerServing: Double
    let dietaryTags: [DietaryTag]
    let cuisine: String
    let difficulty: Difficulty
    let equipment: [KitchenEquipment]
    let imageUrl: String?

    init(
        id: UUID = UUID(),
        name: String,
        nameLV: String,
        description: String,
        ingredients: [RecipeIngredient],
        steps: [String],
        prepTimeMinutes: Int,
        cookTimeMinutes: Int,
        servings: Int,
        caloriesPerServing: Int,
        proteinPerServing: Double,
        carbsPerServing: Double,
        fatsPerServing: Double,
        dietaryTags: [DietaryTag] = [],
        cuisine: String,
        difficulty: Difficulty,
        equipment: [KitchenEquipment] = [],
        imageUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.nameLV = nameLV
        self.description = description
        self.ingredients = ingredients
        self.steps = steps
        self.prepTimeMinutes = prepTimeMinutes
        self.cookTimeMinutes = cookTimeMinutes
        self.servings = servings
        self.caloriesPerServing = caloriesPerServing
        self.proteinPerServing = proteinPerServing
        self.carbsPerServing = carbsPerServing
        self.fatsPerServing = fatsPerServing
        self.dietaryTags = dietaryTags
        self.cuisine = cuisine
        self.difficulty = difficulty
        self.equipment = equipment
        self.imageUrl = imageUrl
    }

    var totalTimeMinutes: Int {
        prepTimeMinutes + cookTimeMinutes
    }
}

struct RecipeIngredient: Identifiable, Codable, Hashable {
    let id: UUID
    let ingredientName: String
    let quantity: Double
    let unit: String
    let isOptional: Bool

    init(
        id: UUID = UUID(),
        ingredientName: String,
        quantity: Double,
        unit: String,
        isOptional: Bool = false
    ) {
        self.id = id
        self.ingredientName = ingredientName
        self.quantity = quantity
        self.unit = unit
        self.isOptional = isOptional
    }
}

enum DietaryTag: String, Codable, CaseIterable, Hashable {
    case vegetarian = "vegetarian"
    case vegan = "vegan"
    case glutenFree = "gluten-free"
    case dairyFree = "dairy-free"
    case lowCarb = "low-carb"
    case highProtein = "high-protein"
    case keto = "keto"
}

enum Difficulty: String, Codable, CaseIterable, Hashable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
}

enum KitchenEquipment: String, Codable, CaseIterable, Hashable {
    // Appliances
    case oven = "oven"
    case stovetop = "stovetop"
    case microwave = "microwave"
    case airFryer = "air-fryer"
    case slowCooker = "slow-cooker"
    case pressureCooker = "pressure-cooker"
    case multiCooker = "multi-cooker"
    case riceCooker = "rice-cooker"
    case grill = "grill"
    case deepFryer = "deep-fryer"
    case toasterOven = "toaster-oven"
    case blender = "blender"
    case foodProcessor = "food-processor"
    case standMixer = "stand-mixer"
    case immersionBlender = "immersion-blender"
    case juicer = "juicer"
    case breadMachine = "bread-machine"
    case kettle = "kettle"
    case coffeeMaker = "coffee-maker"
    case dehydrator = "dehydrator"
    case sousVide = "sous-vide"
    case smoker = "smoker"

    // Cookware
    case pan = "pan"
    case pot = "pot"
    case wok = "wok"
    case dutchOven = "dutch-oven"
    case bakingTray = "baking-tray"
    case bakingSheet = "baking-sheet"
    case roastingPan = "roasting-pan"
    case castIronPan = "cast-iron-pan"
    case nonStickPan = "non-stick-pan"
    case glassBakingDish = "glass-baking-dish"
    case muffinTin = "muffin-tin"
    case loafPan = "loaf-pan"
    case piePan = "pie-pan"
    case cakePan = "cake-pan"
    case springformPan = "springform-pan"
    case bundtPan = "bundt-pan"
    case saucepan = "saucepan"
    case stockpot = "stockpot"
    case casserole = "casserole"
    case tagine = "tagine"
    case paellaPan = "paella-pan"
    case crepePan = "crepe-pan"
    case waffleIron = "waffle-iron"
    case pizzaStone = "pizza-stone"
    case steamBasket = "steam-basket"
    case doubleBoiler = "double-boiler"
    case bambooSteamer = "bamboo-steamer"
    case skewers = "skewers"

    // Tools
    case knife = "knife"
    case cuttingBoard = "cutting-board"
    case mixingBowl = "mixing-bowl"
    case whisk = "whisk"
    case rollingPin = "rolling-pin"
    case colander = "colander"
    case strainer = "strainer"
    case sieve = "sieve"
    case spatula = "spatula"
    case tongs = "tongs"
    case ladle = "ladle"
    case woodenSpoon = "wooden-spoon"
    case slottedSpoon = "slotted-spoon"
    case servingSpoon = "serving-spoon"
    case measuringCups = "measuring-cups"
    case measuringSpoons = "measuring-spoons"
    case foodScale = "food-scale"
    case thermometer = "thermometer"
    case peeler = "peeler"
    case grater = "grater"
    case mandoline = "mandoline"
    case garlicPress = "garlic-press"
    case lemonSqueezer = "lemon-squeezer"
    case eggSeparator = "egg-separator"
    case mortarAndPestle = "mortar-and-pestle"
    case canOpener = "can-opener"
    case bottleOpener = "bottle-opener"
    case corkscrew = "corkscrew"
    case pastryBrush = "pastry-brush"
    case bastingBrush = "basting-brush"
    case chopsticks = "chopsticks"

    // Supplies
    case aluminumFoil = "aluminum-foil"
    case parchmentPaper = "parchment-paper"
    case siliconeMat = "silicone-mat"
    case plasticWrap = "plastic-wrap"
    case freezerBag = "freezer-bag"
    case storageContainer = "storage-container"
    case iceTray = "ice-tray"
}
