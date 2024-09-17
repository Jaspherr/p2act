//student.js
const mongoose = require('mongoose');

const studentSchema = new mongoose.Schema({
  _id: { type: String, default: () => new mongoose.Types.ObjectId().toString() },
  firstname: { type: String, required: true },
  lastname: { type: String, required: true },
  course: { type: String, required: true },
  year: { type: String, required: true },
  enrolled: { type: Boolean, default: false }
});

module.exports = mongoose.model('Student', studentSchema);