import 'package:money_manager/models/transaction_model.dart';

class ChartData {
  String categories;
  double amount;

  ChartData({required this.categories,required this.amount});
}

chatLogic(List<TransactionModel> model) {
   
double value;
String categoryName;
List visited = [];
List<ChartData> newData = [];

for(var i=0;i<model.length;i++){
  visited.add(0);
}

for(var i=0;i<model.length;i++){
  value = model[i].amount;
  categoryName = model[i].categry.name;
  for(var j=i+1;j<model.length;j++){
   if(model[i].categry.name == model[j].categry.name){
    value += model[j].amount;
    visited[j] = -1;
   }
  }
  if(visited[i]!= -1){
    newData.add(
      ChartData(categories: categoryName, amount: value)
    );

  }
}
return newData;
}