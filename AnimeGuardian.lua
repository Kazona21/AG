-- Tower Defense GUI Script by @hoanganh
-- Hỗ trợ: Join Map, Raid, Portal, Challenge, Record/Play Macro, Webhook

-- Tùy chỉnh webhook ở đây
getgenv().Webhook_URL = "https://your-webhook-link"

-- Auto Lib
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local OrionLib = OrionLib
local Window = OrionLib:MakeWindow({Name = "TD GUI by @hoanganh", HidePremium = false, SaveConfig = false, IntroEnabled = false})

-- Lưu Macro
getgenv().MacroSteps = {}
getgenv().Recording = false

-- Function gửi webhook
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
        }
    }

    req({
        Url = getgenv().Webhook_URL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end

-- Tab Main
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
MainTab:AddButton({Name = "Join Map", Callback = function()
    -- Tùy chỉnh hành động vào map
    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace:FindFirstChild("JoinPortal").Part, 0)
end})
MainTab:AddButton({Name = "Raid", Callback = function()
    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace:FindFirstChild("RaidPortal").Part, 0)
end})
MainTab:AddButton({Name = "Portal", Callback = function()
    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace:FindFirstChild("SpecialPortal").Part, 0)
end})
MainTab:AddButton({Name = "Challenge", Callback = function()
    firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, workspace:FindFirstChild("ChallengePortal").Part, 0)
end})

-- Tab Macro
local MacroTab = Window:MakeTab({Name = "Macro", Icon = "rbxassetid://4483345998", PremiumOnly = false})
MacroTab:AddButton({Name = "Start Recording", Callback = function()
    getgenv().MacroSteps = {}
    getgenv().Recording = true
    OrionLib:MakeNotification({Name = "Macro", Content = "Bắt đầu ghi macro", Time = 3})
end})
MacroTab:AddButton({Name = "Stop Recording", Callback = function()
    getgenv().Recording = false
    OrionLib:MakeNotification({Name = "Macro", Content = "Dừng ghi macro", Time = 3})
end})
MacroTab:AddButton({Name = "Play Macro", Callback = function()
    OrionLib:MakeNotification({Name = "Macro", Content = "Đang phát macro", Time = 3})
    for _, step in ipairs(getgenv().MacroSteps) do
        wait(step.delay)
        mouse1click()
    end
end})

-- Ghi Macro bằng input
local UserInputService = game:GetService("UserInputService")
local lastClickTime = tick()
UserInputService.InputBegan:Connect(function(input)
    if getgenv().Recording and input.UserInputType == Enum.UserInputType.MouseButton1 then
        table.insert(getgenv().MacroSteps, {
            delay = tick() - lastClickTime
        })
        lastClickTime = tick()
    end
end)

-- Tab Webhook test
local WebhookTab = Window:MakeTab({Name = "Webhook", Icon = "", PremiumOnly = false})
WebhookTab:AddButton({Name = "Gửi thử Webhook (Thắng)", Callback = function()
    SendWebhook("Thắng", "150 Gems + 500 Coins")
end})

-- UI
OrionLib:Init()
