const admin = require('firebase-admin');

// Note: You must place your serviceAccountKey.json in the root of voluntraq_backend
// or set the GOOGLE_APPLICATION_CREDENTIALS environment variable.

let db;
let auth;
let rtdb;

try {
  const serviceAccount = require('../../serviceAccountKey.json');
  const projectId = serviceAccount.project_id || process.env.FIREBASE_PROJECT_ID;
  
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: `https://${projectId}-default-rtdb.firebaseio.com/`
  });
  console.log(`Firebase Admin initialized for project: ${projectId}`);
  db = admin.firestore();
  auth = admin.auth();
  rtdb = admin.database();
} catch (error) {
  console.error('Firebase Admin initialization failed:', error.message);
  console.log('Backend will run in MOCK MODE for Firebase services.');
  db = null; 
  auth = null;
  rtdb = null;
}

module.exports = { admin, db, auth, rtdb };
