const router = require('express').Router();
const User = require('../models/user')
const Token = require('../models/token')
const { registerValidation, loginValidation } = require('../validation')
const bcrypt = require('bcryptjs');
const crypto = require('crypto');
const Location = require("../models/location")
const jwt = require('jsonwebtoken');
const verify_token = require('../utils/verify_token');
const verify_admin = require('../utils/verify_admin');
const ObjectId = require('mongodb').ObjectID;
const History = require('../models/historic_faces');
const sgMail = require("@sendgrid/mail");
const mail = require('@sendgrid/mail');


router.post('/register', async(req, res) => {
    // validation
    const { error } = registerValidation(req.body);
    if (error)
        return res.status(400).send({ status: 'failed', message: error.details[0].message });
    // alreafy exists
    const usernameExist = await User.findOne({ username: req.body.username });
    if (usernameExist) return res.status(400).send({ status: 'failed', message: 'Username already Exists' })
    console.log('bcrypt magic code ');
    // bcrypt magic code 
    const salt = await bcrypt.genSalt(10);
    const hassword = await bcrypt.hash(req.body.password, salt);

    // setting admin/normal user
    let isAdmin = false;
    if (req.body.isAdmin) isAdmin = req.body.isAdmin;

    const newUser = User({
        email: req.body.email,
        username: req.body.username,
        password: hassword,
        isAdmin: isAdmin
    });

    try {
        const savedUser = await newUser.save();
        console.log("generate token");
        // generate token
        // const  auth_token = jwt.sign({_id:user._id,createdAt: Date.now()},process.env.SECRET_TOKEN) 

        // gen verification token and saving that token in db, which will expire in an hour    
        const token = new Token({ _userId: savedUser._id, token: crypto.randomBytes(64).toString('hex') });

        await token.save();

        console.log(token);
        console.log("user registered ");

        res.send({ status: 'success', message: 'Registeration Successful' });
    } catch (err) {
        res.status(400).send(err);
    }
});


router.post('/login', async(req, res) => {
    const { error } = loginValidation(req.body);
    if (error)
        return res.status(400).send({ status: 'failed', message: error.details[0].message });

    // alreafy exists
    const user = await User.findOne({ email: req.body.email });
    if (!user) return res.status(400).send({ status: 'failed', message: 'Email not found' })

    //  valid password 
    const validPass = await bcrypt.compare(req.body.password, user.password);

    // password does not matched
    if (!validPass) return res.status(400).send({ status: 'failed', message: 'username or password not matched' })
    console.log(user._id)

    const auth_token = generateAuthToken(user._id);
    const location = await Location.find();
    return res.header('auth-token', auth_token).send({ status: 'success', message: 'Logged In', data: { "location": location ,"user":{'mail':user.email,'username':user.username,'isadmin':user.isAdmin}}});
});


router.post('/dashboard', verify_token, async(req, res) => {
    const auth_token = generateAuthToken(req.user.id);
    const location = await Location.find();
    const sessionUser = await User.findOne(ObjectId(req.user.id));  
    return res.header('auth-token', auth_token).send({ status: 'success', message: 'Logged In', data: { "location": location,"user":{'mail':sessionUser.email,'username':sessionUser.username,'isadmin':sessionUser.isAdmin}  } });
});

function generateAuthToken(userID) {
    //  expires in one day
    return jwt.sign({ id: userID}, process.env.SECRET_TOKEN, { expiresIn: '1d' });
}

router.post('/mail', verify_admin, async(req, res) => {

    console.log("IN group mail");
    console.log(req.body); 
    mailOptions  = {
        "to":"puneethregonda1291@gmail.com",
        "from":"ADMIN <17211a1291@bvrit.ac.in>",
        "subject":req.body.subject,
        "text": req.body.text,
    };
    // const mailList = req.body.userlist;
    const mailList = req.body.userlist;

    for (let index = 0; index < mailList.length; index++) {
        mailList[index]= mailList[index]+"@bvrit.ac.in";
    }
    console.log(mailList);
    
    sgMail.setApiKey(process.env.GRID_API);

    const msg = {
        to: mailList,
        "from":"ADMIN <17211a1291@bvrit.ac.in>",
        "subject":req.body.subject,
        "text": req.body.text,
      };

      sgMail.sendMultiple(msg).then((r)=>{
          console.log("Sent Mails");
        return res.send({"status": true,"data":{},"message":"Email Sent"});
      });    
});


router.get('/check_history', verify_token, async(req, res) => {
    // console.log(req);
    console.log(req.name);

    const history = await History.find({"name":req.name});4
    const data = {};
     history.forEach((value)=>{
         console.log(value);
         const key_ = value.get("createdAt").toISOString().split('T')[0];
         const time_ = value.get("createdAt").toISOString().split('T')[1];
         if(data[key_]){
            data[key_] = [...data[key_], {'location':value.current_location,'time': time_}]
         }else{
            data[key_] = [{'location':value.current_location,'time': time_}];
         }
     });
     console.log(data);

    return res.send({ status: 'success', message: 'Success History feteched', data: { "history":  data} });
});

module.exports = router;