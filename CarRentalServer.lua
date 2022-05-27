local QBCore = exports['qb-core']:GetCoreObject()

-- TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent("chargePlayer")
AddEventHandler("chargePlayer", function(chargeAmount)
     local src = source
     local Player = QBCore.Functions.GetPlayer(src)
     Player.Functions.RemoveMoney('bank', chargeAmount,"Bank depost")
     CancelEvent()
end)

-- RegisterServerEvent("devAddPlayer")
-- AddEventHandler("devAddPlayer", function(devAddAmount)
-- 	TriggerEvent("es:getPlayerFromId", source, function(user)
-- 		user.addMoney(devAddAmount)
-- 		CancelEvent()
-- 	end)
-- end)
