const functions = require('firebase-functions');
const admin = require('firebase-admin');
var serviceAccount = require('./private/key.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://babyfeedingalarm.firebaseio.com"
});

const gap = {
  '10sec': 10000,
  '30sec': 30000,
  '5min': 300000,
  '10min': 600000
};
var payload = {
  notification: {
    title: 'This is title',
    body: 'Test from Functions'
  },
  data: { }
};

exports.notifyOverTime = functions.https.onRequest((req, res) => {
  const currentTime = new Date().getTime();
  const overTime = currentTime - gap["30sec"];
  const fcmTokens = [];

  admin.database().ref('started').orderByChild('initialTime').startAt(overTime).once('value')
      .then(snap => {
        snap.forEach(childSnap => {
          const token = childSnap.val().fcmToken;
          fcmTokens.push(token)
        });
        console.log(`Tokens: ${fcmTokens}`);

        return fcmTokens;
      })
      .then(tokens => {
        tokens.forEach(token => {
          // payload.body = `body: ${token}`;
          console.log(`sent a noti to ${token} with\n${payload.body}`);

          admin.messaging().sendToDevice(token, payload)
          // .then(response => {
          //   console.log('Successfully sent message:', response);
          //   return;
          // })
          // .catch(error => {
          //   console.log('Error sending message:', error);
          // })
        });

        res.send(JSON.stringify(fcmTokens));

        return;
      })
      .catch(error => {
        console.log(error);
      });

    // res.send(JSON.stringify(fcmTokens));
});