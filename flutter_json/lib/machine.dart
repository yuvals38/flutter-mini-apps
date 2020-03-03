class Machine {
  
  String machineName;
  String swVersion;
  String startDate;
  String endDate;
  String startTime;
  String endTime;

  //service{"machineName":"8004","swVersion":"4.6.0.106","startDate":"01.09.2019","endDate":"26.10.2019","startTime":null,"endTime":null}

  Machine(String machineName, String swVersion, String startDate,String endDate,String startTime,String endTime ) {
    this.machineName = machineName;
    this.swVersion = swVersion;
    this.startDate = startDate;
    this.endDate = endDate;
    this.startTime = startTime;
    this.endTime = endTime;
  }

  Machine.fromJson(Map json)
      : machineName = json['machineName'],
        swVersion = json['swVersion'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        startTime = json['startTime'],
        endTime = json['endTime'];

  Map toJson() {
    return {'id': machineName, 'name': swVersion, 'email': startDate};
  }
}