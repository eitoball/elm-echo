var { Elm } = require('./Main.elm');

var app = Elm.Main.init({ node: document.getElementById('app') });
var chunks = [];
navigator.mediaDevices.getUserMedia({ audio: true, video: false })
  .then(function(stream) {
    var mediaRecorder = new MediaRecorder(stream);
    var audioURL = undefined;
    mediaRecorder.ondataavailable = function(event) {
      chunks.push(event.data);
    };
    mediaRecorder.onstop = function(event) {
      audioURL = URL.createObjectURL(new Blob(chunks));
      app.ports.play_recording.send(audioURL);
    };
    app.ports.start_recording.subscribe(function() {
      if (audioURL) {
        URL.revokeObjectURL(audioURL);
      }
      mediaRecorder.start();
    });
    app.ports.stop_recording.subscribe(function() {
      mediaRecorder.stop();
    });
  })
  .catch(function(error) {
  });
