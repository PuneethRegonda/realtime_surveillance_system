const router = require('express').Router();
const verify = require('../utils/verify_token');

router.get('/',verify,(req, res) => {

    res.json({
        posts: {
            title: 'first',
            description: 'some info about the post'
        },
        user: req.user
    })
});

module.exports = router;