
var ParseServer = require('parse-server').ParseServer;
var api = new ParseServer({
  databaseURI: "mongodb://localhost:27017/parse",
  cloud: __dirname + '/cloud/main.js',
  appId: "HSYwTD8Cz0O2cznV9J7jSCBmdR38X6EF",
  clientKey:  "y5NPYdVS50Ts96N5O0iLrPZlFX7ULy1L",
  publicServerURL: "https://decypher.tk/parse",
  masterKey: "TTadOkX2YU9rdi8nKpO1vO53Dfc3aD73", //Add your master key here. Keep it secret!
  serverURL: "https://decypher.tk/parse"
  // liveQuery: {
  //   classNames: [] // List of classes to support for query subscriptions
  // }
});
// Client-keys like the javascript key or the .NET key are not necessary with parse-server
// If you wish you require them, you can set them as options in the initialization above:
// javascriptKey, restAPIKey, dotNetKey, clientKey

module.exports = api
