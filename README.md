# qb-dvall – Vehicle Cleanup Script (QBCore)

I saw people selling this resource, so I decided to release it for **free** to the community.

If you paid for this, you got scammed.  
Do not resell it.

---

## 📌 Description

`qb-dvall` is a simple **QBCore vehicle cleanup system** for FiveM servers.

It allows authorized staff to:

- Start a timed vehicle cleanup
- Notify all players before deletion
- Show a UI countdown
- Delete all empty vehicles after the timer ends
- Cancel an active cleanup

This helps reduce lag caused by abandoned vehicles.

---

## ⚙️ Features

- ✅ QBCore command integration  
- ✅ Timed cleanup (1–10 minutes)  
- ✅ Global countdown notifications  
- ✅ NUI countdown UI  
- ✅ Deletes only empty vehicles  
- ✅ Cancel cleanup option  
- ✅ License-based authorization  

---

## 📂 Installation

1. Drag the resource folder into your `resources` directory.
2. Add this to your `server.cfg`:

```cfg
ensure qb-dvall
```

3. Make sure **QBCore** is installed and running.
4. Restart your server.

---

## 🔐 Authorization Setup

Inside `server.lua`:

```lua
local authorizedLicenses = {
    "license:yourlicensehere",
}
```

Replace `"license:yourlicensehere"` with your own FiveM license.

### How to get your license

Run this in server console while in-game:

```
license
```

Or temporarily add:

```lua
print(GetPlayerIdentifiers(source))
```

Add multiple licenses if needed.

---

## 💻 Commands

### `/deleteallvehicles [minutes]`

Starts a vehicle cleanup timer.

Example:

```
/deleteallvehicles 5
```

- Minimum: 1 minute  
- Maximum: 10 minutes  
- Default: 1 minute  

This will:
- Count vehicles
- Notify all players
- Show countdown UI
- Delete empty vehicles when timer ends

---

### `/cancelcleanup`

Cancels an active cleanup (authorized users only).

---

## 🚗 How It Works

1. Counts all vehicles in the game pool.
2. Checks if any player is inside each vehicle.
3. Starts a global countdown.
4. Sends warnings at:
   - 60 seconds
   - 30 seconds
   - 10 seconds
5. Deletes only vehicles without occupants.
6. Displays how many vehicles were removed.

---

## 🖥 Dependencies

- QBCore Framework
- FiveM (cerulean)

---

## 📁 Included Files

- `fxmanifest.lua`
- `client.lua`
- `server.lua`
- `index.html`

---

## ❤️ Free Release

This resource is FREE.

- Do not resell it.
- Do not claim it as your own.
- Share it properly.

Enjoy.
