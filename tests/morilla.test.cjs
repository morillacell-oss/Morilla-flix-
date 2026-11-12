"use strict";
const {test} = require("node:test");
const assert = require("node:assert/strict");
const fs = require("node:fs");
const vm = require("node:vm");
const path = require("node:path");
const tmdb = require("../api/tmdb.js");

function response(){
 return {
  statusCode:200,
  headers:{},
  payload:null,
  setHeader(key,value){this.headers[key]=value;return this;},
  status(n){this.statusCode=n;return this;},
  json(value){this.payload=value;return this;}
 };
}
async function run(query,env={},responseData={results:[]}){
 const savedEnv={
  TMDB_API_KEY:process.env.TMDB_API_KEY,
  TMDB_READ_ACCESS_TOKEN:process.env.TMDB_READ_ACCESS_TOKEN,
  TMDB_NONCOMMERCIAL_DEMO:process.env.TMDB_NONCOMMERCIAL_DEMO,
  TMDB_COMMERCIAL_LICENSED:process.env.TMDB_COMMERCIAL_LICENSED
 };
 const oldFetch=global.fetch;
 let called=false;
 try{
  for(const key of Object.keys(savedEnv))delete process.env[key];
  Object.assign(process.env,env);
  global.fetch=async(target)=>{called=true;return {ok:true,status:200,json:async()=>responseData};};
  const res=response();
  await tmdb({method:"GET",query},res);
  return {res,called};
 }finally{
  global.fetch=oldFetch;
  for(const [key,value] of Object.entries(savedEnv)){
   if(value===undefined)delete process.env[key];
   else process.env[key]=value;
  }
 }
}
test("TMDB fica desligado sem autorização ou modo de demonstração", async ()=>{
 const {res,called}=await run({category:"trending"},{TMDB_API_KEY:"a".repeat(32)});
 assert.equal(res.statusCode,503);
 assert.equal(res.payload.code,"LICENSING_REQUIRED");
 assert.equal(called,false);
});
test("TMDB em demo não expõe credenciais e normaliza filmes e séries",async()=>{
 const key="a".repeat(32);
 const responseData={results:[
  {id:100,title:"Filme teste",poster_path:"/safe.jpg",media_type:"movie",vote_average:8.5},
  {id:200,name:"Série teste",backdrop_path:"/tv.jpg",media_type:"tv",vote_average:7.4},
  {id:300,name:"Pessoa",media_type:"person",profile_path:"/profile.jpg"},
  {id:400,title:"Sem foto",media_type:"movie"}
 ]};
 const {res,called}=await run({category:"trending"},{TMDB_API_KEY:key,TMDB_NONCOMMERCIAL_DEMO:"true"},responseData);
 assert.equal(called,true);
 assert.equal(res.statusCode,200);
 assert.equal(res.payload.demo,true);
 assert.equal(res.payload.results.length,2);
 assert.equal(JSON.stringify(res.payload).includes(key),false);
 assert.deepEqual(res.payload.results.map(x=>x.media_type),["movie","tv"]);
});
test("Trailer só retorna identificador válido do YouTube",async()=>{
 const {res}=await run({category:"trailer",media:"movie",id:"101"},
  {TMDB_API_KEY:"a".repeat(32),TMDB_NONCOMMERCIAL_DEMO:"true"},
  {results:[
   {site:"YouTube",type:"Trailer",official:true,key:"AaBbCc12345",name:"Trailer oficial"},
   {site:"YouTube",type:"Trailer",official:false,key:"not-valid"},
   {site:"Vimeo",type:"Trailer",official:true,key:"12345678901"}
  ]});
 assert.equal(res.statusCode,200);
 assert.equal(res.payload.trailers.length,1);
 assert.equal(res.payload.trailers[0].key,"AaBbCc12345");
});
test("IDs de trailer inválidos são rejeitados antes do acesso à API",async()=>{
 const {res,called}=await run({category:"trailer",media:"movie",id:"../../admin"},
  {TMDB_API_KEY:"a".repeat(32),TMDB_NONCOMMERCIAL_DEMO:"true"});
 assert.equal(res.statusCode,400);
 assert.equal(called,false);
});
test("JavaScript do frontend pode ser interpretado e mantém player separado do TMDB",()=>{
 const html=fs.readFileSync(path.join(__dirname,"../index.html"),"utf8");
 const match=html.match(/<script type="module">([\s\S]*?)<\/script>/);
 assert.ok(match);
 assert.doesNotThrow(()=>new vm.Script(match[1]));
 assert.match(html,/function play\(id,episodeId\)/);
 assert.match(html,/function playTmdbTrailer\(key\)/);
 assert.match(html,/function tmdbDetails\(key\)/);
 assert.doesNotMatch(html,/TMDB_API_KEY/);
 assert.match(html,/assets\/cinema-player\.css/);
});
