# vCore-UI Framework

Modern, minimalist UI framework designed specifically for vCore Framework. Features clean animations, responsive design, and intuitive components.

## Installation

1. **Download** and place `vcore-ui` folder in your resources directory
2. **Add** to your `server.cfg`:
   ```
   ensure vCore
   ensure vcore-ui
   ```
3. **Restart** your server

## 📦 Components

### 1. Menu System
Dynamic menu with smooth animations and callbacks.

```lua
VCoreUI:OpenMenu('my-menu', {
    title = "Menu Title",
    subtitle = "Optional subtitle",
    items = {
        {
            icon = "🎮",
            label = "Item Label",
            description = "Item description",
            value = "Optional value"
        }
    },
    onSelect = function(index, item)
        -- Handle selection
    end,
    onClose = function()
        -- Handle close
    end
})
```

### 2. Input System
Text, number, and password inputs with validation.

```lua
VCoreUI:OpenInput({
    title = "Input Title",
    placeholder = "Placeholder text",
    type = "text", -- text, number, password
    maxLength = 50,
    defaultValue = ""
}, function(value)
    -- Handle input value
end)
```

### 3. Skillbar System
Interactive timing challenges for actions.

```lua
VCoreUI:ShowSkillbar({
    duration = 3000,           -- Bar speed in ms
    successZone = { 
        start = 40,            -- Start position (0-100)
        width = 20             -- Zone width (0-100)
    },
    label = "Action Label"
}, function(success)
    -- Handle success/failure
end)
```

### 4. Progressbar System
Visual progress indicators with optional animations.

```lua
VCoreUI:ShowProgressbar({
    duration = 5000,
    label = "Action in progress...",
    canCancel = true,          -- Press X to cancel
    disableControl = {24, 25}, -- Disabled controls
    animation = {
        dict = "anim_dict",
        anim = "anim_name",
        flags = 49
    }
}, function(cancelled)
    -- Handle completion/cancel
end)
```

### 5. Notification System
Toast notifications with different types.

```lua
VCoreUI:Notify({
    message = "Notification message",
    type = "success", -- success, error, warning, info
    duration = 3000
})
```

## Usage Examples

### Basic Menu
```lua
RegisterCommand('mymenu', function()
    VCoreUI:OpenMenu('player-menu', {
        title = "Player Menu",
        items = {
            { icon = "👤", label = "Profile", description = "View profile" },
            { icon = "💼", label = "Inventory", description = "Open inventory" },
            { icon = "⚙️", label = "Settings", description = "Configure settings" }
        },
        onSelect = function(index, item)
            print("Selected:", item.label)
            VCoreUI:CloseMenu('player-menu')
        end
    })
end)
```

### Input Dialog
```lua
RegisterCommand('transfer', function()
    VCoreUI:OpenInput({
        title = "Transfer Money",
        placeholder = "Enter amount",
        type = "number"
    }, function(value)
        local amount = tonumber(value)
        if amount and amount > 0 then
            -- Process transfer
            VCoreUI:Notify({
                message = "Transferred $" .. amount,
                type = "success"
            })
        end
    end)
end)
```

### Skillbar Challenge
```lua
RegisterCommand('lockpick', function()
    VCoreUI:ShowSkillbar({
        duration = 4000,
        successZone = { start = 35, width = 30 },
        label = "Picking Lock"
    }, function(success)
        if success then
            -- Unlock door
            VCoreUI:Notify({
                message = "Lock picked!",
                type = "success"
            })
        else
            -- Break lockpick
            VCoreUI:Notify({
                message = "Lockpick broke",
                type = "error"
            })
        end
    end)
end)
```

### Progress with Animation
```lua
RegisterCommand('repair', function()
    VCoreUI:ShowProgressbar({
        duration = 8000,
        label = "Repairing vehicle...",
        canCancel = true,
        animation = {
            dict = "mini@repair",
            anim = "fixing_a_player",
            flags = 49
        }
    }, function(cancelled)
        if not cancelled then
            -- Complete repair
        end
    end)
end)
```

## Customization

### Modify Colors
Edit CSS variables in `html/index.html`:

```css
:root {
    --primary: #6366f1;        /* Main theme color */
    --success: #10b981;        /* Success color */
    --error: #ef4444;          /* Error color */
    --bg-dark: #0f172a;        /* Background color */
    --bg-card: #1e293b;        /* Card background */
}
```

### Animation Timing
Adjust transition speeds in CSS:

```css
.vcore-menu {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
```

## 🔧 Advanced Usage

### Chaining Progressbars
```lua
local function chainedProgress()
    VCoreUI:ShowProgressbar({
        duration = 3000,
        label = "Step 1..."
    }, function(cancelled)
        if not cancelled then
            VCoreUI:ShowProgressbar({
                duration = 4000,
                label = "Step 2..."
            }, function(cancelled2)
                if not cancelled2 then
                    VCoreUI:Notify({
                        message = "All steps completed!",
                        type = "success"
                    })
                end
            end)
        end
    end)
end
```

### Multiple Skillbars
```lua
local attempts = 0
local function doSkillbar()
    attempts = attempts + 1
    VCoreUI:ShowSkillbar({
        duration = 3000,
        successZone = { start = 38, width = 24 },
        label = "Attempt " .. attempts .. "/3"
    }, function(success)
        if success and attempts < 3 then
            Wait(500)
            doSkillbar()
        end
    end)
end
```

## Export Usage

Use exports from other resources:

```lua
-- Open menu
exports['vcore-ui']:OpenMenu('my-menu', config)

-- Show notification
exports['vcore-ui']:Notify({
    message = "Hello!",
    type = "info"
})

-- Show skillbar
exports['vcore-ui']:ShowSkillbar(config, callback)
```

## 🐛 Testing Commands

Test all components:
- `/vcui:help` - Show all test commands
- `/vcui:simplemenu` - Test menu system
- `/vcui:textinput` - Test input dialog
- `/vcui:easyskill` - Test skillbar
- `/vcui:simpleprogress` - Test progressbar
- `/vcui:notifications` - Test notifications
- `/vcui:atm` - Complete ATM example

## 📝 Notes

- **ESC Key** closes menus and inputs
- **SPACE Key** triggers skillbar check
- **X Key** cancels progressbar (if enabled)
- All callbacks are optional
- Components can be stacked/queued
- NUI Focus is automatically managed

## Integration with vCore

```lua
-- Example: Job menu integration
RegisterNetEvent('vcore:showJobMenu', function(job)
    VCoreUI:OpenMenu('job-menu', {
        title = job.label .. " Menu",
        items = job.actions,
        onSelect = function(index, item)
            TriggerServerEvent('vcore:jobAction', item.action)
        end
    })
end)
```

## License

This framework is designed for vCore Framework.  
Modify and distribute freely within vCore communities.

---

**Made with ❤️ for vCore Framework**