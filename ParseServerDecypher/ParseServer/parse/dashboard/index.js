var ParseDashboard = require('parse-dashboard');

let serverURL = "http://localhost:3000/parse"
if (process.env.NODE_ENV == 'production') {
  serverURL = 'https://decypher.tk/parse'
}
var dashboard = new ParseDashboard({
  "apps": [
    {
      "serverURL": serverURL,
      "appId": "HSYwTD8Cz0O2cznV9J7jSCBmdR38X6EF",
      "masterKey": "TTadOkX2YU9rdi8nKpO1vO53Dfc3aD73",
      "clientKey":  "y5NPYdVS50Ts96N5O0iLrPZlFX7ULy1L",
      "appName": "Decypher"
    }
  ],
  "users": [
    {
      "user": "user",
      "pass": "58WBog8g61"
    }
  ]
});

module.exports = dashboard
