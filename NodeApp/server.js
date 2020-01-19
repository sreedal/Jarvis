'use strict'
const express = require('express');

const PORT = 8080;
const HOST = '0.0.0.0';
const redis = require('redis');
const Promise = require('bluebird');
const path = require('path');
//const logger = require('morgan');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');

const app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

//app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

var guid = require('uuid/v4');

let rclient = Promise.promisifyAll(redis.createClient(6379,'redis-store'));
rclient.on('connect', function() {
    console.log('Connected to Redis Server');
});

rclient.on('error', function (err) {
    console.log('Something went wrong ' + err);
});

let value = "{\"tasks\": [{\"Timestamp\": 1575752793.033858, \"Title\": \"Sreedal\", \"Summary\": \"Sreedal Summary\", \"Link\":\"http://github.io/sreedal\"},{\"Timestamp\": 1575752793.033858, \"Title\": \"Radhika\", \"Summary\": \"Radhika Summary\", \"Link\":\"http://github.io/radhika\"}]}";
rclient.get("Sreedal", function(err, resp) {
    value = resp;
});

async function main(req, res) {
    let key = "LatestNews";
    if(req.query.set)
    {
        key = req.query.set;
    }

    let value = await rclient.getAsync(key);
    let JSONValue = JSON.parse(value);
    //let JSONValue = JSON.parse("{\"tasks\": [{\"Timestamp\": 1575752793.033858, \"Title\": \"Sreedal\", \"Summary\": \"Sreedal Summary\", \"Link\":\"http://github.io/sreedal\"},{\"Timestamp\": 1575752793.033858, \"Title\": \"Radhika\", \"Summary\": \"Radhika Summary\", \"Link\":\"http://github.io/radhika\"}]}");
    //res.send('Hello world: News: '+JSONValue+'\n');
    if(req.query.set)
    {
        res.render('indexList',JSONValue);
    }
    else
    {
        res.render('index',JSONValue);
    }
}

const { Kafka } = require('kafkajs');

const kafka = new Kafka({
  clientId: 'jarvis-node',
  brokers: ['broker:9092']
});
const producer = kafka.producer();

app.get('/click', (req,res) => {
    var uuid = guid();
    if(undefined === req.cookies.JUID){
        res.cookie('JUID', uuid, { maxAge: 900000, httpOnly: true });
    } else {
        uuid = req.cookies['JUID'];
    }

    var message = {Type: 'Click', User: uuid, Timestamp: Date.now(),Title: req.query.article, Link: req.query.link };
    //res.send(decodeURI(req.query.link));
    res.writeHead(302, {
        'Location': decodeURI(req.query.link)
    });
    res.end();

    producer.connect();
    producer.send({
        topic: 'click',
        messages: [
            { value: JSON.stringify(message) },
        ],
    });
    producer.disconnect();
});
var lastView = Date.now();
var lastMessage = "";

app.get('/view', (req,res) => {
    var uuid = guid();
    if(undefined === req.cookies.JUID){
        res.cookie('JUID', uuid, { maxAge: 900000, httpOnly: true });
    } else {
        uuid = req.cookies['JUID'];
    }

    var currentView = Date.now();

    var message = {Type: 'View', User: uuid, Timestamp: Date.now(),Title: req.query.article, Link: req.query.link };
    res.end();
    //if((currentView-lastView)>=1000){ //Consider Viewed only if 1s of screen time on article
        producer.connect();
        lastMessage['Delay']=(currentView-lastView);
        producer.send({
            topic: 'click',
            messages: [
                { value: JSON.stringify(lastMessage) },
            ],
        });
        producer.disconnect();
    //}
    lastView = currentView;
    lastMessage = message;
});

app.get('/info', (req,res) => {
    var uuid = guid();
    if(undefined === req.cookies.JUID){
        res.cookie('JUID', uuid, { maxAge: 900000, httpOnly: true });
    } else {
        uuid = req.cookies['JUID'];
    }
    main(req,res);
});

app.set('view engine', 'jade')

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);