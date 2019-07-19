function includeSrc(sf) {
  //console.log("File to include is " + sf);
  var scrptE = document.createElement("script");
  scrptE.setAttribute("type", "text/javascript");
  scrptE.setAttribute("src", sf+"?v=" + Math.random());
  document.getElementsByTagName("head")[0].appendChild(scrptE);
} //
