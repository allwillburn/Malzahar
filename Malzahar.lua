local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Malzahar" then return end


require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Malzahar/master/Malzahar.lua', SCRIPT_PATH .. 'Malzahar.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Malzahar/master/Malzahar.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local MalzaharMenu = Menu("Malzahar", "Malzahar")

MalzaharMenu:SubMenu("Combo", "Combo")

MalzaharMenu.Combo:Boolean("Q", "Use Q in combo", true)
MalzaharMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
MalzaharMenu.Combo:Boolean("W", "Use W in combo", true)
MalzaharMenu.Combo:Boolean("E", "Use E in combo", true)
MalzaharMenu.Combo:Boolean("R", "Use R in combo", true)
MalzaharMenu.Combo:Slider("RX", "X Enemies to Cast R",3,1,5,1)
MalzaharMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
MalzaharMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
MalzaharMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
MalzaharMenu.Combo:Boolean("RHydra", "Use RHydra", true)
MalzaharMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
MalzaharMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
MalzaharMenu.Combo:Boolean("Randuins", "Use Randuins", true)


MalzaharMenu:SubMenu("AutoMode", "AutoMode")
MalzaharMenu.AutoMode:Boolean("Level", "Auto level spells", false)
MalzaharMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
MalzaharMenu.AutoMode:Boolean("Q", "Auto Q", false)
MalzaharMenu.AutoMode:Boolean("W", "Auto W", false)
MalzaharMenu.AutoMode:Boolean("E", "Auto E", false)
MalzaharMenu.AutoMode:Boolean("R", "Auto R", false)

MalzaharMenu:SubMenu("LaneClear", "LaneClear")
MalzaharMenu.LaneClear:Boolean("Q", "Use Q", true)
MalzaharMenu.LaneClear:Boolean("W", "Use W", true)
MalzaharMenu.LaneClear:Boolean("E", "Use E", true)
MalzaharMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
MalzaharMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

MalzaharMenu:SubMenu("AutoFarm", "AutoFarm")
MalzaharMenu.AutoFarm:Boolean("E", "Use E", true)

MalzaharMenu:SubMenu("Harass", "Harass")
MalzaharMenu.Harass:Boolean("Q", "Use Q", true)
MalzaharMenu.Harass:Boolean("W", "Use W", true)

MalzaharMenu:SubMenu("KillSteal", "KillSteal")
MalzaharMenu.KillSteal:Boolean("Q", "KS w Q", true)
MalzaharMenu.KillSteal:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
MalzaharMenu.KillSteal:Boolean("E", "KS w E", true)
MalzaharMenu.KillSteal:Boolean("R", "KS w R", true)

MalzaharMenu:SubMenu("AutoIgnite", "AutoIgnite")
MalzaharMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

MalzaharMenu:SubMenu("Drawings", "Drawings")
MalzaharMenu.Drawings:Boolean("DE", "Draw E Range", true)

MalzaharMenu:SubMenu("SkinChanger", "SkinChanger")
MalzaharMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
MalzaharMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
	local MalzaharQ = {delay = .25, range = 900, width =400, speed = math.huge}

	--AUTO LEVEL UP
	if MalzaharMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if MalzaharMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
				if target ~= nil then 
                                     CastSkillShot(_Q, target)
                                end
            end

            if MalzaharMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 600) then
				CastTargetSpell(target, _W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if MalzaharMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if MalzaharMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			CastSpell(Randuins)
            end

            if MalzaharMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if MalzaharMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

            if MalzaharMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 650) then
			 CastTargetSpell(target, _E)
	    end

            if MalzaharMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 900) then
                local QPred = GetPrediction(target,MalzaharQ)
                       if QPred.hitChance > (MalzaharMenu.Combo.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
            end

            if MalzaharMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if MalzaharMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if MalzaharMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if MalzaharMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 600) then
			CastTargetSpell(target, _W)
	    end
	    
	    
            if MalzaharMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 700) and (EnemiesAround(myHeroPos(), 700) >= MalzaharMenu.Combo.RX:Value()) then
			CastTargetSpell(target, _R)
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                
               if IsReady(_Q) and ValidTarget(enemy, 900) and GalioMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         local QPred = GetPrediction(target, MalzaharQ)
                       if QPred.hitChance > (MalzaharMenu.KillSteal.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                end
			
                if IsReady(_E) and ValidTarget(enemy, 650) and MalzaharMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target, _E)
  
                end
			
                if IsReady(_R) and ValidTarget(enemy, 700) and MalzaharMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                      CastTargetSpell(target, _R)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if MalzaharMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 900) then
	        	CastSkillShot(_Q, closeminion)
                end

                if MalzaharMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 600) then
	        	CastTargetSpell(target, _W)
	        end

                if MalzaharMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 650) then
	        	CastTargetSpell(target, _E)
	        end

                if MalzaharMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if MalzaharMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if MalzaharMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 900) then
		      CastSkillShot(_Q, target)
          end
        end 
        if MalzaharMenu.AutoMode.W:Value() then        
          if Ready(_W) and ValidTarget(target, 600) then
	  	      CastTargetSpell(target, _W)
          end
        end
        if MalzaharMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 650) then
		      CastTargetSpell(target, _E)
	  end
        end
        if MalzaharMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 700) then
		      CastTargetSpell(target, _R)
	  end
        end
		
		--Auto on minions
    for _, minion in pairs(minionManager.objects) do
			
			   	
        if MalzaharMenu.AutoFarm.E:Value() and Ready(_E) and ValidTarget(minion, 650) and GetCurrentHP(minion) < CalcDamage(myHero,minion,EDmg,E) then
            CastTargetSpell(minion, _E)
       end
    end			
                
	--AUTO GHOST
	if MalzaharMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)


OnUpdateBuff (function(unit, buff)
	if not unit or not buff then
		return
	end
	if buff.Name == "AlZaharNetherGrasp" then
		print("R Casting spells and movements blocked!")
		IOW.movementEnabled = false
		IOW.attacksEnabled = false
		BlockF7OrbWalk(true)
		BlockF7Dodge(true)
      	rChan = true
    end
end)

OnRemoveBuff (function(unit, buff)
	if not unit or not buff then
		return
	end
	if buff.Name == "AlZaharNetherGrasp" then
		print("R Casting spells and movements unblocked!")
		IOW.movementEnabled = true
		IOW.attacksEnabled = true
		BlockF7OrbWalk(false)
		BlockF7Dodge(false)
      	rChan = false
    end
end)



OnDraw(function (myHero)
        
         if MalzaharMenu.Drawings.DE:Value() then
		DrawCircle(GetOrigin(myHero), 650, 0, 200, GoS.Black)
	end

end)





local function SkinChanger()
	if MalzaharMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Malzahar</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





