class Data{
  int SetMap;
  int O2BP = 0;
  double O2VAL;
  int IdelRPM;
  List<int> MAP1 = [21];
  List<int> MAP2 = [21];
  List<int>  ACC0 = [21];
  List<int>  ACC1 = [21];
  List<int>  ACC2 = [21];
  int RPMslope_ON;
  int RPMslope;

  Data({
        this.SetMap,
        this.O2BP,
        this.O2VAL,
        this.IdelRPM,
        this.MAP1,
        this.MAP2,
        this.ACC0,
        this.ACC1,
        this.ACC2,
        this.RPMslope_ON,
        this.RPMslope
    });
}