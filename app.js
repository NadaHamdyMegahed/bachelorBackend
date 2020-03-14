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
fs.writeFile('./code.pl', code, err => {
if (err) {
  console.error(err)
  return
}
})
    
  res.send(code)
 
})

//execute query and save result in txt file
app.post('/execute/',(req,res)=>{
    var cmd=require('node-cmd');
const processRef=cmd.get('swipl code.pl');
let data_line = '';
 
var query = req.body.query+"\n";

var zew=`;
`;

processRef.stdin.write(query);

processRef.stdout.on(
    'data',
    function(data) {
      
      data_line += ":"+data;
      if (data_line[data_line.length-1] == '\n') {
         console.log(data_line);
               //writing the output in  text file
fs.writeFile('./result.txt', data_line, err => {
  if (err) {
    console.error(err)
    return
  }
})
    }
     else{
  processRef.stdin.write(zew);
      }
    }
  );
  
    res.send(query)
   
})

//get result of executed query
app.get('/',(req,res)=>{
  fs.readFile("result.txt", function(err, buf) {
    if(err) res.send("error",err);
    else
    res.send(buf.toString());
  });
})






app.listen(8000,()=>{ console.log("listening on 8000") });





