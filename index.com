<meta name='viewport' content='width=device-width, initial-scale=1'/><meta name='viewport' content='width=device-width, initial-scale=1'/>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>User Dashboard</title>
<style>
  @import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@500&display=swap');

  body {
    background:#0a0a0f;
    font-family:'Orbitron', Arial, sans-serif;
    color:#00ffe7;
    display:flex;
    justify-content:center;
    align-items:center;
    height:100vh;
    margin:0;
  }

  .dashboard {
    background:#151522;
    padding:40px;
    border-radius:16px;
    text-align:center;
    width:400px;
    box-shadow: 0 0 30px rgba(0,255,231,0.5);
  }

  h1 {
    margin-bottom:10px;
    font-size:28px;
    color:#00ffe7;
  }

  .info {
    margin:15px 0;
    font-size:18px;
  }

  .time {
    margin:20px 0;
    font-size:20px;
    color:#ffbf00;
  }

  button {
    margin-top:20px;
    padding:14px 30px;
    border:none;
    border-radius:10px;
    background:linear-gradient(90deg,#00ffe7,#0077ff);
    font-weight:bold;
    cursor:pointer;
    color:#000;
    font-size:18px;
    transition: 0.3s;
  }

  button:disabled {
    background:#555;
    cursor:not-allowed;
    color:#aaa;
  }

  button:hover:not(:disabled){
    transform: scale(1.05);
  }
</style>
<script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/9.23.0/firebase-database-compat.js"></script>
</head>
<body>
<div class="dashboard">
  <h1>Welcome, <span id="username">User</span></h1>
  <div class="info">Device: <span id="device"></span></div>
  <div class="info">Expiry: <span id="expiry"></span></div>
  <div class="time">Time Left: <span id="timeLeft"></span></div>
  <button id="startGameBtn">Open hack</button>
</div>

<script>
const firebaseConfig = {
    apiKey: "AIzaSyCxMNehwUXEkKqAZdhmKIzA_YXUmyxJcKw",
    authDomain: "fir-ae785.firebaseapp.com",
    databaseURL: "https://fir-ae785-default-rtdb.firebaseio.com",
    projectId: "fir-ae785",
    storageBucket: "fir-ae785.firebasestorage.app",
    messagingSenderId: "359161411574",
    appId: "1:359161411574:web:56a80c2e22fd86c9a2b9d7",
  };
firebase.initializeApp(firebaseConfig);
const db = firebase.database();

// Replace with proper login system
let loggedInUsername = prompt("Enter your username:");

db.ref("users").orderByChild("username").equalTo(loggedInUsername).once("value", snap => {
  if(snap.exists()){
    snap.forEach(c=>{
      let u = c.val();
      document.getElementById("username").innerText = u.username;
      document.getElementById("device").innerText = u.device;
      let expiryDate = new Date(u.expiry);
      document.getElementById("expiry").innerText = expiryDate.toLocaleString();

      // Countdown timer
      const timeEl = document.getElementById("timeLeft");
      const btn = document.getElementById("startGameBtn");

      function updateTimer(){
        let now = new Date();
        let diff = expiryDate - now;
        if(diff <=0){
          timeEl.innerText = "Expired";
          btn.disabled = true;
          clearInterval(timerInterval);
        } else {
          let days = Math.floor(diff / (1000*60*60*24));
          let hours = Math.floor((diff % (1000*60*60*24)) / (1000*60*60));
          let minutes = Math.floor((diff % (1000*60*60)) / (1000*60));
          let seconds = Math.floor((diff % (1000*60)) / 1000);
          timeEl.innerText = `${days}d ${hours}h ${minutes}m ${seconds}s`;
        }
      }

      updateTimer();
      let timerInterval = setInterval(updateTimer, 1000);

      // Start Game button action - Open Telegram link
      btn.addEventListener("click", ()=>{
        window.open("vip 3page .html","_blank");
      });
    });
  } else {
    alert("User not found!");
  }
});
</script>
</body>
</html>
