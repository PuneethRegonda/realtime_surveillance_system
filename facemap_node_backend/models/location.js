const mongoose = require('mongoose');

const locationSchema = mongoose.Schema({
    id: { type: Number, require: true},
    name: { type: String, require: true },
    lat: { type: String, require: true },
    long: { type: String, required: true },
    createdAt: { type: Date, required: true, default: Date.now() },
});


module.exports = mongoose.model('locations', locationSchema);