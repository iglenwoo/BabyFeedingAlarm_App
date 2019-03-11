const functions = require('firebase-functions');
const admin = require('firebase-admin');
var serviceAccount = require('./private/key.json');
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://babyfeedingalarm.firebaseio.com"
});

const gap = {
  '10sec': 10,
  '30sec': 30,
  '5min': 300,
  '20min': 1200
};
var payload = {
  notification: {
    title: 'Stop Feeding',
    body: 'Your are over 20 min.'
  },
  data: { }
};

exports.notifyOverTime = functions.https.onRequest((req, res) => {
  const currentTime = new Date().getTime() / 1000; // make it seconds, not ms.
  console.log(`currentTime: ${currentTime}`);
  const fcmTokens = [];

  admin.database().ref('started').orderByChild('initialTime').once('value')
    .then(snap => {
      snap.forEach(childSnap => {
        console.log(childSnap.val());
        const token = childSnap.val().fcmToken;
        fcmTokens.push(token)
      });

      return fcmTokens;
    })
    .then(tokens => {
      tokens.forEach(token => {
        notifyDevices(token, payload);
      });

      res.send(JSON.stringify(fcmTokens));

      return;
    })
    .catch(error => {
      console.log(error);
    });

    // res.send(JSON.stringify(fcmTokens));
});

const notifyDevices = (token, payload) => {
  admin.messaging().sendToDevice(token, payload)
    // .then(response => {
    //     console.log('Successfully sent message:', response);
    //     return;
    // })
    .catch(error => {
        console.log('Error sending message:', error);
    });
};