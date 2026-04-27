const { rtdb } = require('../config/firebase');

exports.getTasks = async (req, res) => {
  try {
    if (!rtdb) {
      // Mock data if RTDB is not initialized
      return res.json([
        { id: '1', title: 'Medical Supply Delivery', location: 'Section A-12', urgency: 'High', status: 'Available' },
        { id: '2', title: 'Shelter Setup', location: 'Main Plaza', urgency: 'Medium', status: 'Available' },
      ]);
    }
    
    const snapshot = await rtdb.ref('tasks').once('value');
    const tasksData = snapshot.val() || {};
    const tasks = Object.keys(tasksData).map(key => ({ id: key, ...tasksData[key] }));
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.createTask = async (req, res) => {
  const { title, description, location, urgency } = req.body;
  try {
    if (!rtdb) {
      return res.status(201).json({ message: 'Task created (Mock Mode)', id: 'mock-id' });
    }
    
    const newTaskRef = rtdb.ref('tasks').push();
    await newTaskRef.set({
      title,
      description,
      location,
      urgency,
      status: 'Available',
      createdAt: new Date().toISOString(),
    });
    
    res.status(201).json({ id: newTaskRef.key });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
