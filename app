<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no"/>
<title>δ Delta Miner (Pi dApp)</title>

<!-- Pi SDK -->
<script src="https://sdk.minepi.com/pi-sdk.js"></script>

<script>
Pi.init({ version: "2.0" });
</script>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: system-ui;
    user-select: none;
}

body {
    height: 100vh;
    display: flex;
    flex-direction: column;
    background: radial-gradient(circle at top, #1a0f00, #000);
    color: white;
    overflow: hidden;
}

/* HEADER */
header {
    text-align: center;
    padding: 10px 8px;
}

#coin {
    font-size: 2.2rem;
    font-weight: bold;
    color: #fb923c;
    text-shadow: 0 0 20px rgba(251,146,60,0.5);
}

#rate {
    font-size: 0.9rem;
    opacity: 0.8;
    color: #fdba74;
}

/* MAIN */
main {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    position: relative;
}

#mineBtn {
    width: min(65vw, 220px);
    height: min(65vw, 220px);
    border-radius: 50%;
    border: 2px solid #fb923c;
    background: radial-gradient(circle, #7c2d12, #000);
    color: #fb923c;
    font-size: 1rem;
    font-weight: bold;
    box-shadow: 0 0 40px rgba(251,146,60,0.25);
}

#mineBtn:active {
    transform: scale(0.93);
}

/* FLOAT */
.float {
    position: absolute;
    color: #fbbf24;
    font-weight: bold;
    animation: floatUp 0.7s ease-out forwards;
    pointer-events: none;
    font-size: 0.9rem;
}

@keyframes floatUp {
    0% { opacity: 1; transform: translateY(0); }
    100% { opacity: 0; transform: translateY(-70px); }
}

/* SHOP */
#shop {
    background: rgba(20,10,0,0.92);
    border-top: 1px solid #7c2d12;
    padding: 8px;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
}

.upgrade {
    background: rgba(30,15,5,0.85);
    border-radius: 10px;
    padding: 8px;
    font-size: 0.75rem;
    display: flex;
    flex-direction: column;
    min-height: 85px;
}

.upgrade small {
    opacity: 0.8;
    color: #fdba74;
}

.buyBtn {
    margin-top: 6px;
    padding: 6px;
    border-radius: 8px;
    border: none;
    font-size: 0.75rem;
    font-weight: bold;
    background: linear-gradient(135deg, #fb923c, #f97316);
    color: black;
}
</style>
</head>

<body>

<header>
    <div id="coin">0 δ</div>
    <div id="rate">0 δ / sec</div>
</header>

<main>
    <button id="mineBtn">⛏ MINE δ</button>
</main>

<section id="shop">

    <div class="upgrade">
        ⚡ Pickaxe
        <small>+1/tap | <span id="pickCost">15</span> δ</small>
        <button class="buyBtn" onclick="buyPick()">Buy</button>
    </div>

    <div class="upgrade">
        🤖 Drone
        <small>+0.1/sec | <span id="droneCost">40</span> δ</small>
        <button class="buyBtn" onclick="buyDrone()">Buy</button>
    </div>

    <div class="upgrade">
        🏭 Rig
        <small>+1/sec | <span id="rigCost">120</span> δ</small>
        <button class="buyBtn" onclick="buyRig()">Buy</button>
    </div>

    <div class="upgrade">
        🌐 Node
        <small>+5/sec | <span id="nodeCost">400</span> δ</small>
        <button class="buyBtn" onclick="buyNode()">Buy</button>
    </div>

</section>

<script>
/* ---------------- PI AUTH (REQUIRED FOR PI APP) ---------------- */
async function loginPi() {
    try {
        const scopes = ['username'];
        const auth = await Pi.authenticate(scopes, (payment) => {
            console.log("Payment callback", payment);
        });
        console.log("Pi User:", auth);
    } catch (err) {
        console.log("Pi login failed or skipped:", err);
    }
}

loginPi();

/* ---------------- GAME ---------------- */
let delta = 0;

let perTap = 1;
let drones = 0;
let rigs = 0;
let nodes = 0;

let pickCost = 15;
let droneCost = 40;
let rigCost = 120;
let nodeCost = 400;

const coinEl = document.getElementById("coin");
const rateEl = document.getElementById("rate");
const mineBtn = document.getElementById("mineBtn");

function updateUI() {
    coinEl.textContent = delta.toFixed(0) + " δ";

    let perSec = (drones * 0.1) + rigs + (nodes * 5);
    rateEl.textContent = perSec.toFixed(1) + " δ / sec";

    document.getElementById("pickCost").textContent = pickCost;
    document.getElementById("droneCost").textContent = droneCost;
    document.getElementById("rigCost").textContent = rigCost;
    document.getElementById("nodeCost").textContent = nodeCost;
}

/* CLICK */
mineBtn.addEventListener("click", (e) => {
    delta += perTap;

    const f = document.createElement("div");
    f.className = "float";
    f.textContent = "+" + perTap + " δ";
    f.style.left = (e.clientX - 10) + "px";
    f.style.top = (e.clientY - 30) + "px";

    document.body.appendChild(f);
    setTimeout(() => f.remove(), 700);

    updateUI();
});

/* UPGRADES */
function buyPick() {
    if (delta >= pickCost) {
        delta -= pickCost;
        perTap++;
        pickCost = Math.floor(pickCost * 1.5);
        updateUI();
    }
}

function buyDrone() {
    if (delta >= droneCost) {
        delta -= droneCost;
        drones++;
        droneCost = Math.floor(droneCost * 1.6);
        updateUI();
    }
}

function buyRig() {
    if (delta >= rigCost) {
        delta -= rigCost;
        rigs++;
        rigCost = Math.floor(rigCost * 1.7);
        updateUI();
    }
}

function buyNode() {
    if (delta >= nodeCost) {
        delta -= nodeCost;
        nodes++;
        nodeCost = Math.floor(nodeCost * 1.8);
        updateUI();
    }
}

/* AUTO INCOME */
setInterval(() => {
    delta += (drones * 0.1) + rigs + (nodes * 5);
    updateUI();
}, 100);

updateUI();
</script>

</body>
</html>
