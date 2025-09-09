// index.js
// index.js (Final Version)
import pkg from "whatsapp-web.js";
const { Client, LocalAuth } = pkg;
import qrcode from "qrcode-terminal";

console.log("🚀 Starting WhatsApp Connection Test...");

const client = new Client({
  authStrategy: new LocalAuth({
    dataPath: "/data",
  }),
  puppeteer: {
    headless: true,
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-dev-shm-usage",
      "--disable-gpu",
    ],
  },
});

console.log("✅ Client configured. Adding event listeners and initializing...");

client.on("qr", (qr) => {
  console.log("\n============================================================");
  console.log("    📱 QR Code Received! Scan this with your WhatsApp app. 📱");
  qrcode.generate(qr, { small: true });
  console.log("============================================================\n");
});

client.on("authenticated", () => {
  console.log("\n============================================================");
  console.log("    ✅ AUTHENTICATED SUCCESSFULLY ✅");
  console.log("============================================================\n");
});

client.on("ready", () => {
  console.log("\n============================================================");
  console.log("    🎉 CLIENT IS READY! 🎉");
  console.log(
    "    Connection test successful. If you see this, the IP is likely NOT blocked."
  );
  console.log("============================================================\n");
});

client.on("auth_failure", (msg) => {
  console.error(
    "\n============================================================"
  );
  console.error("    ❌ AUTHENTICATION FAILURE ❌");
  console.error("    Message:", msg);
  console.error(
    "============================================================\n"
  );
  process.exit(1);
});

client.on("disconnected", (reason) => {
  console.warn(
    "\n============================================================"
  );
  console.warn("    🔌 CLIENT DISCONNECTED 🔌");
  console.warn("    Reason:", reason);
  console.warn(
    "============================================================\n"
  );
});

client.initialize().catch((err) => {
  console.error("\n❌ Client initialization promise rejected:", err);
  process.exit(1);
});

console.log(
  "⏳ Waiting for client events... Check the GitHub Actions logs for a QR code or status messages."
);
