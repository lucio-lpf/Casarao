


Parse.Cloud.define('addUserToRoom', function(request, response) {

  var roomId = request.params.room;
  var playerId = request.params.player;

  var responseObject = {
    Code:999,
    Messenge:"HAHAHAH"
  }
  var gameRoom = Parse.Object.extend("GameRoom");
  var gameQuery = new Parse.Query(gameRoom);

  gameQuery.equalTo("objectId", roomId);
  gameQuery.get(roomId,{

   success: function(result) {

      if (result.get('players').length < result.get('maxPlayers')){
        console.log("tem espaço na sala");
        getUser(playerId).then(
          //When the promise is fulfilled function(user) fires, and now we have our USER!
          function(user){
            console.log("achei usuario");
            var playersCoins = user.get("coins")
            var roomBet = result.get("bet")
            if (playersCoins >= roomBet){
              console.log("ele tem moedas o bastante");

              var newUserArray = result.get("players")
              newUserArray.push(user.id);
              result.set('players', newUserArray)

              var userMatrix = result.get("userMatrix")
              userMatrix[playerId] = [0,0,0,0,0,0,0,0,0];
              var userRightMatrix = result.get("userRightMatrix")
              var userPlayTime = result.get("userPlayTime")
              console.log(userPlayTime, "oi");
              var date = new Date()
              console.log(new Date(date));
              userPlayTime[playerId] = date.getTime() //- (result.get("timer")*1000)
              console.log(userPlayTime[playerId]);
              console.log("continuando function");
              var array = []
              for (x=0;x<9;x++){
                array.push(Math.floor((Math.random() * 3) + 1))
              }
              userRightMatrix[playerId] = array

              result.set("amount", result.get("amount") + roomBet)
              result.save()

              user.set("coins", playersCoins - roomBet)
              user.save()

              responseObject.Code = 0
              responseObject.Messenge = "User is now playing in this room."

              response.success(responseObject);
            }
            else {
              console.log("ele nao tem moedas o bastante");
              responseObject.Code = 1
              responseObject.Messenge = "User haven't enough coins to enter in this room."
              response.success(responseObject);
            }

          },
          function(error){
            responseObject.Code = -1
            responseObject.Messenge = "Unable to find user."
            response.error(responseObject);
          }
        );
    }
    else{
      responseObject.Code = 3
      responseObject.Messenge = "Room is alredy full."
      response.success(responseObject);
    }
    },
    error: function(){
      responseObject.Code = -1
      responseObject.Messenge = "Unable to find room."
      response.error(responseObject);
    }
 });
});

function getUser(userId)
{
    Parse.Cloud.useMasterKey();
    var userQuery = new Parse.Query(Parse.User);
    userQuery.equalTo("objectId", userId);

    //Here you aren't directly returning a user, but you are returning a function that will sometime in the future return a user. This is considered a promise.
    return userQuery.first
    ({
        success: function(userRetrieved)
        {
            //When the success method fires and you return userRetrieved you fulfill the above promise, and the userRetrieved continues up the chain.
            return userRetrieved;
        },
        error: function(error)
        {
            return error;
        }
    });
};

function getRoom(roomId)
{
    Parse.Cloud.useMasterKey();
    var gameRoom = Parse.Object.extend("GameRoom");
    var gameRoomQuery = new Parse.Query(gameRoom);
    gameRoomQuery.equalTo("objectId", roomId);

    //Here you aren't directly returning a user, but you are returning a function that will sometime in the future return a user. This is considered a promise.
    return gameRoomQuery.first
    ({
        success: function(roomRetrieved)
        {
            //When the success method fires and you return userRetrieved you fulfill the above promise, and the userRetrieved continues up the chain.
            return roomRetrieved;
        },
        error: function(error)
        {
            return error;
        }
    });
};


Parse.Cloud.define('checkUserPlayTimer',function(request,response){

    var roomId = request.params.room;
    var playerId = request.params.player;

    var responseObject = {
      Code:999,
      Messenge:"HAHAHAH",
      TimeLeft: 0
    }

    console.log("checando user play time");
    getRoom(roomId).then(


      function(room){
        console.log("achei a sala");
        var date = new Date();
        console.log(date.getTime() - room.get("userPlayTime")[playerId]);
        console.log(room.get('timer')*1000);
        var timeWithoutPlay = date.getTime() - room.get("userPlayTime")[playerId]
        var roomWaitTime = room.get('timer')
        if (timeWithoutPlay >= (roomWaitTime*1000)) {
                console.log("Fazem mais de",room.get('timer') ,"seg, pode editar");
                responseObject.Code = 0
                responseObject.Messenge = "user can play again"
                response.success(responseObject);

        }
        else{
          console.log("user Cant Play");
          responseObject.Code = 1
          responseObject.Messenge = "user can't play again, wait longer"
          responseObject.TimeLeft = roomWaitTime - (timeWithoutPlay/1000)
          response.success(responseObject);
        }
      },
      function(error){

      }


    )


});


Parse.Cloud.define('checkUserMatrix',function(request,response){

  var roomId = request.params.room;
  var playerId = request.params.player;
  var responseObject = {
    Code:999,
    Messenge:"HAHAHAH",
    NewArray:[0,0,0,0,0,0,0,0,0],
    Winner:"guestUser",
    NewRoomObject:null
  }

  getRoom(roomId).then(


      function(room){
          if (room.get("estado") == "playing"){
          var userMatrix = room.get("userMatrix")[playerId]
          var userRightMatrix = room.get("userRightMatrix")[playerId]
          var newUserArray = request.params.playerMatrixArray
          var verify = true
          for (i=0;i<userMatrix.length;i++){
            if (newUserArray[i] == userRightMatrix[i]){
              userMatrix[i] = userRightMatrix[i];
            }
            else{
              userMatrix[i] = 0
              verify = false
            }
          }
          if (verify == true){
            console.log("user ", playerId,"acertou todas a matriz");
            room.set("estado", "finished");
            room.set("winner", playerId);
            creatNewRoom(room)
            responseObject.Code = 1
            responseObject.Messenge = "Parabéns, você venceu o jogo!"

          }
          else{
            console.log("user:", playerId,"ainda nao acertou toda a matriz");
            var userPlayTime = room.get('userPlayTime')
            console.log(userPlayTime);
            var date = new Date()
            userPlayTime[playerId] = date.getTime()
            responseObject.Code = 0
            responseObject.Messenge = "Sua matriz foi corrigida!"
            responseObject.NewArray = userMatrix

          }
          room.save().then(function(newRoom){
              newRoom.fetch().then(
              function(newRoomAtt){
                responseObject.NewRoomObject = newRoomAtt
                response.success(responseObject)

              }

            )
              getUser(playerId).then(

                function(user){

                  user["coins"] = user["coins"] + room["amount"]
                }
              )
          })
          console.log(userPlayTime);q


      }
      else if (room.get("estado") == "waiting"){
        console.log("user:", playerId,"tentou jogar quando a sala ainda nao estava liberada");
        responseObject.Code = 2
        responseObject.Messenge = "Você precisa esperar a sala começar para jogar!"
        esponse.success(responseObject)
      }
      else{
        console.log("user:", playerId,"depois que alguem ja tinha ganho o jogo");

        responseObject.Code = 3
        responseObject.Messenge = "Outro jogador ganhou o jogo!"
        getUser(room.get("winner")).then(
          function(user){
            responseObject.Winner = user.get("nickname")
            response.success(responseObject)
          },
          function(error){
            responseObject.Winner = "guestUser"
            response.success(responseObject)
          }
        )
      }
    },
    function(error){

    }
  )

function creatNewRoom(room){

  console.log("funcção ok");

    // Simple syntax to create a new subclass of Parse.Object.
    var GameRoom = Parse.Object.extend("GameRoom");

    // Create a new instance of that class.
    var newGameRoom = new GameRoom();

    console.log("classes certas");

    newGameRoom.set("roomName", room.get("roomName"));
    newGameRoom.set("players", []);

    var NowDate = new Date();
    var tenminutesDate = new Date(NowDate.getTime() + 600000)
    newGameRoom.set("startTime", tenminutesDate);
    newGameRoom.set("Typer", room.get("Typer"));
    newGameRoom.set("amount", 0);
    newGameRoom.set("bet", room.get("bet"));
    newGameRoom.set("estado", "playing");
    newGameRoom.set("timer", room.get("timer"));
    newGameRoom.set("maxPlayers", room.get("maxPlayers"));
    newGameRoom.set("userPlayTime", {});
    newGameRoom.set("userRightMatrix", {});
    newGameRoom.set("userMatrix", {});

    console.log("atribuicoes certas");

    newGameRoom.save()

    console.log(newGameRoom);



  }
})

 // Parse.Cloud.define('roomScoreTable', function(request.response){
 //
 //
 //
 //
 // })


Parse.Cloud.define('checkIfUserIsInRoom', function(request,response){

  var roomId = request.params.room;
  var playerId = request.params.player;

  var responseObject = {
    Code:999,
    Messenge:"HAHAHAH"
  }

  console.log("fazendo a query da gameroom");
  getRoom(roomId).then(
    function(result){
      console.log('Sala encontrada')
      var players = result.get('players')
      for (i = 0;i<players.length;i++){
          if (players[i] == playerId){
            responseObject["Code"] = 0
            responseObject["Messenge"] = "Player is in the room"
            response.success(responseObject);
            return
          }
      }
      responseObject["Code"] = 1
      responseObject["Messenge"] = "Player is not in the room"
      response.success(responseObject)
    },
    function(error){
      response.error("Enable to find the room");
    }
  )

})

Parse.Cloud.define("myJob", function(request, status) {
  // the params passed through the start request
  console.log("teste");
  status.success()
});
