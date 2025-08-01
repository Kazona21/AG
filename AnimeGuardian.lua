-- ✅ Anime Guardian Auto GUI FIXED by @hoanganhvuh (Nousigi Clone)
-- Tính năng: Auto Join, Auto Play, Replay, Webhook, đặt 4 unit theo map

-- OrionLib GUI loader
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({Name = "Anime Guardian GUI", HidePremium = false, SaveConfig = false, IntroEnabled = false})

-- Các biến trạng thái
getgenv().AutoJoin = false
getgenv().AutoPlay = false
getgenv().AutoReplay = false
getgenv().Webhook_URL = ""

-- Vị trí unit theo từng map
getgenv().MapUnitPositions = {
    ["DemonVillage"] = {
        Vector3.new(10, 3, 15),
        Vector3.new(12, 3, 18),
        Vector3.new(14, 3, 20),
        Vector3.new(16, 3, 22)
    }
}

-- Gửi webhook (Synapse/KRNL supported)
local function SendWebhook(status, reward)
    local req = (syn and syn.request) or (http and http.request) or (http_request)
    if not req then return end

    local data = {
        ["content"] = "**Kết quả trận đấu**",
        ["embeds"] = {{
            ["title"] = "✅ Trận " .. status,
            ["fields"] = {
                {name = "Phần thưởng", value = reward or "Không rõ", inline = true},
                {name = "Thời gian", value = os.date("%X"), inline = true}
            }
        }}
    }

    req({
        Url = getgenv().Webhook_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end

-- Auto đặt unit (đứng và click)
local function PlaceUnitsForMap(mapName)
    local positions = getgenv().MapUnitPositions[mapName]
    if not positions then return end

    local player = game.Players.LocalPlayer
    local vim = game:GetService("VirtualInputManager")

    for _, pos in ipairs(positions) do
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        wait(0.5)
        vim:SendMouseButtonEvent(500, 500, 0, true, game, 1)
        vim:SendMouseButtonEvent(500, 500, 0, false, game, 1)
        wait(0.5)
    end
end

-- Auto Play Loop
task.spawn(function()
    while true do
        task.wait(1)
        if getgenv().AutoPlay then
            local mapName = "DemonVillage"
            PlaceUnitsForMap(mapName)
            -- TODO: start wave logic here (nếu cần)
        end
    end
end)

-- GUI Tabs
local AutoTab = Window:MakeTab({Name = "Auto", Icon = "", PremiumOnly = false})
AutoTab:AddToggle({
    Name = "Auto Join Map",
    Default = false,
    Callback = function(v) getgenv().AutoJoin = v end
})
AutoTab:AddToggle({
    Name = "Auto Play (Đặt unit)",
    Default = false,
    Callback = function(v) getgenv().AutoPlay = v end
})
AutoTab:AddToggle({
    Name = "Auto Replay",
    Default = false,
    Callback = function(v) getgenv().AutoReplay = v end
})

local WebhookTab = Window:MakeTab({Name = "Webhook", Icon = "", PremiumOnly = false})
WebhookTab:AddTextbox({
    Name = "Webhook URL",
    Default = "",
    Callback = function(v) getgenv().Webhook_URL = v end
})
WebhookTab:AddButton({
    Name = "Test Webhook",
    Callback = function()
        SendWebhook("Thắng", "150 Gems")
    end
})

OrionLib:Init()
