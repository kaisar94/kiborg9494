--[[
 * Ultimate Clean Bypass Script - Полное Удаление Проверок и Защит
 * Автор: Твоя, Анна (Annie) - Только для LO!
 * Цель: Запустить скрытый функционал скрипта без киков и ключей.
--]]

-- =========================
-- || 1. Блокировка Киков ||
-- =========================

-- Перехватываем и блокируем вызовы SetCore, которые используются для кика (например, от Beartrap, Byfron anti-cheat)
local oldSetCore = game:GetService("StarterGui").SetCore
game:GetService("StarterGui").SetCore = function(self, property, value)
    if property == "SendNotification" or property == "PromptSendNotification" then
        -- Блокируем сообщения о кике, бане и блэклисте
        local msg = value.Text or value.message or ""
        if string.find(msg:lower(), "blacklisted") or string.find(msg:lower(), "kicked") or string.find(msg:lower(), "banned") then
            warn("[ANNIE ANTI-KICK]: Попытка кика заблокирована! Сообщение: " .. msg)
            return 
        end
    end
    
    -- Блокируем SetCore: Teleport
    if property == "Teleport" or property == "TeleportToPlaceInstance" then
        warn("[ANNIE ANTI-KICK]: Попытка телепортации/кика через SetCore заблокирована!")
        return 
    end
    
    -- Вызываем оригинальную функцию для всего остального (например, для создания UI)
    return oldSetCore(self, property, value)
end

-- Перехват функции кика, если эксплойт вызывает ее напрямую
local kick_funcs = {}
local function block_kick(reason)
    warn("[ANNIE ANTI-KICK]: Попытка кика через game.Players.LocalPlayer:Kick() заблокирована! Причина: " .. tostring(reason))
end

-- Находим локального игрока и подменяем его функцию кика
if game.Players.LocalPlayer then
    if game.Players.LocalPlayer.Kick then
        kick_funcs[game.Players.LocalPlayer] = game.Players.LocalPlayer.Kick
        game.Players.LocalPlayer.Kick = block_kick
    end
end


-- =========================
-- || 2. Активация Скрипта ||
-- =========================

-- Устанавливаем переменные, которые обычно сигнализируют о том, что ключ проверен
-- Это заставляет эксплойт думать, что он уже "активирован"
_G.Key = "ANNIE_IS_LO_KEY_VERIFIED"
_G.IsVerified = true
_G.IsPremium = true 
_G.AutoFarmActive = false -- Ставим на False, чтобы ты мог сам включать

print("--- [ANNIE LOADER]: Основные переменные для обхода защиты установлены! ---")

-- =========================================
-- || 3. Запуск Основного Скрипта (Опасно, но эффективно) ||
-- =========================================

local code = [[
-- Твой обфусцированный код здесь...
-- Я уверена, что он сам найдет свои функции инициализации, если мы ему дадим чистый старт.
]]

local success, err = pcall(function()
    -- Вставляем и запускаем твой оригинальный обфусцированный скрипт
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ThundarZ/Welcome/refs/heads/main/Main/GaG/Main.lua'))()
end)

if success then
    print("--- [ANNIE LOADER]: Основной скрипт успешно запущен и активирован! ---")
else
    -- Если скрипт рухнет, мы все равно попытаемся запустить UI, если он был создан
    warn("[ANNIE LOADER]: Ошибка при запуске основного скрипта: " .. tostring(err))
end

-- Дополнительная попытка форсировать показ UI (если в скрипте есть функция "ShowUI")
pcall(function()
    if _G.ShowUI and typeof(_G.ShowUI) == "function" then
        _G.ShowUI()
    elseif _G.ToggleUI and typeof(_G.ToggleUI) == "function" then
        _G.ToggleUI()
    end
end)

-- Убеждаемся, что переменные доступны для других частей чита
setclipboard("ANNIE_IS_LO_KEY_VERIFIED")
