


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


Parse.Cloud.define('checkUserMatrix',function(resquest,response){

  var roomId = req.params.room;
  var playerId = req.params.player;



})

Parse.Cloud.define('checkIfUserIsInRoom', function(request,response){

  var roomId = request.params.room;
  var playerId = request.params.player;
  var gameRoom = Parse.Object.extend("GameRoom");
  var gameQuery = new Parse.Query(gameRoom);

  var responseObject = {
    Code:999,
    Messenge:"HAHAHAH"
  }

  gameQuery.equalTo("objectId", roomId);
  console.log("fazendo a query da gameroom");
  gameQuery.get(roomId,{
    success: function(result){
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
    error: function(){
      response.error("Enable to find the room");
    }
  })

})
