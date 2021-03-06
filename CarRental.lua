rentalTimer = .99 --How often a player should be charged in Minutes
isBeingCharged = false
autoChargeAmount = 100 -- How much a player should be charged each time
local QBCore = exports['qb-core']:GetCoreObject()
devMode = false
damageInsurance = false
damageCharge = false
canBeCharged = false
--handCuffed = false
arrestCheckAlreadyRan = false
isInPrison = false
isBlipCreated = false



Citizen.CreateThread(function()
	
	local items = { "Item 1", "Item 2", "Item 3", "Item 4", "Item 5" }
	local currentItemIndex = 1
	local selectedItemIndex = 1
	local checkBox = true
	
	pickupStation = { 
		{x = -1029.01, y = -2733.78, z = 19.04}, --Airport car rental place
		{x = 1853.82, y = 2592.28, z = 44.65}, --pd jail 
		{x = 241.49575805664, y = -756.84222412109, z = 29.82596206665}, -- PV At Legion SQ
		{x = -914.16, y = -160.85, z = 40.88}, -- PV at Boulevard Del Perro
		{x = -1179.45, y = -731.2, z = 19.5}, -- PV at North Rockford Dr
		{x = -791.74, y = 332.14, z = 84.7}, -- PV at South Mo Milton Dr
		{x = 604.92, y = 105.35, z = 91.89}, -- PV at Vinewood Blvd
		{x = 394.15, y = -1660.44, z = 26.31}, -- PV at Innocence Blvd
		{x = 1459.65, y = 3735.7, z = 32.51}, -- PV at Marina Dr
		{x = 19.39, y = 6334.73, z = 30.24}, -- PV at Great Ocean Hwy
		
	}
	
	dropoffStation = { 
		{x = -903.59967041016, y = -2310.703125, z = 5.7090353965759}, 
	}	
	
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0) -- Saniye Bekletme
	end
	
	WarMenu.CreateMenu('carRental', 'Car Rental')
	WarMenu.CreateSubMenu('closeMenu', 'carRental', 'Are you sure?')
	WarMenu.CreateSubMenu('carPicker', 'carRental', 'Pick a car | 1 day about ' .. rentalTimer ..  ' minutes')
	WarMenu.CreateSubMenu('carInsurance', 'carRental', 'Want to buy car insurance?')
	WarMenu.CreateMenu('carReturn', 'Car Return')
	WarMenu.SetSubTitle('carReturn', 'Are you going to return the car?') 
	WarMenu.CreateMenu('arrestCheck', 'Car Rental')
	WarMenu.SetSubTitle('arrestCheck', 'Are you currently being arrested?')
	
	while true do
		--Main menu
		if WarMenu.IsMenuOpened('carRental') then
			if WarMenu.MenuButton('Rent a car', 'carPicker') then
			elseif WarMenu.MenuButton('Car Insurance', 'carInsurance') then
			--elseif WarMenu.Button('DEV: Return car') then
			--	returnVehicle()
			--elseif WarMenu.Button('DEV: Delete car') then
			--	local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			--	SetEntityAsMissionEntity(currentVehicle, true, true)
			--	DeleteVehicle(currentVehicle)
			--elseif WarMenu.Button('DEV: Add 200k') then		
			--	TriggerServerEvent("devAddPlayer", 200000)
            --elseif WarMenu.CheckBox('DEV: Dev Mode', checkbox, function(checked)
            --        checkbox = checked
			--		devMode = checked
            --end) then
			--elseif WarMenu.Button('DEV: Spawn intruder') then
			--	SpawnVehicle("intruder")
			--	Citizen.Wait(100)
			--	canBeCharged = false
            --elseif WarMenu.CheckBox('DEV: Handcuffed', checkbox2, function(checked2)
            --        checkbox2 = checked2
			--		handCuffed = not checked2
            --end) then
			--elseif WarMenu.Button('DEV: TP Prison') then
			--	SetEntityCoords(GetPlayerPed(-1), 1677.233, 2658.618, 45.216)
			--elseif WarMenu.Button('DEV: TP Rental') then
			--	SetEntityCoords(GetPlayerPed(-1), -902.26593017578, -2327.3703613281, 5.7090311050415)
			--elseif WarMenu.MenuButton('Exit', 'closeMenu') then
			end
			WarMenu.SetSubTitle('carRental', 'Rent a car for a fee')
			
			WarMenu.Display()
			
		--Close menu
		elseif WarMenu.IsMenuOpened('closeMenu') then
			if WarMenu.Button('Yes') then
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('No', 'carRental') then
			end
			
			WarMenu.Display()
		
		
		elseif WarMenu.IsMenuOpened('carPicker') then
			if WarMenu.Button('Faggio | Upfront: $100 | Daily: $100') then
				SpawnVehicle("faggio")
				Citizen.Wait(2000)
				autoChargeAmount = 100
				isBeingCharged = true
			elseif WarMenu.MenuButton('Back', 'carRental') then
			end
			
			WarMenu.Display()
		
		--Return car menu
		elseif WarMenu.IsMenuOpened('carReturn') then
			if WarMenu.Button('Yes') then
				returnVehicle()
				WarMenu.CloseMenu()
			elseif WarMenu.Button('No') then
				WarMenu.CloseMenu()
			end	
			
			WarMenu.Display()

		--Car insurance menu
		elseif WarMenu.IsMenuOpened('carInsurance') then
			if WarMenu.Button('Yes | $200') then
				TriggerServerEvent("chargePlayer", 200)
				damageInsurance = true
				QBCore.Functions.Notify("Thank you for purchasing damage insurance")
				WarMenu.CloseMenu()
			elseif WarMenu.MenuButton('No', 'carRental') then
			end
			
			WarMenu.Display()
		
		--Arrest check menu
		elseif WarMenu.IsMenuOpened('arrestCheck') then
			if WarMenu.Button('Yes') then
				isBeingCharged = false
				damageInsurance = false
				damageCharge = false
				arrestCheckAlreadyRan = true
				QBCore.Functions.Notify('We have cancelled your rental.')
				WarMenu.CloseMenu()
			elseif WarMenu.Button('No') then
				WarMenu.CloseMenu()
				arrestCheckAlreadyRan = true
			end
			
			WarMenu.Display()
			
		--elseif IsControlJustReleased(0, 48) then
		--	WarMenu.OpenMenu('carRental')
		--end
		end
		


		
		Citizen.Wait(0)
	end	
	
end)
--Draw map blips
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if not isBlipCreated then 
			for _, v in pairs(pickupStation) do
				pickupBlip = AddBlipForCoord(v.x, v.y, v.z)
      			SetBlipSprite(pickupBlip, 226)
      			SetBlipDisplay(pickupBlip, 3)
      			SetBlipScale(pickupBlip, 0.6)
      			SetBlipColour(pickupBlip, 5)
      			SetBlipAsShortRange(pickupBlip, true)
	  			BeginTextCommandSetBlipName("STRING")
      			AddTextComponentString("Car Rental")
      			EndTextCommandSetBlipName(pickupBlip)
			end
			for _, v in pairs(dropoffStation) do
				pickupBlip = AddBlipForCoord(v.x, v.y, v.z)
      			SetBlipSprite(pickupBlip, 226)
      			SetBlipDisplay(pickupBlip, 3)
      			SetBlipScale(pickupBlip, 0.60)
      			SetBlipColour(pickupBlip, 1)
      			SetBlipAsShortRange(pickupBlip, true)
	  			BeginTextCommandSetBlipName("STRING")
      			AddTextComponentString("Car Dropoff")
      			EndTextCommandSetBlipName(pickupBlip)
			end
			isBlipCreated = true
		else
		end
	end
end)

--Draw markers
Citizen.CreateThread(function()
	while true do
		local sleep = true
		local coords = GetEntityCoords(GetPlayerPed(-1))
	


		for _, v in pairs(pickupStation) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 7.0) then
				sleep = false
			DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.75, 1.75, 1.75, 0, 204, 0, 100, false, true, 2, false, false, false, false)
			end
			--{title="Car Rental", colour=2, id=85, x=v.x, y=v.y, z=v.z, scale=0.75}
		end
		for _, v in pairs(dropoffStation) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 7.0) then
				sleep = false
			DrawMarker(1, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.75, 3.75, 3.75, 255, 0, 0, 100, false, true, 2, false, false, false, false)
		    end
		end
		if sleep then
			Citizen.Wait(500)
			else
				Citizen.Wait(0)
			end
	end
end)

--Check to see if player is in marker
Citizen.CreateThread(function()
	while true do
		local HasAlreadyEnteredMarker = false
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker = false
		local isInReturnMarker = false
		
		for _, v in pairs(pickupStation) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.75) then
				isInMarker = true
			end
		end
		
		for _, v in pairs(dropoffStation) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 2.75) then
				isInReturnMarker = true
			end
		end
		
		if (isInReturnMarker and not WarMenu.IsMenuOpened('carReturn')) then
			local plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
			if plate == " RENTAL " then
				WarMenu.OpenMenu('carReturn')
			end
		end
		
		if (not isInReturnMarker and not devMode and not isInMarker) then
			Citizen.Wait(100)
			WarMenu.CloseMenu()
		end
		
		if (isInMarker and not WarMenu.IsMenuOpened('carRental') and not WarMenu.IsMenuOpened('carPicker') and not WarMenu.IsMenuOpened('closeMenu') and not WarMenu.IsMenuOpened('carInsurance') and not WarMenu.IsMenuOpened('arrestCheck')) then
			WarMenu.OpenMenu('carRental')
		end
		
		if (not isInMarker and not devMode and not isInReturnMarker) then
			Citizen.Wait(100)
			WarMenu.CloseMenu()
		end
		if isInMarker then
			Citizen.Wait(0)
		else
			Citizen.Wait(500)
		end	
	end
end)

--Charge player if the car gets damaged
Citizen.CreateThread(function()
	while true do
		local playerPed = PlayerPedId()
		local sleep = true
		if IsPedInAnyVehicle(playerPed, false) then
             sleep = false
			local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			local plate = GetVehicleNumberPlateText(currentVehicle)
			if plate == " RENTAL " then
				if (IsVehicleDamaged(currentVehicle) and damageInsurance == false and damageCharge == false and canBeCharged == true) then
					damageCharge = true
					TriggerServerEvent("chargePlayer", 500)
					QBCore.Functions.Notify("You've been charged $500 for damaging the car. Buying insurance will keep you from being charged.")
				elseif (damageInsurance == true and IsVehicleDamaged(currentVehicle) and damageCharge == false) then
					QBCore.Functions.Notify("You've damaged your vehicle but due to the insurance you won't be charged.")
					damageCharge = true
				end
			end

		end	
		if sleep then
			Citizen.Wait(500)
			else
				Citizen.Wait(0)
			end


	end
end)
			

--Auto charge player every 5 minutes
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(rentalTimer*60*1000)
		if isBeingCharged == true and  IsPedInAnyVehicle(PlayerPedId()) then
			local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			local plate = GetVehicleNumberPlateText(currentVehicle)
			if plate == " RENTAL " then
				TriggerServerEvent("chargePlayer", autoChargeAmount)
				QBCore.Functions.Notify("You've been charged $" .. autoChargeAmount .. " on another day of your rental. Return the vehicle to stop the fees.")
			end
		end
	end
end)

--Spawn vehicle function
function SpawnVehicle(request)
			local hash = GetHashKey(request)

			RequestModel(hash)

			while not HasModelLoaded(hash) do
				RequestModel(hash)
				Citizen.Wait(0)
			end
		
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
			local vehicle = CreateVehicle(hash, x + 2, y + 2, z + 1, 0.0, true, false)
			SetVehicleDoorsLocked(vehicle, 1)
			SetVehicleNumberPlateText(vehicle, "RENTAL")
			canBeCharged = true
			arrestCheckAlreadyRan = false
			isInPrison = false
			exports['LegacyFuel']:SetFuel(vehicle, 100)
			
			TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(vehicle))
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
end

--Return vehicle script
function returnVehicle()
			isBeingCharged = false
			damageInsurance = false
			damageCharge = false
			QBCore.Functions.Notify("Thank you for returning your rental. Please come again!")
			local currentVehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			SetEntityAsMissionEntity(currentVehicle, true, true)
			local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
			SetEntityCoords(GetPlayerPed(-1), x - 2, y, z)
			DeleteVehicle(currentVehicle)
end


--Prison check script
Citizen.CreateThread(function()
	while true do
		local sleep = true
		local coords = GetEntityCoords(GetPlayerPed(-1))
		if(GetDistanceBetweenCoords(coords, 1677.2429199219, 2658.6179199219, 44.560031890869, true) < 2.75 and isInPrison == false) then
			sleep = false
			isInPrison = true
			QBCore.Functions.Notify("Our records show that you are currently in prison.")
			QBCore.Functions.Notify("We've taken the liberty to cancel the rental.")
			isBeingCharged = false
			damageInsurance = false
			damageCharge = false
		end
		if sleep then
			Citizen.Wait(500)
		else	
			Citizen.Wait(0)
		end
	end
end)

						
