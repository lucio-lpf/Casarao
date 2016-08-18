
Parse.Cloud.define('addUserToRoom', function(req, res) {

  var roomId = req.params.room;
  var playerId = req.params.player;

  console.log(roomId);
  var gameRoom = Parse.Object.extend("GameRoom");
  var gameQuery = new Parse.Query(gameRoom);
  gameQuery.equalTo("objectId", roomId);
  console.log("fazendo a query");
  gameQuery.find({
   success: function(results) {
       if (results[0].get('players').length < results[0].get('maxPlayers')){
      //    result.get('players').push(player);
      console.log("pode entrar na sala");
      let newUserNumber = results[0].get('maxPlayers') + 1
      results[0].set('maxPlayers', newUserNumber)
      console.log(results[0].get('maxPlayers'));
      var player = Parse.Object.extend("User");
      var playerQuery = new Parse.Query(player);
      playerQuery.equalTo("objectId", playerId);
      player.find({
        success: function(players){
          results[0].get("players").push(players[0])
          res("colocou")
        },
        error:function(){
          res.error("não achou usuario")
        }
      })

      res.success("Pode entrar na sala!")

    }
    else{
        res.error("Sala já esta cheia!");
    }
    },
    error: function(){
    res.error("enable to do query");
    }
 });
});
