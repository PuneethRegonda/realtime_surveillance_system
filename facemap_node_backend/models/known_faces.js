const mongoose = require('mongoose');

const faces_schema= mongoose.Schema({
    current_location: {type: String, require: true, default: ""},
    last_location: {type: String, require: true,default:""},
    name: { type: String, required: true,unique:true},
    createdAt: { type: Date, required: true, default: Date.now()},
});


module.exports = mongoose.model('known_faces', faces_schema);
