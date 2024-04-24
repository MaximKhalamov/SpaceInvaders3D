String language;

class Translation{
  String lang;
  
  Map<String, String> dictionaryRus;
  Map<String, String> dictionaryEng;
  Map<String, String> dictionaryCurrent;
  
  public Translation(String lang){
    setLang(lang);
    buildDictionary();
  }

  public Translation(){
    setLang("");
    buildDictionary();
  }
  
  public void buildDictionary(){
    dictionaryRus = new HashMap<>();
    dictionaryEng = new HashMap<>();
    setLang(lang);
    addToDictionaries("settings", "SETTINGS", "НАСТРОЙКИ");
    addToDictionaries("menu", "MENU", "MENU");
    addToDictionaries("back", "BACK", "НАЗАД");
    addToDictionaries("exit", "EXIT", "ВЫХОД");
    addToDictionaries("restart", "RESTART", "ПЕРЕЗАПУСК");
    addToDictionaries("continue", "CONTINUE", "ПРОДОЛЖИТЬ");
    addToDictionaries("loading", "Loading", "Загрузка");
    addToDictionaries("prepare", "PREPARE", "ГОТОВЬСЯ");
    addToDictionaries("cleared", "CLEARED", "ЗАЧИЩЕНО");
    addToDictionaries("gameover", "GAME OVER", "ИГРА ОКОНЧЕНА");
    addToDictionaries("sound", "SOUND ", "ЗВУКИ ");
    addToDictionaries("music", "MUSIC ", "МУЗЫКА");
    addToDictionaries("sensitivity", "SENSITIVITY", "ЧУВСТВИТЕЛЬНОСТЬ");
    addToDictionaries("damage", "DAMAGE!", "ПОВРЕЖДЕНИЕ!");
    addToDictionaries("youwin", "YOU WIN", "ПОБЕДА");
    addToDictionaries("start", "CAMPAIGN", "КАМПАНИЯ");
    addToDictionaries("language", "LANGUAGE", "LANGUAGE");
    addToDictionaries("infinite", "ENDLESS", "БЕСКОНЕЧНЫЙ");  
    addToDictionaries("exitmenu", "BACK TO MENU", "НАЗАД В МЕНЮ");  
    addToDictionaries("destroyin2min", "DESTROY in 2:00", "УНИЧТОЖИТЬ за 2:00");  
    addToDictionaries("best", "BEST:", "ЛУЧШИЙ:");  
  }
  
  public void setLang(String lang){
    this.lang = lang;
    if(lang.equals("RU")) dictionaryCurrent = dictionaryRus;
    else if(lang.equals("EN")) dictionaryCurrent = dictionaryEng;
  }
  
  public String get(String word){
    if(dictionaryCurrent == null){
      return "";
    }
    return dictionaryCurrent.get(word);
  }
  
  private void addToDictionaries(String word, String eng, String rus){
    dictionaryRus.put(word, rus);
    dictionaryEng.put(word, eng);
  }
}
