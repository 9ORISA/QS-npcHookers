# 🔞 **[QB] Hooker Interaction Script | NPC Sex In Vehicle 💋🚗**

> Realistic NPC hooker system with Discord logs, screenshots, and full configuration!

---

## 💡 **Features:**

* 🔹 **NPC Hooker Interaction** – Players can interact with NPCs (hookers) using `qb-target` (easily changeable to other targeting systems).
* 🔹 **Sex in Vehicle Scene** – Realistic adult interaction when entering the vehicle.
* 🔹 **Discord Logging** – Logs each interaction with a screenshot to your Discord webhook for admin oversight.
* 🔹 **Advanced Config** – Fully editable config file to manage:
  * Hooker behavior
  * Scene duration and animations
  * Vehicle restrictions
  * Payment options
* 🔹 **Open Source** – Freely editable for your server’s needs.

---

## ⚙️ **Installation:**

1. **Add the Script to Your Server:**
   - Download or clone the repository.
   - Place the script folder in your server's `resources` folder.

2. **Edit `config.lua` to Suit Your Needs:**
   - Update the webhook URL in `Config.Logs.Hooker.webhook` with your own Discord webhook for logging.
   - Set up NPC hooker models, spawn locations, and blacklisted vehicles.
   - Modify the animations and prices as necessary.

3. **Start the Script:**
   - In your `server.cfg`, add `start QS-npcHookers`.

---

## 🔧 **Configuration:**

- **Config.UseQBCore**: Set to `true` if using QBCore, otherwise, set to `false`.
- **Config.Debug**: Enable/disable debugging (set to `true` for detailed logs).
- **Config.Language**: Set the language for the script (currently supports `"en"`).
- **Config.Target**: Choose the targeting system (`qb-target` or `ox_target`).
- **Config.Logs**: Customize the Discord webhook logging:
  - `webhook`: Set your own Discord webhook URL.
  - `screenshot`: Enable/disable automatic screenshots for each interaction.
  - `username`: The name of the bot sending the log.
  - `avatar`: The avatar image for the bot.
  - `title`: The title of the log message.
  - `color`: Hex color for the log message (default is pink).
  - `footer`: Footer text for the log.

- **Config.HookerPedModels**: A list of valid NPC models that can be used as hookers.
- **Config.HookerSpawnLocations**: Coordinates for spawning hooker NPCs.
- **Config.BlacklistedVehicles**: A list of vehicles that cannot be used during hooker interactions (e.g., police, ambulance).
  
- **Config.Animations**: List of available animations for hooker interactions:
  - **icon**: The emoji representing the action.
  - **name**: The internal name for the animation.
  - **label**: The label displayed for the interaction.
  - **animDict**: The animation dictionary.
  - **anim1** and **anim2**: The actual animation names.
  - **distance**: The interaction distance.
  - **duration**: Duration of the scene (in milliseconds).
  - **price**: Payment required for the interaction.
  - **scenario**: Whether the animation should be in a specific scenario or just a normal animation.

---

## 🛠 **Usage:**

1. **Interacting with NPC Hookers:**
   - Use `qb-target` (or other targeting system) to interact with the NPCs.
   - Each interaction triggers an animation scene (e.g., blowjob, sex in vehicle).
   - The player must be within the defined interaction distance to trigger the scene.

2. **Payment:**
   - The player will be charged the configured price for each animation (e.g., $20 for a blowjob, $50 for sex in a vehicle).
   - Payment is deducted when the interaction starts.

3. **Discord Logging:**
   - Every interaction with a hooker is logged to your Discord channel via the webhook.
   - The log includes the player’s interaction, along with a screenshot for admin oversight.

---

## ⚠️ **Important Notes:**

- **Adult Content Warning:** This script contains adult content and should be used responsibly. Ensure that your server is set up to handle such content in accordance with the rules and guidelines of the platform.
- **Vehicle Restrictions:** The script will prevent interactions in blacklisted vehicles (e.g., police, ambulance).
- **Customization:** This script is highly customizable, allowing server admins to adjust interactions, pricing, locations, and more.

---

## 🤝 **Contributing:**

Feel free to fork the repository, make changes, and submit pull requests. We welcome contributions to improve and expand this script!

---

## 📜 **Disclaimer:**

This script is intended for role-playing and adult-themed servers only. The developer assumes no responsibility for misuse or inappropriate use of the script.

---

**Script Made By Qorisa**
