const express = require('express');
const app = express();
const cors = require("cors");
const fs = require('fs');
app.use(express.json());

app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, X-Auth-Token, Content-Type, Accept"
  );
  // res.header("Access-Control-Expose-Headers", "Access-Token", "X-Auth-Token")
  next();
});
app.use(
  cors({
    exposedHeaders: "X-Auth-Token"
  })
);


//load code to prolog file
app.post('/load/',(req,res)=>{
var code = req.body.code;

fs.writeFile('prologFiles/Code.pl', code, err => {
if (err) {
  console.error(err)
  return
}
})
    
  res.send(code)
 
})


//execute query and save result in txt file
app.post('/execute/',(req,res)=>{

  fs.writeFile('./queryResult.txt', "The query is not executed try again", err => {
    if (err) {
      console.error(err)
      return
    }
    })
  var cmd=require('node-cmd');

const processRef=cmd.get('swipl prologFiles/main.pl');
let data_line = '';

var query = req.body.query+"\n";

var or=`;
`;
var and=`.
`;

processRef.stdin.write(query);

processRef.stdout.on(
  'data',
  function(data) {
    var x = data.split("\n")
    data_line += data;
    if (x.length > 1) {
   
      fs.writeFile('./queryResult.txt', data_line, function (err,data) {
        if (err) {
          return console.log(err);
        }
        
        
      }
      );
  } 
   else{
     if(data_line.length<=100000){
processRef.stdin.write(or);

     }
     else{
       console.log("exeeds limit")

      processRef.stdin.write(and);
      alert("this is only part of the solutions as there are too many possible solutions !!")
        
     }
    }
  }
);

res.send("done");
   
})

//get result of query
app.get('/getRes/',(req,res)=>{

  fs.readFile("queryResult.txt", function(err, buf) {
    if(err) res.send("error",err);
    else{
    res.send(buf.toString().replace('Content-type: text/html; charset=UTF-8', ''));
    }
  });

 
})

app.listen(8000,()=>{ console.log("listening on 8000") });










