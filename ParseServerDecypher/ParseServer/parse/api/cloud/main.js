


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
              newUserArray.push(user);
              result.set('players', newUserArray)

              var userMatrix = result.get("userMatrix")
              userMatrix[playerId] = [0,0,0,0,0,0,0,0,0];
              var userRightMatrix = result.get("userRightMatrix")
              var array = []
              for (x=0;x<9;x++){
                array.push(Math.floor((Math.random() * 3) + 1))
              }
              userRightMatrix[playerId] = array
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



Parse.Cloud.define('checkUserMatrix',function(request,response){

  var roomId = request.params.room;
  var playerId = request.params.player;
  var responseObject = {
    Code:999,
    Messenge:"HAHAHAH",
    NewArray:[0,0,0,0,0,0,0,0,0],
    Winner:"guestUser"
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
            room.set("estado", "finished");
            room.set("winner", playerId);
            responseObject.Code = 1
            responseObject.Messenge = "Parabéns, você venceu o jogo!"

          }
          else{
            responseObject.Code = 0
            responseObject.Messenge = "Sua matriz foi corrigida!"
            responseObject.NewArray = userMatrix

          }
          room.save()

          response.success(responseObject)
      }
      else if (room.get("estado") == "waiting"){
        responseObject.Code = 2
        responseObject.Messenge = "Você precisa esperar a sala começar para jogar!"
        esponse.success(responseObject)
      }
      else{
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




})

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
          if (players[i].id == playerId){
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
