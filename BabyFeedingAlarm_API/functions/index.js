const functions = require('firebase-functions');
const admin = require('firebase-admin');
const secureCompare = require('secure-compare');
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
const timeGap = gap["10sec"];
// const timeGap = gap["20min"];

var payload = {
  notification: {
    title: 'BabyFeedingAlarm',
    body: 'Your are over 20 min.'
  },
  data: { }
};

exports.notifyOverTime = functions.https.onRequest((req, res) => {
  const key = req.query.key;

  if (!secureCompare(key, functions.config().cron.key)) {
    console.log('The key provided in the request does not match the key set in the environment. Check that', key,
        'matches the cron.key attribute in `firebase env:get`');
    res.status(403).send('Security key does not match. Make sure your "key" URL query parameter matches the ' +
        'cron.key environment variable.');
    return null;
  }

  const currentTime = getCurrentTime();
  const fcmTokens = [];

  admin.database().ref('started').orderByChild('initialTime').once('value')
    .then(snap => {
      snap.forEach(childSnap => {
        const initialTimeStr = childSnap.val().initialTime;
        const initialTime = Number(initialTimeStr);
        const timeAfterGap = initialTime + timeGap;

        if (timeAfterGap <= currentTime) {
          if (! childSnap.val().isNotified) {
            const token = childSnap.val().fcmToken;
            fcmTokens.push(token);
            notifyDevices(token, payload);
            updateNotified(childSnap.key, currentTime);
          }
        }

      });

      return null;
    })
    .catch(error => {
      console.log(error);
    });

    res.send();
    return null;
});

const getCurrentTime = () => {
  return Date.now() / 1000 // make it seconds, not ms.
};

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

const updateNotified = (key, currentTime) => {
  const db = admin.database();
  const ref = db.ref("started");
  const timeRef = ref.child(key);
  timeRef.update({
    'isNotified': true,
    'notifiedTime': currentTime
  });
};