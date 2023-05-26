import '../model/base_model.dart';
import '../model/categories_model.dart';

List<CategoriesModel> categories = [
  CategoriesModel(
    imageUrl: "assets/images/avon.png",
    title: "Avon",
    pdfUrl: "assets/avon.pdf",
  ),
  CategoriesModel(
    imageUrl: "assets/images/betterware.png",
    title: "Betterware",
    pdfUrl: "assets/betterware.pdf",
  ),
  CategoriesModel(
    imageUrl: "assets/images/jafra.png",
    title: "Jafra",
    pdfUrl: "assets/jafra.pdf",
  ),
  CategoriesModel(
    imageUrl: "assets/images/marykay.png",
    title: "MaryKay",
    pdfUrl: "assets/marykay.pdf",
  ),
  CategoriesModel(
    imageUrl: "assets/images/shelo.png",
    title: "Sheló",
    pdfUrl: "assets/shelo.pdf",
  ),
  CategoriesModel(
    imageUrl: "assets/images/andrea.png",
    title: "Andrea",
    pdfUrl: "assets/andrea.pdf",
  ),
  CategoriesModel(
    imageUrl: "assets/images/concord.png",
    title: "Concord",
    pdfUrl: "assets/concord.pdf",
  ),
];
    
 List<BaseModel> mainList = [
  BaseModel(
    imageUrl: "assets/images/maquillaje_ultramate.jpg",
    name: "Maquillaje.",
    price: 233.00,
    review: 2.6,
    star: 3.8,
    id: 1,
    value: 1,
  ),
  BaseModel(
    imageUrl: "assets/images/matrimonialconcord.jpg",
    name: "Edredón",
    price: 233.99,
    review: 5.6,
    star: 5.0,
    id: 2,
    value: 1,
  ),
  BaseModel(
    imageUrl: "assets/images/loncheramax.jpg",
    name: "Lonchera Max",
    price: 300.99,
    review: 2.6,
    star: 3.7,
    id: 3,
    value: 1,
  ),
  BaseModel(
    imageUrl: "assets/images/dispensador.jpg",
    name: "Dispensador ",
    price: 200.00,
    review: 1.4,
    star: 2.4,
    id: 4,
    value: 1,
  ),
  BaseModel(
    imageUrl: "assets/images/zapatillahueso.jpg",
    name: "Zapatillas",
    price: 450.00,
    review: 4.2,
    star: 1.8,
    id: 5,
    value: 1,
  ),
  BaseModel(
    imageUrl: "assets/images/sudadera.jpg",
    name: "Sudadera ",
    price: 320.99,
    review: 2.1,
    star: 3.1,
    id: 6,
    value: 1,
  ),
  BaseModel(
    imageUrl: "assets/images/cremashelo.jpg",
    name: "Crema Corporal  ",
    price: 113.99,
    review: 3.1,
    star: 4.8,
    id: 7,
    value: 1,
  ),
  BaseModel(
    imageUrl: "assets/images/labialmarykay.jpg",
    name: "Labial",
    price: 178.99,
    review: 2.6,
    star: 4.8,
    id: 8,
    value: 1,
  ),
];

List<BaseModel> itemsOnCart = [];
List<BaseModel> itemsOnSearch = [];
