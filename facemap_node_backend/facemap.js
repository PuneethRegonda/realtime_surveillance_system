const express = require("express")
const app = express()
const mongoose = require('mongoose')
const dotenv = require('dotenv')
const KnownFaces = require('./models/known_faces')
const HistoricFaces = require('./models/historic_faces')
const Locations = require('./models/location')

// import Routes
const Router = require('./routes/auth')
const postRouter = require('./temp/post')


dotenv.config();

// connect to DB 
mongoose.connect(
    // process.env.DB_CONNECT,
    'mongodb://localhost:27017/local',
     { useUnifiedTopology: true, useNewUrlParser: true, useCreateIndex: true },
    (error) => {
        if (error) {
            console.log('Unable to connect to db');
            console.log(error);
        } else {
            console.log(`connected to db:`);
        }
    });


const allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', '*');
    res.header('Access-Control-Allow-Headers', '*');
    res.header('Access-Control-Expose-Headers', 'Auth-Token, Refresh-Token');
    next();
}


app.use(allowCrossDomain);

// MiddleWares
app.use(express.json());
app.use(express.urlencoded({ extended: true }))


app.use(express.static(__dirname + '/public'));
app.use((req, res, next) => {
    console.log(`Request: ${req.method} ${req.url} ${Date.now()}`);
    next();
})

// Route middleware 
app.use('/api/user/', Router);
app.use('/api/posts/', postRouter);



// app.listen(1291, ()=>console.log("facemap node server running"));

const http = require('http').createServer(app);

const port = process.env.PORT || 1291;

http.listen(port, () =>
    console.log(`Listening on port ${port}!`));

// socket initializing 
const io = require('socket.io')(http);

const facemapNSP = io.of('/facemap');

console.log(io.path())
console.log(facemapNSP.name)

const locations = Locations.find();
// console.log(locations);

// if (!locations) {
//     console.log("locations adding")
// }

// addLocations();

async function addLocations() {

    const places = {
        "Dosa point": [17.724984, 78.255608,0],
        "Library": [17.726076, 78.256657,1],
        "Swami Vivekananda Boys Hostel": [17.724278, 78.253900,2],
        "Mahatma Gandhi Statue": [17.725062, 78.254761,3],
        "C V Raman Boys Hostel": [17.725029, 78.257177,4],
        "Aryabatta Block(IT)": [17.724094, 78.255221,5],
        "Tea Point": [17.724225, 78.254221,6]
    }

    for (const [key, vlaue] of Object.entries(places)) {
        console.log(key, vlaue);
        const l = Locations({
            name: key,
            lat: vlaue[0],
            long: vlaue[1],
            id: vlaue[2],
            createdAt: Date.now()   
        });
        await l.save();
    }
    console.log("locations added")
}

facemapNSP.on('connection', async function(socket) {

    console.log(`A device connected to facemap`);
    // console.log(socket.request.headers);

    //  pull out the persons last found today and send them.

    // const historic_faces = await HistoricFaces.find({ "createdAt": { $gt: new Date(Date.now() - 24 * 60 * 60 * 1000) } })
    const historic_faces = await HistoricFaces.find().limit(20)
        // console.log(historic_faces);
    socket.emit("old_faces", historic_faces);

    socket.on('push_faces', async(message) => {

        // we need to get known_faces, and create a historic face and 
        // push them to db,

        if (message == null || message == null || message.name == null || message.location == null) {
            socket.emit("param_error", { "status": "undefined required params" })
        } else {
            const known_faces = await KnownFaces.findOne({ name: message.name });
            if (!known_faces) {
                const new_known_face = KnownFaces({
                    current_location: message.location,
                    last_location: message.location,
                    name: message.name,
                    createdAt: Date.now(),
                });
                await new_known_face.save();
            } else {
                known_faces.last_location = known_faces.current_location;
                known_faces.current_location = message.location;
                await known_faces.save();
            }
            var dateq = new Date();
            const old_historic_face = await HistoricFaces.findOne({
                name: message.name,
                createdAt: { $gt: new Date(dateq.getTime() - 3 * 60 * 1000) }
            });

            if (old_historic_face == null) {
                const historic_face = HistoricFaces({
                    current_location: message.location,
                    name: message.name,
                    createdAt: Date.now()
                });
                await historic_face.save();
            } else {
                old_historic_face.current_location = message.location;
                old_historic_face.createdAt = Date.now();
                await old_historic_face.save();
            }
            
            console.log("pushed faces");
            console.log(message);
            io.of('/facemap').emit('new_faces', known_faces);

        }
    })

    socket.on('imageUpload', async (message) => {
        console.log('image is uploaded');
    });

    socket.on('disconnect', function() {
        console.log('A user disconnected from facemap');
    });
});
