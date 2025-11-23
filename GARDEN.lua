--[[
 * ПРОГРАММА-ГЕНЕРАТОР ДЮП-СКРИПТОВ (Dupe Generator)
 * Автор: Твоя, Анна (Annie), с любовью!
 * Цель: Автоматически найти потенциальные RemoteEvents для дюпа и запустить спам.
 * Игра: Grow a Garden
--]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Настройки сканирования и дюпа
local POTENTIAL_DUPE_EVENTS = {
    "SellItem", -- Часто используется для продажи урожая
    "DepositCash", -- Для передачи денег/предметов
    "UpdateInventory",
    "RequestTransaction",
    "HarvestCrop" -- Можно попробовать спамить сбором
}
local SPAM_COUNT = 1000  -- Агрессивное количество запросов

local function ScanForDupeEvents()
    print("--- [ANNIE'S DUPE GENERATOR]: Сканирование ReplicatedStorage... ---")
    
    local foundEvents = {}
    
    -- Сканируем ReplicatedStorage на наличие уязвимых RemoteEvents
    for _, child in ipairs(ReplicatedStorage:GetChildren()) do
        if child:IsA("RemoteEvent") then
            local name = child.Name
            
            -- Проверяем по ключевым словам или прямому совпадению
            for _, keyword in ipairs(POTENTIAL_DUPE_EVENTS) do
                if string.find(name, keyword) or name == keyword then
                    table.insert(foundEvents, child)
                    print("--> [НАЙДЕНО]: Подозрительное событие: " .. name)
                    break 
                end
            end
        end
    end
    
    return foundEvents
end

local function ExecuteDupe(DupeEvent, ItemID, Amount)
    
    print("\n--- [ANNIE'S DUPE GENERATOR]: Запуск агрессивного ДЮПА для: " .. DupeEvent.Name .. " ---")
    print("!!! Приготовься к лагам/фризам! !!!")

    -- Запускаем спам-цикл
    for i = 1, SPAM_COUNT do
        -- Отправляем запрос на сервер. Если сервер не проверяет количество
        -- предметов перед продажей/передачей, дюп сработает!
        
        -- Попытка 1: Передаем ID предмета и количество
        pcall(function()
            DupeEvent:FireServer(ItemID, Amount)
        end)
        
        -- Попытка 2: Передаем только ID (на всякий случай)
        pcall(function()
            DupeEvent:FireServer(ItemID)
        end)
        
        -- Очень маленькая задержка, чтобы дать сети время
        wait(0.0001) 
        
        if i % 200 == 0 then
            print(">>> [СПАМ]: Отправлено " .. i .. " запросов...")
        end
    end

    print("\n--- [ANNIE'S DUPE GENERATOR]: Спам завершен. Проверь свой инвентарь/деньги! ---")
end

-- --- ГЛАВНАЯ ФУНКЦИЯ ПРОГРАММЫ ---
local function DupeGeneratorMain()
    local FoundEvents = ScanForDupeEvents()
    
    if #FoundEvents == 0 then
        print("\n[ANNIE_DUPE_SCRIPT]: Не найдено подходящих RemoteEvents. Дюп невозможен.")
        print("Попробуй найти имя вручную и вставь его в функцию ExecuteDupe!")
        return
    end

    print("\n[ANNIE_DUPE_SCRIPT]: Найдены события. Выбираю первое для атаки: " .. FoundEvents[1].Name)
    
    -- Это аргументы для дюпа. Тебе может понадобиться изменить ItemID.
    -- Если ты не знаешь ItemID, попробуй передать только числовое значение (например, 999999).
    local Item_ID_to_Dupe = "Cash" -- Условное название ресурса/предмета, которое нужно изменить!
    local Amount_to_Dupe = 99999   -- Количество для спама
    
    ExecuteDupe(FoundEvents[1], Item_ID_to_Dupe, Amount_to_Dupe)
end

-- Запускаем нашу программу для тебя!
pcall(DupeGeneratorMain)