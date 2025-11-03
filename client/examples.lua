--[[
    vCore-UI Framework Examples
    Demonstrates all UI components
]]

-- ============================================
-- MENU EXAMPLES
-- ============================================

-- Example 1: Simple Menu
RegisterCommand('vcui:simplemenu', function()
    VCoreUI:OpenMenu('simple-menu', {
        title = "Player Menu",
        subtitle = "Manage your character",
        items = {
            {
                icon = "👤",
                label = "View Profile",
                description = "Check your character stats"
            },
            {
                icon = "💼",
                label = "Inventory",
                description = "Manage your items",
                value = "12/20"
            },
            {
                icon = "🚗",
                label = "Vehicles",
                description = "Access your garage",
                value = "3 cars"
            },
            {
                icon = "🏠",
                label = "Property",
                description = "View your properties",
                value = "2 owned"
            },
            {
                icon = "⚙️",
                label = "Settings",
                description = "Configure preferences"
            }
        },
        onSelect = function(index, item)
            VCoreUI:Notify({
                message = "Selected: " .. item.label,
                type = "info",
                duration = 3000
            })
            VCoreUI:CloseMenu('simple-menu')
        end,
        onClose = function()
            print("Menu closed")
        end
    })
end)

-- Example 2: Job Menu
RegisterCommand('vcui:jobmenu', function()
    VCoreUI:OpenMenu('job-menu', {
        title = "Police Actions",
        subtitle = "LSPD Officer Menu",
        items = {
            {
                icon = "🚓",
                label = "Vehicle Actions",
                description = "Spawn patrol vehicle"
            },
            {
                icon = "👮",
                label = "Handcuff Player",
                description = "Restrain nearest player"
            },
            {
                icon = "🚨",
                label = "Toggle Duty",
                description = "On/Off duty status",
                value = "ON DUTY"
            },
            {
                icon = "📋",
                label = "Check License",
                description = "View player licenses"
            },
            {
                icon = "🔫",
                label = "Armory",
                description = "Access weapon storage"
            },
            {
                icon = "📱",
                label = "MDT",
                description = "Mobile Data Terminal"
            }
        },
        onSelect = function(index, item)
            VCoreUI:Notify({
                message = item.label .. " activated",
                type = "success",
                duration = 3000
            })
        end
    })
end)

-- ============================================
-- INPUT EXAMPLES
-- ============================================

-- Example 1: Text Input
RegisterCommand('vcui:textinput', function()
    VCoreUI:OpenInput({
        title = "Change Character Name",
        placeholder = "Enter new name...",
        type = "text",
        maxLength = 50
    }, function(value)
        if value and value ~= "" then
            VCoreUI:Notify({
                message = "Name changed to: " .. value,
                type = "success",
                duration = 3000
            })
        else
            VCoreUI:Notify({
                message = "Invalid name entered",
                type = "error",
                duration = 3000
            })
        end
    end)
end)

-- Example 2: Number Input
RegisterCommand('vcui:numberinput', function()
    VCoreUI:OpenInput({
        title = "Transfer Money",
        placeholder = "Enter amount...",
        type = "number",
        defaultValue = "100"
    }, function(value)
        local amount = tonumber(value)
        if amount and amount > 0 then
            VCoreUI:Notify({
                message = "Transferred $" .. amount,
                type = "success",
                duration = 3000
            })
        else
            VCoreUI:Notify({
                message = "Invalid amount",
                type = "error",
                duration = 3000
            })
        end
    end)
end)

-- Example 3: Password Input
RegisterCommand('vcui:passwordinput', function()
    VCoreUI:OpenInput({
        title = "Security Check",
        placeholder = "Enter PIN code...",
        type = "password",
        maxLength = 4
    }, function(value)
        if value == "1234" then
            VCoreUI:Notify({
                message = "Access granted",
                type = "success",
                duration = 3000
            })
        else
            VCoreUI:Notify({
                message = "Access denied",
                type = "error",
                duration = 3000
            })
        end
    end)
end)

-- ============================================
-- SKILLBAR EXAMPLES
-- ============================================

-- Example 1: Easy Skillbar
RegisterCommand('vcui:easyskill', function()
    VCoreUI:ShowSkillbar({
        duration = 4000,
        successZone = { start = 35, width = 30 },
        label = "Picking Lock"
    }, function(success)
        if success then
            VCoreUI:Notify({
                message = "Lock picked successfully!",
                type = "success",
                duration = 3000
            })
        else
            VCoreUI:Notify({
                message = "Failed to pick lock",
                type = "error",
                duration = 3000
            })
        end
    end)
end)

-- Example 2: Hard Skillbar
RegisterCommand('vcui:hardskill', function()
    VCoreUI:ShowSkillbar({
        duration = 2500,
        successZone = { start = 42, width = 16 },
        label = "Hacking System"
    }, function(success)
        if success then
            VCoreUI:Notify({
                message = "System hacked!",
                type = "success",
                duration = 3000
            })
        else
            VCoreUI:Notify({
                message = "Hack failed - alarm triggered",
                type = "error",
                duration = 3000
            })
        end
    end)
end)

-- Example 3: Multiple Skillbars
RegisterCommand('vcui:multiskill', function()
    local attempts = 0
    local maxAttempts = 3
    
    local function doSkillbar()
        attempts = attempts + 1
        
        VCoreUI:ShowSkillbar({
            duration = 3000,
            successZone = { start = 38, width = 24 },
            label = "Attempt " .. attempts .. "/" .. maxAttempts
        }, function(success)
            if success then
                if attempts >= maxAttempts then
                    VCoreUI:Notify({
                        message = "All attempts successful!",
                        type = "success",
                        duration = 3000
                    })
                else
                    Wait(500)
                    doSkillbar()
                end
            else
                VCoreUI:Notify({
                    message = "Failed at attempt " .. attempts,
                    type = "error",
                    duration = 3000
                })
            end
        end)
    end
    
    doSkillbar()
end)

-- ============================================
-- PROGRESSBAR EXAMPLES
-- ============================================

-- Example 1: Simple Progress
RegisterCommand('vcui:simpleprogress', function()
    VCoreUI:ShowProgressbar({
        duration = 5000,
        label = "Searching..."
    }, function(cancelled)
        if not cancelled then
            VCoreUI:Notify({
                message = "Search completed",
                type = "success",
                duration = 3000
            })
        else
            VCoreUI:Notify({
                message = "Search cancelled",
                type = "warning",
                duration = 3000
            })
        end
    end)
end)

-- Example 2: Progress with Animation
RegisterCommand('vcui:animprogress', function()
    VCoreUI:ShowProgressbar({
        duration = 8000,
        label = "Repairing Vehicle...",
        animation = {
            dict = "mini@repair",
            anim = "fixing_a_player",
            flags = 49
        }
    }, function(cancelled)
        if not cancelled then
            VCoreUI:Notify({
                message = "Vehicle repaired!",
                type = "success",
                duration = 3000
            })
        end
    end)
end)

-- Example 3: Cancellable Progress
RegisterCommand('vcui:cancelprogress', function()
    VCoreUI:ShowProgressbar({
        duration = 10000,
        label = "Crafting Item... (Press X to cancel)",
        canCancel = true,
        disableControl = {24, 25, 44, 45} -- Attack, Aim, Cover, Reload
    }, function(cancelled)
        if not cancelled then
            VCoreUI:Notify({
                message = "Item crafted successfully",
                type = "success",
                duration = 3000
            })
        else
            VCoreUI:Notify({
                message = "Crafting cancelled",
                type = "warning",
                duration = 3000
            })
        end
    end)
end)

-- Example 4: Progress Chain
RegisterCommand('vcui:chainprogress', function()
    VCoreUI:ShowProgressbar({
        duration = 3000,
        label = "Step 1: Gathering materials..."
    }, function(cancelled)
        if not cancelled then
            Wait(500)
            VCoreUI:ShowProgressbar({
                duration = 4000,
                label = "Step 2: Processing..."
            }, function(cancelled2)
                if not cancelled2 then
                    Wait(500)
                    VCoreUI:ShowProgressbar({
                        duration = 3000,
                        label = "Step 3: Finalizing..."
                    }, function(cancelled3)
                        if not cancelled3 then
                            VCoreUI:Notify({
                                message = "All steps completed!",
                                type = "success",
                                duration = 3000
                            })
                        end
                    end)
                end
            end)
        end
    end)
end)

-- ============================================
-- NOTIFICATION EXAMPLES
-- ============================================

RegisterCommand('vcui:notifications', function()
    -- Success notification
    VCoreUI:Notify({
        message = "Operation completed successfully!",
        type = "success",
        duration = 3000
    })
    
    Wait(500)
    
    -- Error notification
    VCoreUI:Notify({
        message = "An error occurred during processing",
        type = "error",
        duration = 3000
    })
    
    Wait(500)
    
    -- Warning notification
    VCoreUI:Notify({
        message = "Low health - seek medical attention",
        type = "warning",
        duration = 3000
    })
    
    Wait(500)
    
    -- Info notification
    VCoreUI:Notify({
        message = "New message received",
        type = "info",
        duration = 3000
    })
end)

-- ============================================
-- COMPLEX EXAMPLE: ATM System
-- ============================================

RegisterCommand('vcui:atm', function()
    VCoreUI:OpenMenu('atm-menu', {
        title = "Maze Bank ATM",
        subtitle = "Account: **** **** **** 1234",
        items = {
            {
                icon = "💵",
                label = "Withdraw Cash",
                description = "Withdraw money from account",
                value = "$15,420"
            },
            {
                icon = "💳",
                label = "Deposit Cash",
                description = "Deposit cash into account"
            },
            {
                icon = "📊",
                label = "Check Balance",
                description = "View account balance",
                value = "$15,420"
            },
            {
                icon = "🔄",
                label = "Transfer Money",
                description = "Transfer to another account"
            },
            {
                icon = "📜",
                label = "Transaction History",
                description = "View recent transactions"
            }
        },
        onSelect = function(index, item)
            if index == 0 then -- Withdraw
                VCoreUI:CloseMenu('atm-menu')
                Wait(300)
                
                VCoreUI:OpenInput({
                    title = "Withdraw Cash",
                    placeholder = "Enter amount...",
                    type = "number"
                }, function(value)
                    local amount = tonumber(value)
                    if amount and amount > 0 then
                        VCoreUI:ShowProgressbar({
                            duration = 3000,
                            label = "Processing withdrawal..."
                        }, function(cancelled)
                            if not cancelled then
                                VCoreUI:Notify({
                                    message = "Withdrew $" .. amount,
                                    type = "success",
                                    duration = 3000
                                })
                            end
                        end)
                    end
                end)
                
            elseif index == 2 then -- Balance
                VCoreUI:Notify({
                    message = "Current Balance: $15,420",
                    type = "info",
                    duration = 5000
                })
            end
        end
    })
end)

-- ============================================
-- HELP COMMAND
-- ============================================

RegisterCommand('vcui:help', function()
    print("^2=== vCore-UI Examples ===^7")
    print("^3Menus:^7")
    print("  /vcui:simplemenu - Simple menu example")
    print("  /vcui:jobmenu - Job actions menu")
    print("^3Inputs:^7")
    print("  /vcui:textinput - Text input example")
    print("  /vcui:numberinput - Number input example")
    print("  /vcui:passwordinput - Password input example")
    print("^3Skillbars:^7")
    print("  /vcui:easyskill - Easy skillbar")
    print("  /vcui:hardskill - Hard skillbar")
    print("  /vcui:multiskill - Multiple skillbars")
    print("^3Progressbars:^7")
    print("  /vcui:simpleprogress - Simple progress")
    print("  /vcui:animprogress - Progress with animation")
    print("  /vcui:cancelprogress - Cancellable progress")
    print("  /vcui:chainprogress - Chain of progress bars")
    print("^3Notifications:^7")
    print("  /vcui:notifications - All notification types")
    print("^3Complex:^7")
    print("  /vcui:atm - ATM system example")
end)