import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';
import 'package:http/http.dart' as http;


final _URL_NEWS = 'https://newsapi.org/v2';
final _APIKEY = '6b51002631ff4fa8b74770ad0c1e9f9e';

class NewsService with ChangeNotifier{
  List<Article> headlines = [];
  String _selectedCategory = 'business';


  List<Category> categories=[
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology'),
  ];   


  Map<String,List<Article>> categoryArticles={};
  


  NewsService(){
    this.getTopHeadlines();
    categories.forEach((item) {
      this.categoryArticles[item.name] = new List();

    });
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor){
    this._selectedCategory = valor;
    this.getArticleByCategory(valor);
    notifyListeners();
  }


  List<Article> get getArticulosCategoriaSeleccionada=> this.categoryArticles[this.selectedCategory];



  getTopHeadlines() async {
    print('Cargando Headlines...');
    final url='$_URL_NEWS/top-headlines?country=mx&apiKey=$_APIKEY';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);
    this.headlines.addAll(newsResponse.articles);
    notifyListeners();
  }

  getArticleByCategory(String category) async {


    if(this.categoryArticles[category].length>0){
      return this.categoryArticles[category];
    }


    final url='$_URL_NEWS/top-headlines?country=mx&apiKey=$_APIKEY&category=$category';
    final resp = await http.get(url);

    final newsResponse = newsResponseFromJson(resp.body);
    
    this.categoryArticles[category].addAll(newsResponse.articles);
    
    notifyListeners();

  }
   
}