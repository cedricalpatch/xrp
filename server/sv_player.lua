function CreatePlayer(source, identifier, name, money, gold, license, group, name)
	local self = {}

	-- Initialize all initial variables for a user
	self.source = source
	self.money = money
	self.name = name
	self.gold = gold
	self.identifier = identifier
	self.license = license
	self.group = group
	self.session = {}
	self.roles = name

	-- FXServer <3
	ExecuteCommand('add_principal identifier.' .. self.identifier .. " group." .. self.group)

	local rTable = {}

	-- Sets money for the user
	rTable.setMoney = function(m)
		if type(m) == "number" then
			local prevMoney = self.money
			local newMoney = m

			self.money = m


			TriggerClientEvent('xrp:addMoney', self.source, self.money)

			-- Checks what money UI component is enabled
			--if settings.defaultSettings.nativeMoneySystem == "0" then
				--TriggerClientEvent('xrp:activateMoney', self.source , self.money)
			--end
		else
			print('XRP_ERROR: There seems to be an issue while setting money, something else then a number was entered.')
		end
	end
	
	-- Returns money for the player
	rTable.getMoney = function()
		return self.money
	end

	-- Sets a players gold balance
	rTable.setGold = function(m)
		if type(m) == "number" then
			-- Triggers an event to save it to the database
			TriggerEvent("xrp:setPlayerData", self.source, "gold", m, function(response, success)
				self.gold = m
			end)

			TriggerClientEvent('xrp:addGold', self.source, self.gold)
		else
			log('XRP_ERROR: There seems to be an issue while setting gold, something else then a number was entered.')
			print('XRP_ERROR: There seems to be an issue while setting gold, something else then a number was entered.')
		end
	end

	-- Returns the players gold
	rTable.getGold = function()
		return self.gold
	end

	-- Kicks the player with the specified reason
	rTable.kick = function(r)
		DropPlayer(self.source, r)
	end

	-- Adds money to the user
	rTable.addMoney = function(m)
		if type(m) == "number" then
			local newMoney = self.money + m

			self.money = newMoney

			-- This is used for every UI component to tell them money was just added
			--TriggerClientEvent("xrp:addedMoney", self.source, m, (settings.defaultSettings.nativeMoneySystem == "1"), self.money)
			TriggerClientEvent('xrp:addMoney', self.source, self.money)
			
			-- Checks what money UI component is enabled
		else
			log('XRP_ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
			print('XRP_ERROR: There seems to be an issue while adding money, a different type then number was trying to be added.')
		end
	end

	-- Removes money from the user
	rTable.removeMoney = function(m)
		if type(m) == "number" then
			local newMoney = self.money - m

			self.money = newMoney

			-- This is used for every UI component to tell them money was just removed
			--TriggerClientEvent("XRP:removedMoney", self.source, m, (settings.defaultSettings.nativeMoneySystem == "1"), self.money)
			TriggerClientEvent('XRP:addMoney', self.source, self.money)

			-- Checks what money UI component is enabled
		else
			log('XRP_ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
			print('XRP_ERROR: There seems to be an issue while removing money, a different type then number was trying to be removed.')
		end
	end

	-- Adds money to a users gold
	rTable.addGold = function(m)
		if type(m) == "number" then
			local newGold = self.gold + m
			self.gold = newGold

			-- Triggers an event to tell the UI components money was just added
			TriggerClientEvent("xrp:addedGold", self.source, m)
			TriggerClientEvent('xrp:addGold', self.source, self.gold)
		else
			log('XRP_ERROR: There seems to be an issue while adding to gold, a different type then number was trying to be added.')
			print('XRP_ERROR: There seems to be an issue while adding to gold, a different type then number was trying to be added.')
		end
	end

	-- Removes money from a users gold
	rTable.removeGold = function(m)
		if type(m) == "number" then
			local newGold = self.gold - m
			self.gold = newGold

			-- Triggers an event to tell the UI components money was just removed
			TriggerClientEvent("XRP:removedGold", self.source, m)
			TriggerClientEvent('XRP:addGold', self.source, self.gold)
		else
			log('XRP_ERROR: There seems to be an issue while removing from gold, a different type then number was trying to be removed.')
			print('XRP_ERROR: There seems to be an issue while removing from gold, a different type then number was trying to be removed.')
		end
	end

	-- Session variables, handy for temporary variables attached to a player
	rTable.setSessionVar = function(key, value)
		self.session[key] = value
	end

	-- Session variables, handy for temporary variables attached to a player
	rTable.getSessionVar = function(k)
		return self.session[k]
	end

	-- Returns a users permission level
	rTable.getPermissions = function()
		return self.permission_level
	end

	-- Returns the players identifier used in EssentialMode
	rTable.getIdentifier = function(i)
		return self.identifier
	end

	-- Returns the users current active group
	rTable.getGroup = function()
		return self.group
	end

	-- Global set
	rTable.set = function(k, v)
		self[k] = v
	end

	-- Global get
	rTable.get = function(k)
		return self[k]
	end

	-- Creates globals, pretty nifty function take a look at https://docs.essentialmode.com for more info
	rTable.setGlobal = function(g, default)
		self[g] = default or ""

		rTable["get" .. g:gsub("^%l", string.upper)] = function()
			return self[g]
		end

		rTable["set" .. g:gsub("^%l", string.upper)] = function(e)
			self[g] = e
		end

		Users[self.source] = rTable
	end

	-- Returns if the user has a specific role or not
	rTable.hasRole = function(role)
		for k,v in ipairs(self.roles)do
			if v == role then
				return true
			end
		end
		return false
	end

	-- Adds a role to a user, and if they already have it it will say they had it
	rTable.giveRole = function(role)
		for k,v in pairs(self.roles)do
			if v == role then
				print("User (" .. GetPlayerName(source) .. ") already has this role")
				return
			end
		end

		-- Updates the database with the roles aswell
		self.roles[#self.roles + 1] = role
		db.updateUser(self.identifier, {roles = table.concat(self.roles, "|")}, function()end)
	end

	-- Removes a role from a user
	rTable.removeRole = function(role)
		for k,v in pairs(self.roles)do
			if v == role then
				table.remove(self.roles, k)
			end
		end

		-- Updates the database with the roles aswell
		db.updateUser(self.identifier, {roles = table.concat(self.roles, "|")}, function()end)
	end

	return rTable
end