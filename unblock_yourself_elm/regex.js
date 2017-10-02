var isValidRegex = function(regex){
  try {
    var _ = new RegExp(regex);
    return { "Ok" : regex };
  } catch (e) {
    return { "Err": e.message };
  }
}

var overwriteControls = function () {
  document.onkeydown = function (e) {
    var kc = e.keyCode;
    if ( kc === 8 || kc === 72 || kc === 74 || kc === 32 || kc === 75 || kc === 76) {
    	return;
    }


    // left, down, H, J, backspace, PgUp - BACK
    // up, right, K, L, space, PgDn - FORWARD
    // enter - FULLSCREEN
    if (kc === 37 || kc === 40 || kc === 8 || kc === 72 || kc === 74 || kc === 33) {
      navigate(-1);
	    } else if (kc === 38 || kc === 39 || kc === 32 || kc === 75 || kc === 76 || kc === 34) {
	      navigate(1);
	    } else if (kc === 13) {
	      toggleFullScreen();
	    }
	} 
}

document.addEventListener('DOMContentLoaded', function(){
	setTimeout(overwriteControls, 100);
});

var restartElm = function(){
    window.location.reload();  
};

var onError = true;
var enableError = function(){
  onError = false;
}

window.onerror = function(error){
  if (onError) return;

  document.write("Runtime error! "+
    "<div height='50px' font-size='100pt' style='font-size:100pt; -webkit-transform: translate(1.1em,0) rotate(90deg); -webkit-transform-origin: 0 0; left:45%; position:relative'>:o>-\<</div>" + 
    "\n\n\n</br></br></br>"+
    "<button onclick='window.location.reload()'>Restart Elm</button></br></br></br>" + 
    "<div color='red' style='font-size:70pt;color: red;'>" + error + "</div>");
}