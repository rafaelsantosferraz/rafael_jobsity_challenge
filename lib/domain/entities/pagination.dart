class Pagination<T>{

  Pagination();

  List<List<T>> pages = [];
  bool _isLastPage = false;
  bool get isLastPage => _isLastPage;
  bool get isNotEmpty => pages.isNotEmpty;
  int get length => pages.length;

  void add(List<T> page){
    pages.add(page);
  }

  void clear(){
    pages.clear();
  }

  List<T> getPage(int page){
    return pages[page];
  }

  List<T> getAll(){
    return pages.expand((page) => page).toList();
  }

  void noMorePages(){
    _isLastPage = true;
  }


}