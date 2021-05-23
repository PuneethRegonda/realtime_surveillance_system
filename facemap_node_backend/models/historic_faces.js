const mongoose = require('mongoose');

const historic_face_schema= mongoose.Schema({
    current_location: {type: String, require: true, default: ""},
    name: { type: String, required: true },
    createdAt: { type: Date, required: true, default: Date.now()},
});


module.exports = mongoose.model('historic_face', historic_face_schema);