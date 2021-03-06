const mongoose = require('mongoose');

const tokenSchema = mongoose.Schema({
    _userId: { type: mongoose.Schema.Types.ObjectId, required: true },
    token: { type: String, required: true },
    createdAt: { type: Date, required: true, default: Date.now(), expires: 60 * 60 }
});

module.exports = mongoose.model('verification_token', tokenSchema);
