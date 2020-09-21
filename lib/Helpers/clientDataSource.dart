class ClientData {
  String temp;

  static List<Map> isBundleList = [
    {
      "display": "True",
      "value": "True",
    },
    {
      "display": "False",
      "value": "False",
    },
  ];

  static List<Set<List<Map>>> aisBundleList = [
    {
      [
        {
          "display": "True",
          "value": "True",
        },
        {
          "display": "False",
          "value": "False",
        },
      ]
    },
  ];
  static List<Map> categoryList = [
    {
      "display": "Ala Carte",
      "value": "Ala Carte",
    },
    {
      "display": "Mix n match",
      "value": "Mix n match",
    },
  ];

  ClientData(this.temp);
}
