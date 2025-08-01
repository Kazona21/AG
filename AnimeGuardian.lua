-- Anime Guardian Auto GUI by @hoanganhvuh (Nousigi Clone)
-- Tính năng: Auto Join, Auto Play, Replay, Webhook, đặt 4 unit theo map

-- Tùy chỉnh Webhook tại đây
getgenv().Webhook_URL = "https://discord.com/api/webhooks/..."

-- Tọa độ unit theo từng map (ví dụ)
getgenv().MapUnitPositions = {
    ["DemonVillage"] = {
        Vector3.new(10, 3, 15),
        Vector3.new(12, 3, 18),
        Vector3.new(14, 3, 20),
        Vector3.new(16, 3, 22)
    },
    ["FrozenForest"] = {
        Vector3.new(5, 3, -10),
        Vector3.new(7, 3, -12),
        Vector3.new(9, 3, -14),
        Vector3.new(11, 3, -16)
    }
}

-- Load GUI
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local OrionLib = OrionLib
local Window = OrionLib:MakeWindow({Name = "Anime Guardian GUI", HidePremium = false, SaveConfig = false, IntroEnabled = false})

-- Trạng thái
getgenv().AutoJoin = false
getgenv().AutoPlay = false
getgenv().AutoReplay = false

-- Gửi Webhook
function SendWebhook(status, reward)
    local req = (syn and syn.request) or (http and http.request) or (http_request)
    if not req then return end

    local data = {
        ["content"] = "**Kết quả trận đấu**",
        ["embeds"] = {{
            ["title"] = "✅ Trận " .. status,
            ["fields"] = {
                {name = "Phần thưởng", value = reward or "Không rõ", inline = true},
                {name = "Thời gian", value = os.date("%X"), inline = true}
            }}
        }}
    }

    req({
        Url = getgenv().Webhook_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end

-- Đặt Unit theo map
function PlaceUnitsForMap(mapName)
    local positions = getgenv().MapUnitPositions[mapName]
    if not positions then return end
    local player = game.Players.LocalPlayer

    for _, pos in ipairs(positions) do
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
        wait(0.5)
        mouse1click()
        wait(1)
    end
end

-- Tabs
local Main = Window:MakeTab({Name = "Auto", Icon = "", PremiumOnly = false})
Main:AddToggle({
    Name = "Auto Join Map",
    Default = false,
    Callback = function(v) getgenv().AutoJoin = v end
})
Main:AddToggle({
    Name = "Auto Play (Đặt unit + wave)",
    Default = false,
    Callback = function(v) getgenv().AutoPlay = v end
})
Main:AddToggle({
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
