(function(){ //Functions to run after the script tag has loaded
var filepickerLoadCallback = function(){
  filepicker.setKey("AE9TtsKF3Qpe70XHExHegz");
};

//If the script doesn't load
var filepickerErrorCallback = function(error){
    if(typeof console != undefined) {
        console.log(error);
    }
};

//Generate a script tag
var script = document.createElement('script');
script.type = 'text/javascript';
script.src = '//api.filepicker.io/v1/filepicker.js';
script.onload = filepickerLoadCallback;
script.onerror = filepickerErrorCallback;

//Load the script tag
var head = document.getElementsByTagName('head')[0];
head.appendChild(script);


}).call(this);