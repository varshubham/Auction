const express = require('express')
const router = express.Router();
const fetchuser = require('../middleware/fetchuser');
const Data = require('../models/Data')

router.post('/fetchallnotes', fetchuser, async (req, res) => {
    try {
        const notes = await Data.find({ user: req.user.id })
        res.json(notes)
    } catch (error) {
        res.status(500).send("Internal Server error")
    }
})

router.post('/adddata', fetchuser ,async (req, res) => {
    try {
        const { fname,lname,aadhar,age,gender,phonenumber,pan } = req.body
        const note = new Data({
            fname,lname,aadhar,age,gender,phonenumber,pan, user: req.user.id
        })
        const savedNote = await note.save();

        res.json(savedNote)
    } catch (error) {
        res.status(500).send("Internal Server error")
    }
})
module.exports = router