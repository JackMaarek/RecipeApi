import Foundation
import Kitura
import KituraCompression
import KituraCORS
import HeliumLogger

HeliumLogger.use()

let router = Router()
let cors = CORS(options: Options(allowedOrigin: .all, allowedHeaders: ["Content-Type"]))

router.all(middleware: [cors, BodyParser(), Compression()])

struct Recipies: Codable {
    let data : [Recipe]
}

struct Recipe: Codable {
    let name: String?
    let time: String?
    let number: String?
    let image: String?
    let steps: [Step]?
    let ingredient: [Ingredient]?
}

struct Step: Codable {
    let text: String?
}

struct Ingredient: Codable {
    let name: String?
    let category: String?
    let quantity: String?
}

router.get("/") {
    _, response, next in



    let data = Recipies(data: [
        Recipe(name: "Tournedos de bœuf au boursin", time: "20 min", number: "4 personnes", image: "R1", steps: [
            Step(text: "Péparer la sauce : dans une casserole mettre 4 cuillères à café de fond de veau, ajoutez une petite tasse d'eau et mettre sur le feu."),
            Step(text: "Mélanger à l'aide d'une cuillère en bois, jusqu'à obtenir un mélange homogène et lisse. Ajouter la moitié du boursin et remuer jusqu'à ce qu'il soit complètement fondu."),
            Step(text: "Incorporer 20 cl de crème liquide et réserver au chaud."),
            Step(text: "Faites fondre une noisette de beurre dans une poêle, saisir les tournedos, saler, poivrer. Servir accompagné d'une julienne de légumes. Napper la viande de sauce."),
            Step(text: "Bon appétit")
        ], ingredient: [
            Ingredient(name: "filet de boeuf", category: "Viande", quantity: "4"),
            Ingredient(name: "beurre", category: "BOF", quantity: "10g"),
            Ingredient(name: "boursin", category: "BOF", quantity: "1"),
            Ingredient(name: "crème liquide", category: "BOF", quantity: "20 cl"),
            Ingredient(name: "fond de veau déshydraté", category: "Épicerie", quantity: "4 cc")
        ]),
    Recipe(name: "Magrets de canard au miel", time: "20 min", number: "2 personnes", image: "R2", steps: [
        Step(text: "Inciser les magrets côté peau en quadrillage sans couper la viande."),
        Step(text: "Cuire les magrets à feu vif dans une cocotte en fonte, en commençant par le coté peau."),
        Step(text: "Le temps de cuisson dépend du fait qu'on aime la viande plus ou moins saignante. Compter environ 5 min de chaque côté. Retirer régulièrement la graisse en cours de cuisson."),
        Step(text: "Réserver les magrets au chaud (au four, couverts par une feuille d'aluminium)."),
        Step(text: "Déglacer la cocotte avec le miel et le vinaigre balsamique. Ne pas faire bouillir, la préparation tournerait au caramel. Bien poivrer."),
        Step(text: "Mettre en saucière accompagnant le magret coupé en tranches."),
        Step(text: "Comme accompagnement, je suggère des petits navets glacés (cuits à l'eau puis passés au beurre avec un peu de sucre).")
    ], ingredient: [
        Ingredient(name: "magrets de canard", category: "Viande", quantity: "2"),
        Ingredient(name: "miel", category: "Épicerie", quantity: "2 cs"),
        Ingredient(name: "vinaigre balsamique", category: "Épicerie", quantity: "3 cc")
    ])
    ])


    do {
        try response.send(data).end()
        next()
    } catch let e {
        print(e.localizedDescription)
        response.status(.internalServerError)
    }
}

Kitura.addHTTPServer(onPort: 7689, with: router)
Kitura.run()

