const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.printOut = functions.database.ref('/started/{uid}').onCreate((snapshot, context) => {
  const val = snapshot.val();
  if (!val) {
    console.log(`val is ${val}`)
  }
  const uid = context.params.uid;
  if (!uid) {
    console.log(`uid is ${uid}`)
  }

  console.log(`Started ! (val: ${val} | uid: ${uid})`);
});
