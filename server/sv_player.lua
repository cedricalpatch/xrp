function CreatePlayer(source, identifier, name, money, gold, license, group, firstname, lastname, xp, level, job, jobgrade)
	local self = {}

	-- Initialize all initial variables for a user
	self.source = source
	self.money = money
	self.name = name
	self.gold = gold
	self.identifier = identifier
	self.license = license
	self.group = group
	self.firstname = firstname
	self.lastname = lastname
	self.xp = xp
	self.level = level
	self.job = job
	self.jobgrade = jobgrade
	self.session = {}

	
	ExecuteCommand('add_principal identifier.' .. self.identifier .. " group." .. self.group)

	local rTable = {}

	-- Sets money for the user
	rTable.setMoney = function(m)
		if type(m) == "number" then
			local prevMoney = self.money
			local newMoney = m

			self.money = m

			TriggerClientEvent('xrp:addMoney', self.source, self.money)
			TriggerClientEvent('xrp:activateMoney', self.source , self.money)


		else
			print('XRP_ERROR: There seems to be an issue while setting money, something else then a number was entered.')
		end
	end
	
	-- Returns money for the player
	rTable.getMoney = function()
		return self.money
	end

	-- SETS LEVELwXP
	rTable.setLevelwXP = function(m)
		if type(m) == "number" then
			if m > self.level then
				self.level = m
				TriggerClientEvent('xrp:addLevel', self.source, m)
				TriggerClientEvent('xrp:activateLevel', self.source , self.level)
			else
				self.level = m
				TriggerClientEvent('xrp:removeLevel', self.source, m)
				TriggerClientEvent('xrp:activateLevel', self.source , self.level)
			end

		else
			log('XRP_ERROR: There seems to be an issue while setting level, something else then a number was entered.')
			print('XRP_ERROR: There seems to be an issue while setting level, something else then a number was entered.')
		end
	end
	-- SETS LEVEL
	rTable.setLevel = function(m)
		if type(m) == "number" then
			
				self.level = m
				rTable.addXP(Levels[m] - self.xp)
				TriggerClientEvent('xrp:addLevel', self.source, self.level)
				TriggerClientEvent('xrp:activateLevel', self.source , self.level)

		else
			log('XRP_ERROR: There seems to be an issue while setting level, something else then a number was entered.')
			print('XRP_ERROR: There seems to be an issue while setting level, something else then a number was entered.')
		end
	end
	
	rTable.setXP = function(m)
		if type(m) == "number" then
			-- Triggers an event to save it to the database
			--TriggerEvent("xrp:setPlayerData", self.source, "level", m, function(response, success)
				self.xp = m
				TriggerClientEvent('xrp:addXP', self.source, m)
				TriggerClientEvent('xrp:activateXP', self.source , self.xp)
			--end)
			local case = 1, lvlNow, lvlNew
            while true do
                if self.xp > Levels[case] then
                    case = case + 1
                else 
                lvlNow = case
                break
                end
            end
            case = 1
            while true do
				cache = case + 1
                if m > Levels[cache] then
                    case = case + 1
                else 
                lvlNew = case
                break
                end
            end

            if lvlNow ~= lvlNew then
               --print("New level from " .. lvlNow .. " to " .. lvlNew)
			   rTable.setLevel(tonumber(lvlNew))
        else
        --print("Old level " .. lvlNow .. " == " .. lvlNew)
            end
		else
			log('XRP_ERROR: There seems to be an issue while setting xp, something else then a number was entered.')
			print('XRP_ERROR: There seems to be an issue while setting xp, something else then a number was entered.')
		end
	end
	
	rTable.setFirstname = function(m)
		if type(m) == "string" then
			TriggerEvent("xrp:setPlayerData", self.source, "firstname", m, function(response, success)
				self.firstname = m
			end)
		else
			log('XRP_ERROR: There seems to be an issue while setting firstname, something else then a text was entered.')
			print('XRP_ERROR: There seems to be an issue while setting firstname, something else then a text was entered.')
		end
	end
	
	rTable.setLastname = function(m)
		if type(m) == "string" then
			TriggerEvent("xrp:setPlayerData", self.source, "lastname", m, function(response, success)
				self.lastname = m
			end)
		else
			log('XRP_ERROR: There seems to be an issue while setting lastname, something else then a text was entered.')
			print('XRP_ERROR: There seems to be an issue while setting lastname, something else then a text was entered.')
		end
	end

	rTable.setJob = function(m)
		if type(m) == "string" then
			TriggerEvent("xrp:setPlayerData", self.source, "job", m, function(response, success)
				self.job = m
			end)
		else
			log('XRP_ERROR: There seems to be an issue while setting job, something else then a text was entered.')
			print('XRP_ERROR: There seems to be an issue while setting job, something else then a text was entered.')
		end
	end

	rTable.setJobgrade = function(m)
		if type(m) == "number" then
			TriggerEvent("xrp:setPlayerData", self.source, "jobgrade", m, function(response, success)
				self.jobgrade = m
			end)
		else
			log('XRP_ERROR: There seems to be an issue while setting jobgrade, something else then a text was entered.')
			print('XRP_ERROR: There seems to be an issue while setting jobgrade, something else then a text was entered.')
		end
	end
	
rTable.addXP = function(m)
        if type(m) == "number" then
            local newXP = self.xp + m

            local case = 1, lvlNow, lvlNew
            while true do
                if self.xp > Levels[case] then
                    case = case + 1
                else 
                lvlNow = case
                break
                end
            end
            case = 1
            while true do
                if newXP > Levels[case] then
                    case = case + 1
                else 
                lvlNew = case
                break
                end
            end

            if lvlNow ~= lvlNew then
               --print("New level from " .. lvlNow .. " to " .. lvlNew)
			   rTable.setLevelwXP(tonumber(lvlNew))
        else
        --print("Old level " .. lvlNow .. " == " .. lvlNew)
            end
			

			--self.xp = newXP
			if newXP > self.xp then
				self.xp = newXP
			TriggerClientEvent('xrp:addXP', self.source, m)
			TriggerClientEvent('xrp:activateXP', self.source , self.xp)
			else
				self.xp = newXP
			TriggerClientEvent('xrp:removeXP', self.source, m)
			TriggerClientEvent('xrp:activateXP', self.source , self.xp)
			end
            
        else
            log('XRP_ERROR: There seems to be an issue while adding xp, a different type then number was trying to be added.')
            print('XRP_ERROR: There seems to be an issue while adding xp, a different type then number was trying to be added.')
        end
    end
	
	-- Sets a players gold balance
	rTable.setGold = function(m)
		if type(m) == "number" then
				self.gold = m

			TriggerClientEvent('xrp:addGold', self.source, self.gold)
			TriggerClientEvent('xrp:activateGold', self.source , self.gold)
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
			
	

			TriggerClientEvent('xrp:addMoney', self.source, m)
			TriggerClientEvent('xrp:activateMoney', self.source , self.money)
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

			TriggerClientEvent('xrp:removeMoney', self.source, m)
			TriggerClientEvent('xrp:activateMoney', self.source , self.money)
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

			TriggerClientEvent('xrp:addGold', self.source, m)
			TriggerClientEvent('xrp:activateGold', self.source , self.gold)
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
			
			TriggerClientEvent('xrp:removeGold', self.source, m)
			TriggerClientEvent('xrp:activateGold', self.source , self.gold)
		else
			log('XRP_ERROR: There seems to be an issue while removing from gold, a different type then number was trying to be removed.')
			print('XRP_ERROR: There seems to be an issue while removing from gold, a different type then number was trying to be removed.')
		end
	end
	
	rTable.getXP = function()
		return self.xp
	end
	
	rTable.getName = function()
		return self.name
	end
	
	rTable.getLevel = function()
		return self.level
	end
	
	rTable.getFirstname = function()
		return self.firstname
	end
	
	rTable.getLastname = function()
		return self.lastname
	end

	rTable.getJob = function()
		return self.job
	end

	rTable.getJobgrade = function()
		return self.job
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

	return rTable
end