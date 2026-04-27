const { rtdb } = require('../config/firebase');
const { matchVolunteerToTasks } = require('../services/aiService');

exports.getRecommendedTasks = async (req, res) => {
  const { userId } = req.body;

  try {
    // 1. Fetch Volunteer Profile
    const userSnapshot = await rtdb.ref('users/' + userId).once('value');
    const volunteerProfile = userSnapshot.val();

    if (!volunteerProfile) {
      return res.status(404).json({ error: 'Volunteer not found' });
    }

    // 2. Fetch Available Tasks
    const tasksSnapshot = await rtdb.ref('tasks').once('value');
    const tasksData = tasksSnapshot.val() || {};
    const availableTasks = Object.keys(tasksData).map(key => ({ id: key, ...tasksData[key] }));

    // 3. Use AI to match
    const matchedIds = await matchVolunteerToTasks(volunteerProfile, availableTasks);

    // 4. Return the full task objects for the matches
    const recommendations = availableTasks.filter(t => matchedIds.includes(t.id));

    res.json(recommendations);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
