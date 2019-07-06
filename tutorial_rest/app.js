var express = require('express');
var bodyParser = require('body-parser');
var _ = require('underscore');
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
    let users = {};
    fs.readFile(file_path, 'utf8', function (err, data) {
        users = JSON.parse(data);
        qtdUsers = _.size(users);
        newID = "user" + (qtdUsers+1);
        users[newID] = {
            id: newID,
            name: req.body.name,
            password: req.body.password,
            profession: req.body.profession
        };
        newData = JSON.stringify(users);
        fs.writeFile(file_path, newData, 'utf8', function (err) {
            if (err) {
                console.log("Erro ao adicionar usuário!");
                console.log(err);
                res.send(500);
            }
        });
    });

    res.end(`Successo! ${req.body.name} adicionado à lista de usuários!`)
});

app.get('/user/:id', function (req, res) {

    fs.readFile(file_path, 'utf8', function (err, data) {
        data = JSON.parse( data );
        var user = data["user" + req.params.id];
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