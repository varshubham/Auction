const express = require('express')
const router = express.Router();
const fetchuser = require('../middleware/fetchuser');
const Detail = require('../models/Details')
const multer = require('multer')

const multerStorage = multer.diskStorage({
    destination:(req,file,cb)=>{
        cb(null,"public")
    },
    filename:(req,file,cb)=>{{
        const ext = file.mimetype.split('/')[1];
        cb(null,`admin-${file.fieldname}-${Date.now()}.${ext}`)
    }}
})
router.post('/fetchall', fetchuser, async (req, res) => {
    try {
        const notes = await Detail.find({ user: req.user.id })
        res.json(notes)
    } catch (error) {
        res.status(500).send("Internal Server error")
    }
})
const uploadlocal = multer({storage:multerStorage})
router.post('/adddetail',uploadlocal.single("imgname"),fetchuser,async(req,res)=>{
    try{
        const {pdesc,specifications,basePrice,duration,contract,name } = req.body
        console.log(req.file)
        const note = new Detail({
            pdesc,specifications,basePrice,duration,contract,name, user: req.user.id
        })
        const savedNote = await note.save();

        res.json(savedNote)
   
    } catch (error) {
        res.status(500).send("Internal Server error")
    }
})
module.exports = router