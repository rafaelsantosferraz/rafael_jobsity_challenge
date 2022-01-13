class PaginatedList<T>{

  PaginatedList({List<List<T>>? pages, bool isLastPage = false})
      : _pages = pages ?? [[]],
        _isLastPage = isLastPage;

  final List<List<T>> _pages;
  bool _isLastPage = false;

  bool get isLastPage => _isLastPage;
  bool get isNotEmpty => _pages.isNotEmpty;
  int get length => _pages.length;

  void add(List<T> newPage){
    if(newPage.isEmpty){
      _isLastPage = true;
    } else {
      _isLastPage = false;
      _pages.add(newPage);
    }
  }

  void clear(){
    _pages.clear();
  }

  List<T> getPage(int page){
    return _pages[page];
  }

  List<T> getAll(){
    return _pages.expand((page) => page).toList();
  }

  PaginatedList<T> copy(){
    return PaginatedList(
      pages: List.from(_pages),
      isLastPage: isLastPage
    );
  }

  @override
  String toString() {
    var string = '';
    for(var page in _pages){
      string += '[';
      for(var item in page){
        string += item.toString();
      }
      string += ',]';
    }
    return string;
  }
}