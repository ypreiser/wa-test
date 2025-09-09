// /home/youruser/wa-test/index.js

import { Client, LocalAuth } from "whatsapp-web.js";
import qrcode from "qrcode-terminal";

console.log("🚀 Starting WhatsApp Connection Test...");

// --- Configuration ---
// Using LocalAuth to persist the session in a local file.
// This is the simplest way to test session resumption.
const client = new Client({
  authStrategy: new LocalAuth({
    dataPath: "./wwebjs_auth_test", // Store session data in this subdirectory
  }),
  puppeteer: {
    headless: true,
    // These args are CRITICAL for running in a Docker/Linux environment
    args: [
      "--no-sandbox",
      "--disable-setuid-sandbox",
      "--disable-dev-shm-usage",
      "--disable-gpu",
    ],
  },
});

console.log("✅ Client configured. Initializing...");

// --- Event Listeners ---

// 1. Fired when a QR code is received
client.on("qr", (qr) => {
  console.log(`
============================================================`);
  console.log(`
    📱 QR Code Received! Scan this with your WhatsApp app. 📱`);
  qrcode.generate(qr, { small: true });
  console.log(`
============================================================`);
});

// 2. Fired when the client has authenticated successfully
client.on(`authenticated`, () => {
  console.log(`
============================================================`);
  console.log(`
    ✅ AUTHENTICATED SUCCESSFULLY ✅`);
  console.log(`
============================================================`);
});

// 3. Fired when the client is ready to send and receive messages
client.on("ready", () => {
  console.log(`
============================================================`);
  console.log(`
    🎉 CLIENT IS READY! 🎉`);
  console.log(`
    Connection test successful. If you see this, the IP is likely NOT blocked.`);
  console.log(`
    This test will automatically exit in 2 minutes.`);
  console.log(`
============================================================`);
  // Keep the script running for a bit to ensure the connection is stable, then exit.
  setTimeout(() => {
    console.log(`
Test finished. Exiting.`);
    client.destroy();
    process.exit(0);
  }, 120000); // 2 minutes
});

// 4. Fired if authentication fails
client.on("auth_failure", (msg) => {
  console.error(`
============================================================`);
  console.error(`
    ❌ AUTHENTICATION FAILURE ❌`);
  console.error(
    `
    Message:`,
    msg
  );
  console.error(`
    This could be due to a bad session file. Try deleting the wwebjs_auth_test directory.`);
  console.error(`
============================================================`);
  process.exit(1);
});

// 5. Fired when the client disconnects
client.on("disconnected", (reason) => {
  console.warn(`
============================================================`);
  console.warn(`
    🔌 CLIENT DISCONNECTED 🔌`);
  console.warn(
    `
    Reason:`,
    reason
  );
  console.warn(`
============================================================`);
  process.exit(1);
});

// --- Start the client ---
client.initialize().catch((err) => {
  console.error(
    `
❌ Client initialization failed:`,
    err
  );
  process.exit(1);
});

// Graceful shutdown
process.on("SIGINT", async () => {
  console.log(`
(SIGINT) Shutting down...`);
  await client.destroy();
  process.exit(0);
});
