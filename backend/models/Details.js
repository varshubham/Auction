const mongoose = require('mongoose')
const {Schema} = mongoose

const DetailSchema = new Schema({
    user:{
        type:mongoose.Schema.Types.ObjectId,
        ref: 'user'
    },
    name:{
        type:String,
        required:true
    },
    pdesc:{
        type:String,
        required:true
    },
    specifications:{
        type:String,
        required :true
    },
    basePrice:{
        type:Number
    },
    duration :{
        type:Number
    },
    contract:{
        type : Object
    },
    date:{
        type:Date,
        default:Date.now
    }
})
const Detail = mongoose.model('detail',DetailSchema);
module.exports = Detail