//student.js
const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  firstname: { type: String, required: true },
  lastname: { type: String, required: true },
  course: { type: String, required: true },
  year: { type: String, required: true },
  enrolled: { type: Boolean, default: false }
});

module.exports = mongoose.model('Student', studentSchema);