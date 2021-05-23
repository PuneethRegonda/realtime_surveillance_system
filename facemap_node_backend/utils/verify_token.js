
const jwt = require('jsonwebtoken');

module.exports = function(req, res, next) {
    const token = req.header('auth-token');

    if (!token) {
        return res.status(401).json({ status: 'failed', message: 'Access Denied' });
    }

    try {
        const verified = jwt.verify(token, process.env.SECRET_TOKEN);
        // console.log(token);
        // console.log(verified);
        if (verified.id == null) {
            // db.test.find(ObjectId("4ecc05e55dd98a436ddcc47c"))  
            res.status(403).json({ status: 'failed', message: 'Invalid token' });
            return;
        }
        // console.log("verifed");
        if(req.header("nm")) {
            // for check_history route
            req.name = req.header("nm")
            console.log(req.name);
        }
        
        req.user = verified;
        // console.log(req);
        next();
    } catch (err) {
        if (err.name.includes('TokenExpiredError')) {
            res.status(401).json({ status: 'failed', message: 'Access-Token Expired' });
            return;
        }
        console.log(err);
        res.status(500).json({ status: 'failed', message: 'Internal server error' });
    }
}