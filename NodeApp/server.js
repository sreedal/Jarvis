'use strict'
const express = require('express');

const PORT = 8080;
const HOST = '0.0.0.0';
const redis = require('redis');
const Promise = require('bluebird');

const app = express();
let rclient = Promise.promisifyAll(redis.createClient(6379,'redis-store'));
rclient.on('connect', function() {
    console.log('Connected to Redis Server');
});

rclient.on('error', function (err) {
    console.log('Something went wrong ' + err);
});

let value = 0;
//rclient.get("Sreedal", function(err, resp) {
//    value = resp;
//});

async function main(req, res) {
    let value = await rclient.getAsync("Sreedal");
    res.send('Hello world: New: '+value+'\n');
}

app.get('/', (req,res) => {
    main(req,res);
});

app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);