--[[
    vCore-UI Framework
    Modern & Minimalist UI Components
    Compatible with vCore Framework
]]

local VCoreUI = {}
VCoreUI.Menus = {}
VCoreUI.ActiveInputs = {}
VCoreUI.ActiveSkillbars = {}
VCoreUI.ActiveProgressbars = {}

-- ============================================
-- CORE UI FUNCTIONS
-- ============================================

--- Initialize the UI Framework
function VCoreUI:Init()
    print("^2[vCore-UI]^7 Framework Initialized")
    self:RegisterNUICallbacks()
end

--- Register NUI Callbacks
function VCoreUI:RegisterNUICallbacks()
    RegisterNUICallback('vcore-ui:close', function(data, cb)
        if data.type == 'menu' and self.Menus[data.id] then
            self:CloseMenu(data.id)
        end
        cb('ok')
    end)

    RegisterNUICallback('vcore-ui:select', function(data, cb)
        if self.Menus[data.menuId] and self.Menus[data.menuId].onSelect then
            self.Menus[data.menuId].onSelect(data.index, data.item)
        end
        cb('ok')
    end)

    RegisterNUICallback('vcore-ui:submit', function(data, cb)
        if self.ActiveInputs[data.id] and self.ActiveInputs[data.id].callback then
            self.ActiveInputs[data.id].callback(data.value)
            self.ActiveInputs[data.id] = nil
        end
        cb('ok')
    end)

    RegisterNUICallback('vcore-ui:skillbar-result', function(data, cb)
        if self.ActiveSkillbars[data.id] and self.ActiveSkillbars[data.id].callback then
            self.ActiveSkillbars[data.id].callback(data.success)
            self.ActiveSkillbars[data.id] = nil
        end
        cb('ok')
    end)
end

-- ============================================
-- MENU SYSTEM
-- ============================================

--[[
    Open a dynamic menu
    @param id string - Unique menu identifier
    @param config table - Menu configuration
        - title: string
        - subtitle: string (optional)
        - items: table of menu items
        - onSelect: function(index, item)
        - onClose: function (optional)
]]
function VCoreUI:OpenMenu(id, config)
    if not config or not config.items then
        print("^1[vCore-UI]^7 Invalid menu configuration")
        return
    end

    self.Menus[id] = {
        id = id,
        title = config.title or "Menu",
        subtitle = config.subtitle,
        items = config.items,
        onSelect = config.onSelect,
        onClose = config.onClose
    }

    SendNUIMessage({
        action = "vcore-ui:open-menu",
        data = {
            id = id,
            title = config.title,
            subtitle = config.subtitle,
            items = config.items
        }
    })

    SetNuiFocus(true, true)
end

--[[
    Close a menu
    @param id string - Menu identifier
]]
function VCoreUI:CloseMenu(id)
    if self.Menus[id] then
        if self.Menus[id].onClose then
            self.Menus[id].onClose()
        end
        self.Menus[id] = nil
    end

    SendNUIMessage({
        action = "vcore-ui:close-menu",
        data = { id = id }
    })

    SetNuiFocus(false, false)
end

-- ============================================
-- INPUT SYSTEM
-- ============================================

--[[
    Open an input dialog
    @param config table - Input configuration
        - id: string (auto-generated if not provided)
        - title: string
        - placeholder: string (optional)
        - type: string (text, number, password)
        - maxLength: number (optional)
        - defaultValue: string (optional)
    @param callback function - Called with input value
]]
function VCoreUI:OpenInput(config, callback)
    local inputId = config.id or ("input_" .. math.random(100000, 999999))
    
    self.ActiveInputs[inputId] = {
        callback = callback
    }

    SendNUIMessage({
        action = "vcore-ui:open-input",
        data = {
            id = inputId,
            title = config.title or "Input",
            placeholder = config.placeholder or "",
            type = config.type or "text",
            maxLength = config.maxLength,
            defaultValue = config.defaultValue
        }
    })

    SetNuiFocus(true, true)
end

--[[
    Close input dialog
    @param id string - Input identifier
]]
function VCoreUI:CloseInput(id)
    if self.ActiveInputs[id] then
        self.ActiveInputs[id] = nil
    end

    SendNUIMessage({
        action = "vcore-ui:close-input",
        data = { id = id }
    })

    SetNuiFocus(false, false)
end

-- ============================================
-- SKILLBAR SYSTEM
-- ============================================

--[[
    Show a skillbar challenge
    @param config table - Skillbar configuration
        - id: string (auto-generated if not provided)
        - duration: number (milliseconds)
        - successZone: table { start: number, width: number } (0-100)
        - label: string (optional)
    @param callback function - Called with success boolean
]]
function VCoreUI:ShowSkillbar(config, callback)
    local skillbarId = config.id or ("skillbar_" .. math.random(100000, 999999))
    
    self.ActiveSkillbars[skillbarId] = {
        callback = callback
    }

    SendNUIMessage({
        action = "vcore-ui:show-skillbar",
        data = {
            id = skillbarId,
            duration = config.duration or 5000,
            successZone = config.successZone or { start = 40, width = 20 },
            label = config.label
        }
    })

    SetNuiFocus(false, false)
end

--[[
    Hide skillbar
    @param id string - Skillbar identifier
]]
function VCoreUI:HideSkillbar(id)
    if self.ActiveSkillbars[id] then
        self.ActiveSkillbars[id] = nil
    end

    SendNUIMessage({
        action = "vcore-ui:hide-skillbar",
        data = { id = id }
    })
end

-- ============================================
-- PROGRESSBAR SYSTEM
-- ============================================

--[[
    Show a progress bar
    @param config table - Progressbar configuration
        - id: string (auto-generated if not provided)
        - duration: number (milliseconds)
        - label: string
        - useWhileDead: boolean (optional)
        - canCancel: boolean (optional)
        - disableControl: table (optional)
        - animation: table (optional) { dict, anim, flags }
    @param callback function - Called with cancelled boolean
]]
function VCoreUI:ShowProgressbar(config, callback)
    local progressId = config.id or ("progress_" .. math.random(100000, 999999))
    
    self.ActiveProgressbars[progressId] = {
        callback = callback,
        startTime = GetGameTimer(),
        duration = config.duration or 5000,
        cancelled = false
    }

    -- Play animation if provided
    if config.animation then
        RequestAnimDict(config.animation.dict)
        while not HasAnimDictLoaded(config.animation.dict) do
            Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), config.animation.dict, config.animation.anim, 8.0, -8.0, -1, config.animation.flags or 49, 0, false, false, false)
    end

    SendNUIMessage({
        action = "vcore-ui:show-progressbar",
        data = {
            id = progressId,
            duration = config.duration,
            label = config.label or "Processing..."
        }
    })

    -- Handle progress completion
    CreateThread(function()
        local progressData = self.ActiveProgressbars[progressId]
        if not progressData then return end

        while GetGameTimer() - progressData.startTime < progressData.duration do
            Wait(100)
            
            if not progressData then break end
            
            -- Check for cancel
            if config.canCancel and IsControlJustPressed(0, 73) then -- X key
                progressData.cancelled = true
                break
            end

            -- Disable controls
            if config.disableControl then
                for _, control in ipairs(config.disableControl) do
                    DisableControlAction(0, control, true)
                end
            end
        end

        -- Cleanup
        if config.animation then
            ClearPedTasks(PlayerPedId())
        end

        local wasCancelled = progressData and progressData.cancelled or false
        
        if callback then
            callback(wasCancelled)
        end

        self:HideProgressbar(progressId)
    end)
end

--[[
    Hide progressbar
    @param id string - Progressbar identifier
]]
function VCoreUI:HideProgressbar(id)
    if self.ActiveProgressbars[id] then
        self.ActiveProgressbars[id] = nil
    end

    SendNUIMessage({
        action = "vcore-ui:hide-progressbar",
        data = { id = id }
    })
end

-- ============================================
-- NOTIFICATION SYSTEM
-- ============================================

--[[
    Show a notification
    @param config table - Notification configuration
        - message: string
        - type: string (success, error, info, warning)
        - duration: number (milliseconds)
]]
function VCoreUI:Notify(config)
    SendNUIMessage({
        action = "vcore-ui:notify",
        data = {
            message = config.message or "Notification",
            type = config.type or "info",
            duration = config.duration or 3000
        }
    })
end

-- ============================================
-- EXPORTS
-- ============================================

exports('OpenMenu', function(id, config)
    VCoreUI:OpenMenu(id, config)
end)

exports('CloseMenu', function(id)
    VCoreUI:CloseMenu(id)
end)

exports('OpenInput', function(config, callback)
    VCoreUI:OpenInput(config, callback)
end)

exports('ShowSkillbar', function(config, callback)
    VCoreUI:ShowSkillbar(config, callback)
end)

exports('ShowProgressbar', function(config, callback)
    VCoreUI:ShowProgressbar(config, callback)
end)

exports('Notify', function(config)
    VCoreUI:Notify(config)
end)

-- Initialize
CreateThread(function()
    VCoreUI:Init()
end)

-- Global access
_G.VCoreUI = VCoreUI