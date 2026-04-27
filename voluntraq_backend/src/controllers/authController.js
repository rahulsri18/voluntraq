const { auth, rtdb } = require('../config/firebase');

exports.register = async (req, res) => {
  const { email, password, name, dob, ngoName, emergencyLevel, role } = req.body;

  try {
    console.log(`Attempting to register user: ${email} as ${role || 'volunteer'}`);
    // 1. Create user in Firebase Auth
    const userRecord = await auth.createUser({
      email,
      password,
      displayName: name,
    });
    console.log(`Auth user created: ${userRecord.uid}`);

    // 2. Store additional info in Realtime Database
    console.log('Attempting to save to Realtime Database...');
    await rtdb.ref('users/' + userRecord.uid).set({
      name,
      email,
      dob,
      ngoName: ngoName || null,
      emergencyLevel: emergencyLevel || null,
      role: role || 'volunteer',
      createdAt: new Date().toISOString(),
    });
    console.log('RTDB data saved.');

    res.status(201).json({
      message: 'User registered successfully',
      uid: userRecord.uid,
    });
    console.log(`User registered successfully: ${email}`);
  } catch (error) {
    console.error('Registration error:', error.message);
    res.status(400).json({ error: error.message });
  }
};

exports.login = async (req, res) => {
  const { email } = req.body;
  console.log(`Attempting login for: ${email}`);
  
  try {
    const user = await auth.getUserByEmail(email);
    console.log(`Found user: ${user.uid}`);
    const snapshot = await rtdb.ref('users/' + user.uid).once('value');
    
    console.log('User data fetched from RTDB');
    res.json({
      uid: user.uid,
      userData: snapshot.val(),
    });
  } catch (error) {
    console.error('Login error:', error.message);
    res.status(401).json({ error: 'User not found or invalid credentials' });
  }
};
