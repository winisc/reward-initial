-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("rewardTrinity",cRP)
vSERVER = Tunnel.getInterface("rewardTrinity")
-----------------------------------------------------------------------------------------------------------------------------------------
-- REWARD
-----------------------------------------------------------------------------------------------------------------------------------------

function openNui()
    local name = vSERVER.nameIdentity()
    SetNuiFocus(true,true)
    SendNuiMessage(json.encode({
        action = "open", 
        name = name
    }))
end

-- RegisterCommand("resgatarvip", function(source, args, rawCommand)
--     local ok = vSERVER.checkReward()
--     if not ok then
--         TriggerEvent('Notify', 'aviso', 'Você ja resgatou as Premiações.', 5000)
--         return false
--     end
--     openNui()
-- end)

-- RegisterNetEvent("resgatar:trinity")
-- AddEventHandler("resgatar:trinity", function()
-- 	openNui()
-- end)

RegisterNUICallback("reward",function(data, cb)
    vSERVER.rewardSever(data.model)
    SendNuiMessage(json.encode({action = "close"}))
    SetNuiFocus(false, false)
    cb('')
end)

RegisterNUICallback("close",function(data, cb)
    SendNuiMessage(json.encode({action = "close"}))
    SetNuiFocus(false, false)
    cb('')
end)