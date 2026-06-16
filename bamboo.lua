if not game:IsLoaded() then
    pcall(function() game.Loaded:Wait() end)
end

local localPlayer = game:GetService("Players").LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local isCancelled = false

-- --- БЕЗОПАСНОЕ СОЗДАНИЕ ИНТЕРФЕЙСА ---
local playerGui = localPlayer:WaitForChild("PlayerGui", 10)
if not playerGui then return end

if playerGui:FindFirstChild("MailboxAutoSenderPro") then
    pcall(function() playerGui.MailboxAutoSenderPro:Destroy() end)
end

local ba = Instance.new("ScreenGui")
ba.Name = "MailboxAutoSenderPro"
ba.Parent = playerGui
ba.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главное окно
local mainFrame = Instance.new("Frame")
mainFrame.Parent = ba
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.Position = UDim2.new(0.5, -285, 0.2, 0)
mainFrame.Size = UDim2.new(0, 370, 0, 52)

-- Текст заголовка
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Font = Enum.Font.SourceSansSemibold
titleLabel.Text = "Mailbox Bamboo Sender v33"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.TextSize = 22

-- Кнопка закрытия
local closeButton = Instance.new("TextButton")
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(80, 25, 25)
closeButton.Position = UDim2.new(0.88, 0, 0.15, 0)
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Font = Enum.Font.ArialBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextSize = 20

-- Корпус менюшки
local da = Instance.new("Frame")
da.Parent = mainFrame
da.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
da.Position = UDim2.new(0, 0, 1.02, 0)
da.Size = UDim2.new(0, 370, 0, 290)

-- Поле ввода Никнейма
local nicknameInput = Instance.new("TextBox")
nicknameInput.Parent = da
nicknameInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nicknameInput.BorderColor3 = Color3.fromRGB(0, 255, 255)
nicknameInput.Position = UDim2.new(0.05, 0, 0.05, 0)
nicknameInput.Size = UDim2.new(0, 332, 0, 38)
nicknameInput.Font = Enum.Font.SourceSans
nicknameInput.PlaceholderText = "Введите ник получателя..."
nicknameInput.Text = ""
nicknameInput.TextColor3 = Color3.new(1, 1, 1)
nicknameInput.TextSize = 16

-- Поле ввода КОЛИЧЕСТВА БАМБУКА
local amountInput = Instance.new("TextBox")
amountInput.Parent = da
amountInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
amountInput.BorderColor3 = Color3.fromRGB(0, 255, 255)
amountInput.Position = UDim2.new(0.05, 0, 0.22, 0)
amountInput.Size = UDim2.new(0, 332, 0, 38)
amountInput.Font = Enum.Font.SourceSans
amountInput.PlaceholderText = "Сколько всего бамбука отправить?"
amountInput.Text = ""
amountInput.TextColor3 = Color3.fromRGB(255, 215, 0)
amountInput.TextSize = 16

-- КНОПКА ЗАПУСКА ЦИКЛА
local enterButton = Instance.new("TextButton")
enterButton.Parent = da
enterButton.BackgroundColor3 = Color3.fromRGB(35, 65, 35)
enterButton.Position = UDim2.new(0.05, 0, 0.42, 0)
enterButton.Size = UDim2.new(0, 332, 0, 45)
enterButton.Font = Enum.Font.ArialBold
enterButton.Text = "ЗАПУСТИТЬ АВТО-ОТПРАВКУ"
enterButton.TextColor3 = Color3.fromRGB(50, 255, 50)
enterButton.TextSize = 16

-- КНОПКА СТОП
local stopButton = Instance.new("TextButton")
stopButton.Parent = da
stopButton.BackgroundColor3 = Color3.fromRGB(75, 35, 35)
stopButton.Position = UDim2.new(0.05, 0, 0.62, 0)
stopButton.Size = UDim2.new(0, 332, 0, 42)
stopButton.Font = Enum.Font.ArialBold
stopButton.Text = "ОСТАНОВИТЬ ПРОЦЕСС"
stopButton.TextColor3 = Color3.fromRGB(255, 75, 75)
stopButton.TextSize = 16

-- Нижняя плашка (Статус)
local _b = Instance.new("TextLabel")
_b.Parent = da
_b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
_b.Position = UDim2.new(0, 0, 0.9, 0)
_b.Size = UDim2.new(0, 370, 0, 28)
_b.Font = Enum.Font.Arial
_b.Text = "Status: Idle"
_b.TextColor3 = Color3.fromRGB(0, 255, 255)
_b.TextSize = 13

-- ПАНЕЛЬ ЛОГИРОВАНИЯ (Копирование всего лога за один раз через Ctrl+A)
local logFrame = Instance.new("ScrollingFrame")
logFrame.Parent = mainFrame
logFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
logFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
logFrame.Position = UDim2.new(1.02, 0, 0, 0)
logFrame.Size = UDim2.new(0, 280, 0, 342)
logFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
logFrame.ScrollBarThickness = 8
logFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local giantTextBox = Instance.new("TextBox")
giantTextBox.Parent = logFrame
giantTextBox.BackgroundTransparency = 1
giantTextBox.Size = UDim2.new(1, -10, 1, 0)
giantTextBox.Font = Enum.Font.Code
giantTextBox.Text = ""
giantTextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
giantTextBox.TextSize = 12
giantTextBox.TextXAlignment = Enum.TextXAlignment.Left
giantTextBox.TextYAlignment = Enum.TextYAlignment.Top
giantTextBox.ClearTextOnFocus = false
giantTextBox.TextEditable = false
giantTextBox.TextWrapped = true

local function addLog(text)
    if giantTextBox.Text == "" then
        giantTextBox.Text = text
    else
        giantTextBox.Text = giantTextBox.Text .. "\n" .. text
    end
    
    local textHeight = giantTextBox.TextBounds.Y
    if textHeight > logFrame.CanvasSize.Y.Offset then
        logFrame.CanvasSize = UDim2.new(0, 0, 0, textHeight + 40)
    end
    giantTextBox.Size = UDim2.new(1, -10, 0, textHeight + 20)
    
    task.spawn(function()
        logFrame.CanvasPosition = Vector2.new(0, logFrame.CanvasSize.Y.Offset)
    end)
end

-- --- СИСТЕМНЫЙ МЕТОД КЛИКА ---
local function performSingleIsolatedClick(element)
    if not element or not element:IsA("GuiObject") then return end
    
    local x = element.AbsolutePosition.X + (element.AbsoluteSize.X / 2)
    local y = element.AbsolutePosition.Y + (element.AbsoluteSize.Y / 2) + 36
    
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
    task.wait(0.04)
    VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
    task.wait(0.04)
    
    pcall(function()
        element:MouseButton1Down()
        task.wait(0.02)
        if element.MouseButton1Click then element:MouseButton1Click() end
        if element.MouseButton1Up then element:MouseButton1Up() end
        
        if element.Activated then
            local io = Instance.new("InputObject")
            io.UserInputType = Enum.UserInputType.MouseButton1
            io.UserInputState = Enum.UserInputState.End
            element.Activated:Fire(io)
        end
    end)
end

-- --- ТЕЛЕПОРТ И ФИЗИЧЕСКОЕ ОТКРЫТИЕ ПОЧТЫ ЧЕРЕЗ ЗАЖАТИЕ 'E' ---
local function teleportAndOpenMailbox()
    local mailboxObject = workspace:FindFirstChild("Mailbox") or workspace:FindFirstChild("Mail Box")
    if not mailboxObject then
        -- Альтернативный поиск по названию модели, если лежит глубоко
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and (string.find(string.lower(v.Name), "mailbox") or string.find(string.lower(v.Name), "mail box")) then
                mailboxObject = v
                break
            end
        end
    end
    
    if mailboxObject then
        local targetPart = mailboxObject:FindFirstChildOfClass("Part") or mailboxObject:FindFirstChildOfClass("MeshPart") or mailboxObject.PrimaryPart
        if targetPart and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Телепортируем игрока в упор к ящику
            localPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, 0, 3)
            task.wait(0.3)
            
            -- Имитируем физическое зажатие клавиши "E" на 2.5 секунды
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(2.5)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
            task.wait(0.5)
        end
    else
        addLog("World Mailbox Object not found")
    end
end

local function getMailboxUI()
    return playerGui:FindFirstChild("MailboxUI")
end

local function closeMailboxWindow()
    local mUI = getMailboxUI()
    if mUI then
        mUI.Enabled = false
    end
end

local function getSearchAndList()
    local mUI = getMailboxUI()
    local selectPlayerFrame = mUI and mUI:FindFirstChild("Frame") 
        and mUI.Frame:FindFirstChild("SendingFrame") 
        and mUI.Frame.SendingFrame:FindFirstChild("SelectPlayerFrame")
    
    if selectPlayerFrame then
        return selectPlayerFrame:FindFirstChild("Topbar") and selectPlayerFrame.Topbar:FindFirstChild("SearchBox"), 
               selectPlayerFrame:FindFirstChild("PlayerList")
    end
end

-- СЫРОЙ ДАМП ОБЪЕКТОВ
local function dumpEntireItemFrame(itemSendFrame)
    addLog("--- СТАРТ ПОЛНОГО ДАМПА ---")
    if not itemSendFrame then
        addLog("ItemSendFrame missing")
        return
    end
    local count = 0
    for _, obj in pairs(itemSendFrame:GetDescendants()) do
        count = count + 1
        if count > 400 then 
            addLog("...и еще куча элементов (обрезано)")
            break 
        end
        addLog("Путь: " .. obj.Parent.Name .. " -> " .. obj.Name .. " (" .. obj.ClassName .. ")")
        if pcall(function() return obj.Text end) and obj.Text ~= "" then
            addLog("Текст: \"" .. obj.Text .. "\" в объекте")
        end
        task.wait(0.005)
    end
    addLog("--- КОНЕЦ ПОЛНОГО ДАМПА ---")
end

-- ДИНАМИЧЕСКИЙ ПОИСК БАМБУКА
local function getBambooButton(silent)
    local mUI = getMailboxUI()
    if not mUI then return nil end
    
    local itemSendFrame = mUI:FindFirstChild("Frame")
        and mUI.Frame:FindFirstChild("SendingFrame")
        and mUI.Frame.SendingFrame:FindFirstChild("ItemSendFrame")
    
    if not itemSendFrame then return nil end

    local inventoryFrame = itemSendFrame:FindFirstChild("ScrollingFrames")
        and itemSendFrame.ScrollingFrames:FindFirstChild("InventoryFrame")
        
    if inventoryFrame then
        for _, child in pairs(inventoryFrame:GetChildren()) do
            local nameLower = string.lower(child.Name)
            if string.find(nameLower, "bamboo") or string.find(nameLower, "бамбук") then
                local innerFrame = child:FindFirstChild("Frame")
                if innerFrame then
                    local imgButton = innerFrame:FindFirstChild("Button")
                    if imgButton then
                        local textBtn = imgButton:FindFirstChild("TextButton") or imgButton:FindFirstChildOfClass("TextButton")
                        if textBtn then
                            return textBtn
                        end
                        return imgButton
                    end
                end
            end
        end
    end
    
    if not silent then
        task.spawn(function() dumpEntireItemFrame(itemSendFrame) end)
    end
    return nil
end

local function getSendButton()
    local mUI = getMailboxUI()
    if not mUI then return nil end
    
    local itemSendFrame = mUI:FindFirstChild("Frame")
        and mUI.Frame:FindFirstChild("SendingFrame")
        and mUI.Frame.SendingFrame:FindFirstChild("ItemSendFrame")
        
    return itemSendFrame and itemSendFrame:FindFirstChild("SendButton")
end

-- --- КНОПКИ УПРАВЛЕНИЯ ---
stopButton.MouseButton1Click:Connect(function()
    isCancelled = true
    closeMailboxWindow()
    _b.Text = "Status: Force Stopped!"
    addLog("STOPPED")
end)

closeButton.MouseButton1Click:Connect(function()
    isCancelled = true
    closeMailboxWindow()
    pcall(function() ba:Destroy() end)
end)

-- --- ОСНОВНОЙ ЦИКЛ ---
enterButton.MouseButton1Click:Connect(function()
    local totalBamboo = tonumber(amountInput.Text)
    local targetName = nicknameInput.Text
    
    if not totalBamboo or totalBamboo <= 0 then return end
    if targetName == "" then return end
    
    isCancelled = false
    giantTextBox.Text = ""
    
    addLog("START")
    addLog("Target: " .. targetName)
    addLog("Amount: " .. totalBamboo)
    
    task.defer(function()
        local remainingBamboo = totalBamboo
        
        while remainingBamboo > 0 and not isCancelled do
            -- ТЕЛЕПОРТИРУЕМСЯ И ОТКРЫВАЕМ ЧЕРЕЗ ЗАЖАТИЕ 'E'
            teleportAndOpenMailbox()
            if isCancelled then break end

            local currentBatch = math.min(remainingBamboo, 20)
            _b.Text = "Status: Batch (" .. currentBatch .. " items)"
            
            local searchBox, playerList = getSearchAndList()
            if not searchBox or not playerList then
                addLog("MailboxUI missing")
                break
            end
            
            searchBox:CaptureFocus()
            task.wait(0.05)
            searchBox.Text = targetName
            task.wait(0.05)
            searchBox:ReleaseFocus(true)
            
            task.wait(1.0)
            if isCancelled then break end
            
            local targetButton = nil
            local cleanedTarget = string.lower(targetName)
            
            for _, descendant in pairs(playerList:GetDescendants()) do
                if descendant:IsA("TextLabel") and descendant.Name == "PlayerUsername" then
                    local textUI = string.lower(descendant.Text)
                    if string.sub(textUI, 1, 1) == "@" then textUI = string.sub(textUI, 2) end
                    
                    if textUI == cleanedTarget then
                        local btn = descendant:FindFirstAncestor("Button")
                        if btn and (btn:IsA("TextButton") or btn:IsA("ImageButton") or btn:IsA("GuiButton")) then
                            targetButton = btn
                            break
                        end
                    end
                end
            end
            
            if targetButton then
                task.wait(0.3)
                if isCancelled then break end
                
                performSingleIsolatedClick(targetButton)
                task.wait(2.5)
                if isCancelled then break end
                
                -- ПОКЛИКОВЫЙ ЦИКЛ С ОБНОВЛЕНИЕМ КНОПКИ И ЗАДЕРЖКОЙ 0.2 СЕКУНДЫ
                local successfullyAdded = 0
                for clickCount = 1, currentBatch do
                    if isCancelled then break end
                    
                    local bambooBtn = getBambooButton(true) 
                    if bambooBtn then
                        performSingleIsolatedClick(bambooBtn)
                        successfullyAdded = successfullyAdded + 1
                        task.wait(0.1) -- Быстрая задержка между кликами
                    else
                        addLog("No more bamboo available in UI")
                        break
                    end
                end
                
                if isCancelled then break end
                
                if successfullyAdded > 0 then
                    local sendBtn = getSendButton()
                    if sendBtn then
                        task.wait(0.4)
                        performSingleIsolatedClick(sendBtn)
                        
                        remainingBamboo = remainingBamboo - successfullyAdded
                        addLog("Batch sent. Remaining: " .. remainingBamboo)
                        task.wait(2.0)
                    end
                else
                    addLog("Bamboo not found at all")
                    break
                end
            else
                addLog("Player not found in list")
                break
            end
        end
        
        if remainingBamboo <= 0 and not isCancelled then
            _b.Text = "Status: Finished!"
            addLog("SUCCESS")
        end
    end)
end)

-- Безопасный Drag-and-Drop
task.spawn(function()
    local UIS = game:GetService("UserInputService")
    local dragToggle = false
    local dragStart = nil
    local startPos = nil

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
            local delta = input.Position - dragStart
            pcall(function()
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end)
        end
    end)
end)
