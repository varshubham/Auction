const mongoose = require('mongoose')
const {Schema} = mongoose;

const DataSchema = new Schema({
    user:{
        type:mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
    fname:{
        type: String,
        required : true
    },
    lname:{
        type:String,
        required : true
    },
    aadhar:{
        type:Number,
        required:true
    },
    age:{
        type:Number,
        required:true
    },
    gender:{
        type:String,
        required:true
    },
    phonenumber:{
        type:Number,
        required:true
    },
    pan:{
        type:String,
        required:true
    },
    date:{
        type:Date,
        default:Date.now
    }

})
const Data=mongoose.model('data',DataSchema)
// User.createIndexes();
module.exports = Data