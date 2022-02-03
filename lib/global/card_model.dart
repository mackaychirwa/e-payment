class CardModel {
  String user;
  String cardHolder;
  String cardNumber;
  int cardBackground;

  CardModel(this.cardHolder, this.cardNumber, this.user, this.cardBackground);
}

List<CardModel> cards = cardData
    .map(
      (item) => CardModel(
        item['user'],
        item['CardNumber'],
        item['CardHolder'],
        item['cardBackground'],
      ),
    )
    .toList();

var cardData = [
  {
    "user": "Mackay Chirwa",
    "CardNumber": "*** *** 483",
    "CardHolder": "Chirs Kay",
    "cardBackground": 0xFFFF0000,
  }
];
