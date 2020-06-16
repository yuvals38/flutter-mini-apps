class Data{
  int SetMap;
  int O2BP;
  int IdelRPM;
  List<int> MAP1 = [21];
  var MAP2 = [];
  var ACC0 = new List(20);
  var ACC1 = new List(20);
  var ACC2 = new List(20);
  int RPMslope_ON;
  double RPMslope;

  Data({
        this.SetMap,
        this.O2BP,
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