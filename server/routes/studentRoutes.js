//studentRoutes.js
const express = require('express');
const Student = require('../models/student');
const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const students = await Student.find();
    res.json(students);
  } catch (err) {
    console.error('Error fetching students:', err);
    res.status(500).json({ message: 'Failed to fetch students', error: err.message });
  }
});

router.post('/', async (req, res) => {
  const { firstname, lastname, course, year, enrolled } = req.body;

  if (!firstname || !lastname || !course || !year) {
    return res.status(400).json({ message: 'Required fields are missing' });
  }

  try {
    const newStudent = new Student({
      firstname,
      lastname,
      course,
      year,
      enrolled: enrolled || false,
    });
    await newStudent.save();
    res.status(201).json(newStudent);
  } catch (error) {
    console.error('Error adding student:', error);
    res.status(500).json({ message: 'Failed to add student', error: error.message });
  }
});

router.put('/:id', async (req, res) => {
  try {
      const studentId = req.params.id;
      const updateData = req.body;

      const student = await Student.findById(studentId);
      if (!student) {
          return res.status(404).json({ message: "Student not found" });
      }

      Object.assign(student, updateData);
      await student.save();
      res.status(200).json(student);
  } catch (err) {
      console.error("Error updating student:", err);
      res.status(500).json({ message: "Server error" });
  }
});

router.delete('/:id', async (req, res) => {
  try {
    const student = await Student.findByIdAndDelete(req.params.id);
    if (!student) {
      return res.status(404).json({ message: 'Student not found' });
    }
    res.status(200).json({ message: 'Student deleted successfully' });
  } catch (err) {
    console.error('Error deleting student:', err);
    res.status(500).json({ message: 'Failed to delete student', error: err.message });
  }
});

module.exports = router;
