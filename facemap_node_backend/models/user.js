const mongoose = require('mongoose');


const userSchema  = mongoose.Schema({
    email:{
        type: String,
        max: 255,
        required: true,
    },
    username:{
        type: String,
        max: 255,
        required: true,
    },
    password:{
        type:String,
        max: 255,
        required:true
    },
    isAdmin:{
        type: Boolean,
        required:true,
    }
});


module.exports = mongoose.model('User',userSchema);
