import 'package:flutter/material.dart';

class FuelConvent{
  int litre = 899;
  int value;
  int desel = 898;
  
  

  FuelConvent(this.litre,this.value, this.desel);
  static ValueNotifier<int> count = ValueNotifier(10);

  void petro(){
    count.value = litre;
  } 
  void deseal(){
    count.value = desel;
  }
}