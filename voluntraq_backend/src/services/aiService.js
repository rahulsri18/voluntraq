const { GoogleGenerativeAI } = require("@google/generative-ai");
require('dotenv').config();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });

/**
 * Matches a volunteer to the most suitable tasks based on their profile and task descriptions.
 */
exports.matchVolunteerToTasks = async (volunteerProfile, availableTasks) => {
  const prompt = `
    You are VoluntraQ AI, a disaster relief coordination assistant.
    Given the following volunteer profile and a list of available tasks, identify the top 3 best matches.
    
    Volunteer Profile:
    - Name: ${volunteerProfile.name}
    - Skills/Role: ${volunteerProfile.role || 'Volunteer'}
    
    Available Tasks:
    ${availableTasks.map(t => `- [ID: ${t.id}] ${t.title}: ${t.description} (Location: ${t.location}, Urgency: ${t.urgency})`).join('\n')}
    
    Return the response as a JSON array of task IDs only, in order of suitability. 
    Example: ["task_id_1", "task_id_2"]
  `;

  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();
    
    // Extract JSON from the response (sometimes Gemini wraps it in code blocks)
    const jsonMatch = text.match(/\[.*\]/s);
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }
    return [];
  } catch (error) {
    console.error("Gemini AI Error:", error.message);
    return []; // Fallback to empty matching
  }
};
