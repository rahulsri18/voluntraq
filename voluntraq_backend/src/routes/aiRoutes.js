const express = require('express');
const router = express.Router();
const aiController = require('../controllers/aiController');

router.post('/recommend-tasks', aiController.getRecommendedTasks);

module.exports = router;
