var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var fs = require("fs");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const file_path = __dirname + "/" + "users.json";

app.get('/listUsers', function (req, res) {
    fs.readFile(file_path, 'utf8', function (err, data) {
        res.json(JSON.parse(data));
        res.end(data);
    });
});

app.post('/addUser', function (req, res) {

    console.log(req.query);

    fs.readFile(file_path, 'utf8', function (err, data) {
        data = JSON.parse(data);
        // data["user4"] = JSON.parse(req.body);
        data["user4"] = req.body;
        console.log( req.body.name );
        console.log( req.body.password );

        res.end( JSON.stringify(data));
    });
});

app.get('/user/:id', function (req, res) {

    fs.readFile(file_path, 'utf8', function (err, data) {
        data = JSON.parse( data );
        var user = data["user" + req.params.id]
        console.log( user );
        res.end( JSON.stringify(user));
    });
});

app.delete('/deleteUser/:id', function (req, res) {
    fs.readFile(file_path, 'utf8', function (err, data) {
        data = JSON.parse( data );
        delete data["user" + req.params.id];

        console.log( data );
        res.end( JSON.stringify(data));
    });
});

var server = app.listen(8081, function () {
    var host = server.address().address;
    var port = server.address().port;

    console.log("REST tutorial app listening at http://%s:%s", host, port)
});