

class OutPutModel{

  String compileOutput;
  int memory;
  String message;
  Status status;
  String stderr;
  String stdout;
  String time;
  String token;

  OutPutModel({this.compileOutput, this.memory, this.message, this.status,
       this.stderr, this.stdout, this.time, this.token});

  factory OutPutModel.fromMap(response){

    return OutPutModel(
      compileOutput: response['compile_output'],
      memory: response['memory'],
      message: response['message'],
      status: Status.fromJson(response['status']),
      stderr: response['stderr'],
      stdout: response['stdout'],
      time: response['time'],
      token: response['token']
    );
  }
}

class Status{
  int id;
  String description;

  Status({this.id,this.description});

  factory Status.fromJson(response){
    return Status(id: response['id'],description: response['description']);
  }

}