SH = ScrH()
SW = ScrW()

Ply = LocalPlayer()

RunConsoleCommand("g_ragdoll_maxcount", 0)

ItemList ={}
EnemyList ={}

BlockSkillMenu = false

PlayerSanityDropTimer = 0
PlayerSanity = 100
PlayerWood = 0
PlayerIron = 0
PlayerMaterial = 0
PlayerFixSpeed = 1
PlayerBuildingHPScaling = 1
PlayerSanityDropInterval = 1
PlayerCloaking = false

PlayerSkillPoints = 1

PlayerWoodLimit = 0
PlayerIronLimit = 0

PlayerCurPicking = 0

SyncDataTimer = 0

ShelterTurret = 0

ResourceArrowYOffset = 10
ResourceYSwitch = false

GoalString = ""

DisplayAlpha = 0
DisplayType = 0
DisplayAmout = 0
DisplayNotifyTime = 0

GoalNotifyTime = 0
GoalNotifyAlpha = 0

FullNotifyTime = 0
FullNotifyAlpha = 0

GlobalWood = 0
GlobalIron = 0
GlobalWoodLimit = 20
GlobalIronLimit = 15

Eletronic = 0

BlockKeyTimer = 0

StorageOpened = false
WorkStationOpened = false
MenuOpened = false
SkillMenuOpened = false

OldGlobalTime = 0
GlobalTime = 0
GlobalDay = 0
NightOrDay = false

AlertShowTime = 0
AlertAlpha = 0

StartTimer = 0

ReSpawnTimer = 0

RescueStarted = false

DisplayHint = true
HintAlpha = 255

UltimateCoolDown = 0

FeedbackPrinted = false

frame = NULL
ConfigMenu = NULL
ConfigMenuOpened = false

OutputString = ""
OutputString_ = ""

function IsBase(v)
    if(string.Left(v:GetModel(), 32) == "models/shigure/shelter_b_shelter") then
        return true
    else
        return false
    end
end

function ShouldLoad__()
    if(engine.ActiveGamemode() == "horde") then
        if(game.GetMap() == "gm_city23" || game.GetMap() == "hr_zsht_lostcity" || game.GetMap() == "hr_zsht_deadcity" || game.GetMap() == "hr_zsht_desertplant") then
            if(!FeedbackPrinted) then
                chat.AddText( "-----------------------------------------------------------------" )
                chat.AddText( "Addon loaded successfully!" )
                chat.AddText( "-----------------------------------------------------------------" )
            FeedbackPrinted = true
            end
            return true
        else
            if(!FeedbackPrinted) then
                chat.AddText( "-----------------------------------------------------------------" )
                chat.AddText( "Unsupported map! Addon will not load!" )
                chat.AddText( "-----------------------------------------------------------------" )
            FeedbackPrinted = true
            end
            return false
        end
    else
        if(!FeedbackPrinted) then
                chat.AddText( "-----------------------------------------------------------------" )
                chat.AddText( "Unsupported map! Addon will not load!" )
                chat.AddText( "-----------------------------------------------------------------" )
        FeedbackPrinted = true
        end
        return false
    end
end

function GetBaseUpgrade()

	local vCount = 0

	for k,v in pairs(ents.GetAll()) do
	
		if(!IsValid(v)) then continue end
		if(v:GetModel() == "models/shigure/shelter_b_shelter01.mdl") then vCount = 1 end
        if(v:GetModel() == "models/shigure/shelter_b_shelter02.mdl") then vCount = 2 end
        if(v:GetModel() == "models/shigure/shelter_b_shelter03.mdl") then vCount = 3 end
        if(v:GetModel() == "models/shigure/shelter_b_shelter04.mdl") then vCount = 4 end
        if(v:GetModel() == "models/shigure/shelter_b_shelter05.mdl") then vCount = 5 end

	end

    return vCount

end

function ClampResource(input, des)
    if(input == nil || des == nil) then return 5 end

    return math.Clamp(input - des, 1, 1024)
end

-- Skill Stuff

net.Start("SkillTreeNetworking") net.WriteInt(0, 6) net.WriteInt(0, 8) net.SendToServer() -- Sync when script is loaded

PlayerHPBoost = 0
PlayerSelfHeal = 0
PlayerLifeStealing = 0
PlayerArmorBoost = 0
PlayerPicking = 0
PlayerCapacity = 0
PlayerSanityBoost = 0
PlayerRemoteStorage = 0
PlayerBuildSpeed = 0
PlayerBuildingHP = 0
PlayerTurretDamage = 0
PlayerBuildLevel = 0
PlayerPocketStorage = 0
PlayerGunLevel = 0
PlayerAutoFix = 0
PlayerCampfire = 0
PlayerResRader = 0
PlayerLooting = 0
PlayerResourceSaving = 0
PlayerAirStrike = 0
PlayerCloak = 0

MenuCD = 0

-- End of skill stuff

net.Receive("SyncSkill", function()
    PlayerHPBoost = net.ReadInt(8)
    PlayerSelfHeal = net.ReadInt(8)
    PlayerLifeStealing = net.ReadInt(8)
    PlayerArmorBoost = net.ReadInt(8)
    PlayerArmorOnKill = net.ReadInt(8)
    PlayerPicking = net.ReadInt(8)
    PlayerCapacity = net.ReadInt(8)
    PlayerRemoteStorage = net.ReadInt(8)
    PlayerSanityBoost = net.ReadInt(8)
    PlayerBuildSpeed = net.ReadInt(8)
    PlayerBuildingHP = net.ReadInt(8)
    PlayerTurretDamage = net.ReadInt(8)
    PlayerBuildLevel = net.ReadInt(8)
    PlayerPocketStorage = net.ReadInt(8)
    PlayerGunLevel = net.ReadInt(8)
    PlayerAutoFix = net.ReadInt(8)
    PlayerCampfire = net.ReadInt(8)
    PlayerResRader = net.ReadInt(8)
    PlayerLooting = net.ReadInt(8)
    PlayerResourceSaving = net.ReadInt(8)
    PlayerAirStrike = net.ReadInt(8)
    PlayerCloak = net.ReadInt(8)
    MenuCD = CurTime() + 0.35
end)

CurrentSelectedSlot = 0
CurrentSelectedSlotNSlot = 0
InvalidTableCache = true
InvalidTableCache_ = true
CachedWSList = nil
CachedESList = nil

function GetCachedWorkstationItems()
    local tab = util.TableToJSON(ItemList)
    local str = util.Compress(tab)
    CachedWSList = str
    return CachedWSList
end

function GetCachedEnemies()
    local tab = util.TableToJSON(EnemyList)
    local str = util.Compress(tab)
    CachedESList = str
    return CachedESList
end

function SyncToServer()
    local str = GetCachedWorkstationItems()
    net.Start("SyncItemsFromClient")
        net.WriteUInt(string.len(str), 32)
        net.WriteData(str, string.len(str))
    net.SendToServer()
end

function SyncToServer_()
    local str = GetCachedEnemies()
    net.Start("SyncEnemysFromClient")
        net.WriteUInt(string.len(str), 32)
        net.WriteData(str, string.len(str))
    net.SendToServer()
end

ReloadMenu = false

CurrentSelectedSlot = nil

function OpenCFGMenu() -- This is just pain, and looks shit, I'm really bad at making menus :P
    ConfigMenu = vgui.Create("DFrame")
    ConfigMenu:SetSize(1200, 640)
    ConfigMenu:Center()
    ConfigMenu:SetTitle("Shelter Mode Config Menu")
    ConfigMenu:SetVisible(false)
    ConfigMenu:ShowCloseButton(false)
    ConfigMenu:SetDraggable(false)
    ConfigMenu:MakePopup()
    ConfigMenu:SetVisible(true)

    -- Reset selected slot
    CurrentSelectedSlot = 0
    CurrentSelectedSlotNSlot = 0

    local richtext = vgui.Create( "RichText", ConfigMenu )
        richtext:SetVerticalScrollbarEnabled( false )
        richtext:SetSize(360, 100)
        richtext:SetPos(35, 40)
        richtext:InsertColorChange(255, 255, 255, 255)
        richtext:SetText( "Slot Selected : None \n Weapon Name : None \n Weapon Class : None \n Wood Required : None \n Iron Required : None" )

    local neditor = vgui.Create("DTextEntry",  ConfigMenu)
        neditor:SetPos(35, 130)
        neditor:SetSize(230, 25)
        neditor:SetPlaceholderText("Weapon Name ( example : 9mm Pistol )")

    local ceditor = vgui.Create("DTextEntry",  ConfigMenu)
        ceditor:SetPos(35, 170)
        ceditor:SetSize(230, 25)
        ceditor:SetPlaceholderText("Weapon Class ( example : weapon_pistol )")

    local weditor = vgui.Create("DTextEntry",  ConfigMenu)
        weditor:SetPos(35, 210)
        weditor:SetSize(230, 25)
        weditor:SetPlaceholderText("Wood Required ( example : 10 )")

    local ieditor = vgui.Create("DTextEntry",  ConfigMenu)
        ieditor:SetPos(35, 250)
        ieditor:SetSize(230, 25)
        ieditor:SetPlaceholderText("Iron Required ( example : 20 )")

    local oBTN = vgui.Create("DButton", ConfigMenu)
        oBTN:SetPos(275, 210)
        oBTN:SetSize(120, 25)
        oBTN:SetText("Output Item Config")
        oBTN:SetVisible(true)
        oBTN.DoClick = function()

        if(GetConVar("horde_default_enemy_config"):GetInt() == 0) then
            OutputString_ = "CustomItemConfig = {"

                for k,v in next, ItemList do

                    print("Processing..".." | Slot : "..v[1].." | Type : "..v[2].." | Tech ID : "..v[3].." | Name : "..v[4].." | Class : "..v[5].." | Req' Wood : "..v[6].." | Req' Iron : "..v[7].." | Network ID : "..v[8].."")

                    if(k != 12) then
                            OutputString_ = OutputString_.."{"..tostring(v[1])..","..'"'..tostring(v[2])..'"'..","..tostring(v[3])..","..'"'..tostring(v[4])..'"'..","..'"'..tostring(v[5])..'"'..","..tostring(v[6])..","..tostring(v[7])..","..tostring(v[8]).."},"
                    else
                            OutputString_ = OutputString_.."{"..tostring(v[1])..","..'"'..tostring(v[2])..'"'..","..tostring(v[3])..","..'"'..tostring(v[4])..'"'..","..'"'..tostring(v[5])..'"'..","..tostring(v[6])..","..tostring(v[7])..","..tostring(v[8]).."}}"
                        if(file.IsDir("horde/shelter_mode", "DATA")) then
                            if(file.IsDir("horde/shelter_mode/output", "DATA")) then
                                file.Write("horde/shelter_mode/output/items.txt", OutputString_)
                                LocalPlayer():ChatPrint("Config output successfully! [horde/shelter_mode/output/items.txt]")
                                HORDE:PlayNotification("Config output successfully! [horde/shelter_mode/output/items.txt]", 0)
                            else
                                LocalPlayer():ChatPrint("Path [horde/shelter_mode/output] not found!, creating..")
                                HORDE:PlayNotification("Path [horde/shelter_mode/output] not found!, creating..", 1)
                            end
                        else
                            LocalPlayer():ChatPrint("Path [horde/shelter_mode] not found!, creating..")
                            HORDE:PlayNotification("Path [horde/shelter_mode] not found!, creating..", 1)
                        end
                    end


                end

        else
            HORDE:PlayNotification("You're using default config! Cannot output default config!", 1)
        end

    end

    local sBTN = vgui.Create("DButton", ConfigMenu)
        sBTN:SetPos(275, 250)
        sBTN:SetSize(120, 25)
        sBTN:SetText("Save current slot")
        sBTN:SetVisible(true)
        sBTN.DoClick = function()

            if(GetConVar("horde_default_item_config"):GetInt() == 0) then

            if(CurrentSelectedSlot != 0 && CurrentSelectedSlot != nil) then

                for k,v in next, ItemList do

                    if(v[1] == CurrentSelectedSlot) then

                        if(neditor:GetText() != "" && neditor:GetText() != nil) then

                            if(ceditor:GetText() != "" && ceditor:GetText() != nil) then

                                if(tonumber(weditor:GetText()) != nil && tonumber(ieditor:GetText()) != nil) then

                                    v[4] = neditor:GetText()
                                    v[5] = ceditor:GetText()
                                    v[6] = weditor:GetText()
                                    v[7] = ieditor:GetText()

                                    ConfigMenuOpened = false
                                    ConfigMenu:Close()

                                    HORDE:PlayNotification("Changes has been saved!, Refreshing Menu..", 0)

                                    SyncToServer()

                                    ReloadMenu = true

                                else

                                    HORDE:PlayNotification("Invalid Requirement! Is it even a number?", 1)

                                end

                            else

                                HORDE:PlayNotification("Invalid Weapon Class! Empty or nil?", 1)

                            end

                        else

                            HORDE:PlayNotification("Invalid Displayname! Empty or nil?", 1)

                        end

                    end

                end
            else
                HORDE:PlayNotification("Invalid SlotID!, Please select a slot!", 1)
            end

        else

            HORDE:PlayNotification("You're using default config! Set horde_default_item_config to 0!", 1)

        end

        end

        for k,v in next, ItemList do

            local Num = v[1]

            if(Num > 3 && Num < 7) then
                Num = Num - 3
            end

            if(Num > 6 && Num < 10) then
                Num = Num - 6
            end

            if(Num > 9) then
                Num = Num - 9
            end

            local slotBTN = vgui.Create("DButton", ConfigMenu)
                slotBTN:SetPos(35 + (70 * (Num - 1)), 290 + (35 * v[3]))
                slotBTN:SetSize(60, 25)
                slotBTN:SetText(v[4])
                slotBTN:SetVisible(true)
                slotBTN.DoClick = function()

                    CurrentSelectedSlot = v[1]

                    richtext:SetText( "Slot Selected : "..v[1].." \n Weapon Name : "..v[4].." \n Weapon Class : "..v[5].." \n Wood Required : "..v[6].." \n Iron Required : "..v[7].."" )

                    neditor:SetText(v[4])
                    ceditor:SetText(v[5])
                    weditor:SetText(v[6])
                    ieditor:SetText(v[7])

                end

        end

    local n_richtext = vgui.Create( "RichText", ConfigMenu )
        n_richtext:SetVerticalScrollbarEnabled( false )
        n_richtext:SetSize(600, 100)
        n_richtext:SetPos(700, 40)
        n_richtext:InsertColorChange(255, 255, 255, 255)
        n_richtext:SetText( "Day Selected : None \n NPC Class : None \n NPC Health : nil \n Spawn Chance (1 ~ 100) : nil" )

    local n_neditor = vgui.Create("DTextEntry",  ConfigMenu)
        n_neditor:SetPos(700, 115)
        n_neditor:SetSize(230, 25)
        n_neditor:SetPlaceholderText("NPC Class ( example : npc_zombie )")

    local n_heditor = vgui.Create("DTextEntry",  ConfigMenu)
        n_heditor:SetPos(700, 155)
        n_heditor:SetSize(230, 25)
        n_heditor:SetPlaceholderText("NPC Health ( example : 300 )")

    local n_ceditor = vgui.Create("DTextEntry",  ConfigMenu)
        n_ceditor:SetPos(700, 195)
        n_ceditor:SetSize(230, 25)
        n_ceditor:SetPlaceholderText("Spawn Chance ( 1 ~ 100 | example : 30 )")

    local n_Checkbox = vgui.Create("DCheckBoxLabel", ConfigMenu)
        n_Checkbox:SetPos( 700, 235 )
        n_Checkbox:SetText("Scale with max scale number? ")
        n_Checkbox:SetValue( false )

    local n_mseditor = vgui.Create("DTextEntry",  ConfigMenu)
        n_mseditor:SetPos(700, 265)
        n_mseditor:SetSize(230, 25)
        n_mseditor:SetPlaceholderText("HP Scaling ( example 0.15 | 0.25 = 25% )")

    local n_cBTN = vgui.Create("DButton", ConfigMenu)
        n_cBTN:SetPos(940, 195)
        n_cBTN:SetSize(120, 25)
        n_cBTN:SetText("Clear current enemy")
        n_cBTN:SetVisible(true)
        n_cBTN.DoClick = function()

        if(GetConVar("horde_default_enemy_config"):GetInt() == 0) then
            for k,v in next, EnemyList do
                 if(v[1] == CurrentSelectedSlotNSlot) then
                    v[2] = ""
                    v[3] = 0
                    v[4] = 0
                    v[5] = 0
                    v[6] = 0

                    ConfigMenuOpened = false
                    ConfigMenu:Close()

                    HORDE:PlayNotification("Changes has been saved!, Refreshing Menu..", 0)

                    SyncToServer_()

                    ReloadMenu = true
                end
            end
        else
            HORDE:PlayNotification("You're using default config! Set horde_default_enemy_config to 0!", 1)
        end

    end

    local n_oBTN = vgui.Create("DButton", ConfigMenu)
        n_oBTN:SetPos(940, 120)
        n_oBTN:SetSize(120, 25)
        n_oBTN:SetText("Output Enemy Config")
        n_oBTN:SetVisible(true)
        n_oBTN.DoClick = function()

        if(GetConVar("horde_default_enemy_config"):GetInt() == 0) then
            OutputString = "CustomEnemyConfig = {"

                for k,v in next, EnemyList do

                    local FClass = v[2]

                    if(FClass == "" || FClass == " ") then
                        FClass = "None"
                    end

                    local ScaleStr = v[5]

                    if(tonumber(v[5]) == 0) then
                        ScaleStr = "False"
                    else
                        ScaleStr = "True"
                    end

                    print("Processing..".." | Day : "..v[1].." | NPC : "..FClass.." | HP : "..v[3].." | Scale : "..ScaleStr.." | HP Scaling : "..v[6].."")

                    if(k != 32) then
                        if(tonumber(v[1]) != nil) then
                            OutputString = OutputString.."{"..""..tostring(v[1])..","..""..'"'..tostring(FClass)..'"'..","..""..tostring(v[3])..","..""..tostring(v[4])..","..""..tostring(v[5])..","..""..tostring(v[6]).."},"
                        else
                            OutputString = OutputString.."{"..""..'"'..tostring(v[1])..'"'..","..""..'"'..tostring(FClass)..'"'..","..""..tostring(v[3])..","..""..tostring(v[4])..","..""..tostring(v[5])..","..""..tostring(v[6]).."},"
                        end
                    else
                        if(tonumber(v[1]) != nil) then
                            OutputString = OutputString.."{"..""..tostring(v[1])..","..""..'"'..tostring(FClass)..'"'..","..""..tostring(v[3])..","..""..tostring(v[4])..","..""..tostring(v[5])..","..""..tostring(v[6]).."}}"
                        else
                            OutputString = OutputString.."{"..""..'"'..tostring(v[1])..'"'..","..""..'"'..tostring(FClass)..'"'..","..""..tostring(v[3])..","..""..tostring(v[4])..","..""..tostring(v[5])..","..""..tostring(v[6]).."}}"
                        end
                        if(file.IsDir("horde/shelter_mode", "DATA")) then
                            if(file.IsDir("horde/shelter_mode/output", "DATA")) then
                                file.Write("horde/shelter_mode/output/enemies.txt", OutputString)
                                LocalPlayer():ChatPrint("Config output successfully! [horde/shelter_mode/output/enemies.txt]")
                                HORDE:PlayNotification("Config output successfully! [horde/shelter_mode/output/enemies.txt]", 0)
                            else
                                LocalPlayer():ChatPrint("Path [horde/shelter_mode/output] not found!, creating..")
                                HORDE:PlayNotification("Path [horde/shelter_mode/output] not found!, creating..", 1)
                            end
                        else
                            LocalPlayer():ChatPrint("Path [horde/shelter_mode] not found!, creating..")
                            HORDE:PlayNotification("Path [horde/shelter_mode] not found!, creating..", 1)
                        end
                    end


                end

        else
            HORDE:PlayNotification("You're using default config! Cannot output default config!", 1)
        end

    end

    local n_sBTN = vgui.Create("DButton", ConfigMenu)
        n_sBTN:SetPos(940, 160)
        n_sBTN:SetSize(120, 25)
        n_sBTN:SetText("Save current enemy")
        n_sBTN:SetVisible(true)
        n_sBTN.DoClick = function()

            if(GetConVar("horde_default_enemy_config"):GetInt() == 0) then
                for k,v in next, EnemyList do
                    if(v[1] == CurrentSelectedSlotNSlot) then
                        if(n_neditor:GetText() != "" && n_neditor:GetText() != nil && string.Left(n_neditor:GetText(), 4) == "npc_") then
                            if(tonumber(n_heditor:GetText()) != nil && tonumber(n_heditor:GetText()) > 0) then
                                if(tonumber(n_ceditor:GetText()) != nil && tonumber(n_ceditor:GetText()) > 0 && tonumber(n_ceditor:GetText()) <= 100) then
                                    if(tonumber(n_mseditor:GetText()) != nil && tonumber(n_mseditor:GetText()) >= 0.1 && tonumber(n_mseditor:GetText()) <= 1) then
                                        v[2] = n_neditor:GetText()
                                        v[3] = n_heditor:GetText()
                                        v[4] = n_ceditor:GetText()

                                        if(n_Checkbox:GetChecked()) then
                                            v[5] = 1
                                        else
                                            v[5] = 0
                                        end

                                        v[6] = n_mseditor:GetText()

                                        ConfigMenuOpened = false
                                        ConfigMenu:Close()

                                        HORDE:PlayNotification("Changes has been saved!, Refreshing Menu..", 0)

                                        SyncToServer_()

                                        ReloadMenu = true
                                    else
                                        HORDE:PlayNotification("Invalid HP Scaling Number! Out of range or nil!", 1)
                                    end
                                else
                                    HORDE:PlayNotification("Invalid Spawn Chance! Out of range or nil!", 1)
                                end
                            else
                                HORDE:PlayNotification("Invalid NPC Health! Must > 0 and not nil!", 1)
                            end
                        else
                            HORDE:PlayNotification("Invalid NPC Class! Did you forgot to enter something?", 1)
                        end
                    end
                end
            else
                HORDE:PlayNotification("You're using default config! Set horde_default_enemy_config to 0!", 1)
            end
        end

    local DScrollPanel = vgui.Create( "DScrollPanel", ConfigMenu )
        DScrollPanel:SetPos(700, 325)
        DScrollPanel:SetSize(435, 300)

    for k,v in next, EnemyList do

            local n_slotBTN = DScrollPanel:Add( "DButton" )
                n_slotBTN:Dock(TOP)
                if(tonumber(v[5]) == 1) then
                    if(tonumber(v[1]) != nil) then
                        n_slotBTN:SetText("Day : "..v[1].." | "..v[2].." | HP : "..v[3].." | "..v[4].." % | Scale : Yes | "..v[6].."")
                    else
                        n_slotBTN:SetText(""..v[1].." | "..v[2].." | HP : "..v[3].." | "..v[4].." % | Scale : Yes | "..v[6].."")
                    end
                else
                    if(tonumber(v[1]) != nil) then
                        n_slotBTN:SetText("Day : "..v[1].." | "..v[2].." | HP : "..v[3].." | "..v[4].." % | Scale : No | "..v[6].."")
                    else
                        n_slotBTN:SetText(""..v[1].." | "..v[2].." | HP : "..v[3].." | "..v[4].." % | Scale : No | "..v[6].."")
                    end
                end
                n_slotBTN:SetVisible(true)
                n_slotBTN.DoClick = function()

                    CurrentSelectedSlotNSlot = v[1]

                   n_richtext:SetText( "Day Selected : "..v[1].." \n NPC Class : "..v[2].." \n NPC Health : "..v[3].." \n Spawn Chance (1 ~ 100) : "..v[4].."" )

                    n_neditor:SetText(v[2])
                    n_heditor:SetText(v[3])
                    n_ceditor:SetText(v[4])

                    if(tonumber(v[5]) == 0) then
                        n_Checkbox:SetChecked(false)
                    else
                        n_Checkbox:SetChecked(true)
                    end

                    n_mseditor:SetText(v[6])

                end

    end

    local SizeX = 1200
    local SizeY = 640

        local button = vgui.Create("DButton", ConfigMenu)
        button:SetPos((SizeX / 2) - 30, SizeY - 40)
        button:SetSize(60, 25)
        button:SetText("Close")
        button.DoClick = function()
          ConfigMenuOpened = false
          ConfigMenu:Close()
        end
end

function SkillMenu()

    frame = vgui.Create("DFrame")
    frame:SetSize(900, 480)
    frame:Center()
    frame:SetTitle("Skill Tree Menu")
    frame:SetVisible(false)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
    frame:MakePopup()
    frame:SetVisible(true)
    local richtext = vgui.Create( "RichText", frame )
    richtext:SetVerticalScrollbarEnabled( false )
    richtext:SetSize(86, 32)
    richtext:SetPos(8, 32)
    richtext:InsertColorChange(255, 255, 255, 255)
    richtext:AppendText( "Points Remain : "..PlayerSkillPoints.."" )

     local SizeX = 900
     local SizeY = 480

     -- Combat, healing stuff

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(32, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Health Boost \n "..PlayerHPBoost.." / 3 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerHPBoost < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(1, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(32, 160)
        BTN:SetSize(80, 80)
        if(PlayerHPBoost >= 3) then
            BTN:SetText("Self Heal \n "..PlayerSelfHeal.." / 1 ")
        else
            BTN:SetText("Self Heal \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerHPBoost >= 3 && PlayerSelfHeal == 0) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(2, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(32, 250)
        BTN:SetSize(80, 80)
        if(PlayerSelfHeal >= 1) then
            BTN:SetText("Life Stealing\n "..PlayerLifeStealing.." / 1 ")
        else
            BTN:SetText("Life Stealing \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerSelfHeal >= 1 && PlayerLifeStealing == 0) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(3, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(32, 350)
        BTN:SetSize(260, 80)
        if(PlayerHPBoost >= 3 && PlayerGunLevel >= 3) then
            BTN:SetText("Airstrike [ULTIMATE] \n "..PlayerAirStrike.." / 1 ")
        else
            BTN:SetText("Airstrike [ULTIMATE] \n HP Boost = 3, LMG Technology\n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerHPBoost >= 3 && PlayerGunLevel >= 3 && PlayerCloak < 1) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(21, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(122, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Armor Boost \n "..PlayerArmorBoost.." / 3 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerArmorBoost < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(4, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(122, 160)
        BTN:SetSize(80, 80)
        if(PlayerArmorBoost >= 3) then
            BTN:SetText("Armor On Kill \n "..PlayerArmorOnKill.." / 1 ")
        else
            BTN:SetText("Armor On Kill \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerArmorBoost >= 3 && PlayerArmorOnKill < 1) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(5, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(212, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("SMG \n Technology \n "..math.Clamp(PlayerGunLevel,0,1).." / 1 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
         if(PlayerGunLevel < 1) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(15, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(212, 160)
        BTN:SetSize(80, 80)
        if(PlayerGunLevel >= 1) then
            BTN:SetText("Rifle \n Technology \n "..math.Clamp(PlayerGunLevel - 1,0,1).." / 1 ")
        else
            BTN:SetText("Rifle \n Technology \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerGunLevel >= 1 && PlayerGunLevel < 2) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(15, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(212, 250)
        BTN:SetSize(80, 80)
        if(PlayerGunLevel >= 2) then
            BTN:SetText("LMG \n Technology \n "..math.Clamp(PlayerGunLevel - 2,0,1).." / 1 ")
        else
            BTN:SetText("LMG \n Technology \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerGunLevel >= 2 && PlayerGunLevel < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(15, 8) -- SubType
            net.SendToServer()
        end
        end

    ----------------------------

    -- Picking, Capacity Blah blah

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(322, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Boost Capacity\n "..PlayerCapacity.." / 5 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerCapacity < 5) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(6, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(322, 160)
        BTN:SetSize(80, 80)
        BTN:SetText("Resource Rader \n "..PlayerResRader.." / 2 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerResRader < 2) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(18, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(412, 160)
        BTN:SetSize(80, 80)
        BTN:SetText("Looting \n "..PlayerLooting.." / 3 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerLooting < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(19, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(322, 250)
        BTN:SetSize(170, 80)
        if(PlayerPicking >= 3 && PlayerCapacity >= 3) then
            BTN:SetText("Remote Storage\n "..PlayerRemoteStorage.." / 1 ")
        else
            BTN:SetText("Remote Storage\n Locked \n Capacity = 3, Picking = 3")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerPicking >= 3 && PlayerCapacity >= 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(9, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(322, 350)
        BTN:SetSize(260, 80)
        if(PlayerRemoteStorage >= 1) then
            BTN:SetText("Cloaking [ULTIMATE]\n "..PlayerCloak.." / 1 ")
        else
            BTN:SetText("Cloaking [ULTIMATE]\n Locked \n Remote Storage")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerRemoteStorage >= 1 && PlayerAirStrike <= 0) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(22, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(412, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Boost Picking\n "..PlayerPicking.." / 5 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerPicking < 5) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(7, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(502, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Boost Sanity\n "..math.Clamp(PlayerSanityBoost - 1, 0, 4).." / 3 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerSanityBoost < 4) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(8, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(502, 160)
        BTN:SetSize(80, 80)
        if(PlayerSanityBoost >= 4 ) then
            BTN:SetText("Campfire\n Technology\n "..PlayerCampfire.." / 1 ")
        else
            BTN:SetText("Campfire\n Technology\n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerCampfire < 1 && PlayerSanityBoost >= 4 ) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(17, 8) -- SubType
            net.SendToServer()
        end
        end

    ----------------------------

    -- Building stuff

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(612, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Building Speed \n "..PlayerBuildSpeed.." / 3 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerBuildSpeed < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(10, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(612, 160)
        BTN:SetSize(80, 80)
        BTN:SetText("Turret Damage \n "..PlayerTurretDamage.." / 4 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerTurretDamage < 4) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(12, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(702, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Building Health \n "..PlayerBuildingHP.." / 3 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerBuildingHP < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(11, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(702, 160)
        BTN:SetSize(80, 80)
        if(PlayerBuildingHP >= 2) then
            BTN:SetText("Auto Repair \n "..PlayerAutoFix.." / 1 ")
        else
            BTN:SetText("Auto Repair \n Locked ")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerAutoFix < 1 && PlayerBuildingHP >= 2) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(16, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(702, 250)
        BTN:SetSize(80, 80)
        BTN:SetText("Improved \nblueprint \n "..PlayerResourceSaving.." / 3 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerResourceSaving < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(20, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(792, 70)
        BTN:SetSize(80, 80)
        BTN:SetText("Basic \nEngineering \n "..math.Clamp(PlayerBuildLevel,0,1).." / 1 ")
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerBuildLevel < 1) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(13, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(792, 160)
        BTN:SetSize(80, 80)
        if(PlayerBuildLevel >= 1 ) then
            BTN:SetText("Advanced \nEngineering \n "..math.Clamp(PlayerBuildLevel - 1,0,1).." / 1 ")
        else
            BTN:SetText("Advanced \nEngineering \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerBuildLevel >= 1 && PlayerBuildLevel < 2) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(13, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(792, 250)
        BTN:SetSize(80, 80)
        if(PlayerBuildLevel >= 2 ) then
            BTN:SetText("Mastered \nEngineering \n "..(PlayerBuildLevel - 2).." / 1 ")
        else
            BTN:SetText("Mastered \nEngineering \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerBuildLevel >= 2 && PlayerBuildLevel < 3) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(13, 8) -- SubType
            net.SendToServer()
        end
        end

        local BTN = vgui.Create("DButton", frame)
        BTN:SetPos(792, 340)
        BTN:SetSize(80, 80)
        if(PlayerBuildLevel >= 3 ) then
            BTN:SetText("Pocket Storage \n "..PlayerPocketStorage.." / 1 ")
        else
            BTN:SetText("Pocket Storage \n Locked")
        end
        BTN:SetVisible(true)
        BTN.DoClick = function()
        if(PlayerBuildLevel >= 3 && PlayerPocketStorage < 1) then
            net.Start("SkillTreeNetworking")
            net.WriteInt(1, 6) -- Type
            net.WriteInt(14, 8) -- SubType
            net.SendToServer()
        end
        end

    ----------------------------

        local button = vgui.Create("DButton", frame)
        button:SetPos((SizeX / 2) - 30, SizeY - 40)
        button:SetSize(60, 25)
        button:SetText("Close")
        button.DoClick = function()
          SkillMenuOpened = false
          frame:Close()
        end

end

function BuildMenu()

	frame = vgui.Create("DFrame")
    frame:SetSize(750, 400)
    frame:Center()
    frame:SetTitle("Build Menu")
    frame:SetVisible(false)
    frame:ShowCloseButton(false)
    frame:SetDraggable(false)
	frame:MakePopup()
	frame:SetVisible(true)

 	 local SizeX = 750
 	 local SizeY = 400

 	 	-- models/galaxy/rust/wood_wall.mdl

    	local W1 = vgui.Create("DButton", frame)
        W1:SetPos(180, 35)
        W1:SetSize(125, 50)
        W1:SetText("Wooden wall \n ("..ClampResource(4, PlayerResourceSaving).." Woods)")
        W1:SetVisible(false)
        W1.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(1, 32)
        	net.WriteInt(ClampResource(4, PlayerResourceSaving), 10) -- Req Wood
        	net.WriteInt(0, 10) -- Req Iron
        	net.SendToServer()
    	end

    	-- models/galaxy/rust/spike_wall.mdl

    	local W2 = vgui.Create("DButton", frame)
        W2:SetPos(330, 35)
        W2:SetSize(125, 50)
        W2:SetText(" Small wooden spike wall \n ("..ClampResource(6, PlayerResourceSaving).." Woods, "..ClampResource(1, PlayerResourceSaving).." Irons)")
        W2:SetVisible(false)
        W2.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(2, 32)
        	net.WriteInt(ClampResource(6, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(1, PlayerResourceSaving), 10)
        	net.SendToServer()
    	end

    	-- models/galaxy/rust/spike_wall_large.mdl

    	local W3 = vgui.Create("DButton", frame)
        W3:SetPos(480, 35)
        W3:SetSize(125, 50)
        W3:SetText(" large wooden spike wall \n ("..ClampResource(8, PlayerResourceSaving).." Woods, "..ClampResource(3, PlayerResourceSaving).." Irons)")
        W3:SetVisible(false)
        W3.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(3, 32)
        	net.WriteInt(ClampResource(8, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(3, PlayerResourceSaving), 10)
        	net.SendToServer()
    	end

    	-- models/galaxy/rust/metal_wall.mdl

    	local W4 = vgui.Create("DButton", frame)
        W4:SetPos(180, 95)
        W4:SetSize(125, 45)
        W4:SetText(" Metal wall \n ("..ClampResource(2, PlayerResourceSaving).." Woods, "..ClampResource(3, PlayerResourceSaving).." Irons) \n Req : WorkStation'")
        W4:SetVisible(false)
        W4.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(4, 32)
        	net.WriteInt(ClampResource(2, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(3, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
    	end

    	-- models/galaxy/rust/metal_window.mdl

    	local W5 = vgui.Create("DButton", frame)
        W5:SetPos(330, 95)
        W5:SetSize(125, 45)
        W5:SetText(" Metal wall (Windowed) \n ("..ClampResource(2, PlayerResourceSaving).." Woods, "..ClampResource(4, PlayerResourceSaving).." Irons) \n Req : WorkStation")
        W5:SetVisible(false)
        W5.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(5, 32)
        	net.WriteInt(ClampResource(2, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(4, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
    	end

    	-- models/nickmaps/rostok/p19_portao.mdl

    	local W12 = vgui.Create("DButton", frame)
        W12:SetPos(480, 95)
        W12:SetSize(125, 45)
        W12:SetText(" Metal fence \n ("..ClampResource(1, PlayerResourceSaving).." Woods, "..ClampResource(6, PlayerResourceSaving).." Irons) \n Req : WorkStation")
        W12:SetVisible(false)
        W12.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(12, 32)
        	net.WriteInt(ClampResource(1, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(6, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
    	end

    	-- models/galaxy/rust/metal_stairs.mdl

    	local W6 = vgui.Create("DButton", frame)
        W6:SetPos(480, 215)
        W6:SetSize(125, 45)
        W6:SetText(" Metal Stair \n ("..ClampResource(2, PlayerResourceSaving).." Woods, "..ClampResource(7, PlayerResourceSaving).." Irons) \n Req : WorkStation")
        W6:SetVisible(false)
        W6.DoClick = function()
			net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(6, 32)
        	net.WriteInt(ClampResource(2, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(7, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
   		end
        	
        -- models/nickmaps/rostok/bar_parede_uniq.mdl

    	local W7 = vgui.Create("DButton", frame)
        W7:SetPos(180, 155)
        W7:SetSize(125, 45)
        W7:SetText(" Concrete wall \n ("..ClampResource(4, PlayerResourceSaving).." Woods, "..ClampResource(3, PlayerResourceSaving).." Irons) \n Req : Cement Mixer")
        W7:SetVisible(false)
        W7.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(7, 32)
        	net.WriteInt(ClampResource(4, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(3, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(2, 3)
        	net.SendToServer()
    	end

        local W8 = vgui.Create("DButton", frame)
        W8:SetPos(330, 155)
        W8:SetSize(125, 45)
        W8:SetText("Reinforced concrete wall \n ("..ClampResource(5, PlayerResourceSaving).." Woods, "..ClampResource(8, PlayerResourceSaving).." Irons) \n Req : C. Mixer, Lv.4 Base")
        W8:SetVisible(false)
        W8.DoClick = function()
        if(GetBaseUpgrade() >= 5) then
            net.Start("BuildNetworking")
            net.WriteInt(1, 6)
            net.WriteInt(36, 32)
            net.WriteInt(ClampResource(5, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(8, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(2, 3)
            net.SendToServer()
        end
        end

        local W14 = vgui.Create("DButton", frame)
        W14:SetPos(480, 155)
        W14:SetSize(125, 45)
        W14:SetText("Metal gate \n ("..ClampResource(2, PlayerResourceSaving).." Woods, "..ClampResource(10, PlayerResourceSaving).." Irons) \n 30 Power, Req : Lv.2 Base")
        W14:SetVisible(false)
        W14.DoClick = function()
        if(GetBaseUpgrade() >= 3) then
            net.Start("BuildNetworking")
            net.WriteInt(1, 6)
            net.WriteInt(37, 32)
            net.WriteInt(ClampResource(2, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(10, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(1, 3)
            net.SendToServer()
        end
        end

    	-- models/galaxy/rust/wood_ramp.mdl

    	local W10 = vgui.Create("DButton", frame)
        W10:SetPos(180, 215)
        W10:SetSize(125, 45)
        W10:SetText(" Wooden ramp \n ("..ClampResource(5, PlayerResourceSaving).." Woods, "..ClampResource(2, PlayerResourceSaving).." Irons)")
        W10:SetVisible(false)
        W10.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(10, 32)
        	net.WriteInt(ClampResource(5, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(2, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(0, 3)
        	net.SendToServer()
    	end

    	-- models/galaxy/rust/wood_stairs.mdl

    	local W11 = vgui.Create("DButton", frame)
        W11:SetPos(330, 215)
        W11:SetSize(125, 45)
        W11:SetText(" Wooden stair \n ("..ClampResource(7, PlayerResourceSaving).." Woods, "..ClampResource(3, PlayerResourceSaving).." Irons)")
        W11:SetVisible(false)
        W11.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(11, 32)
        	net.WriteInt(ClampResource(7, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(3, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(0, 3)
        	net.SendToServer()
    	end

        -- models/galaxy/rust/wood_foundation.mdl

        local W13 = vgui.Create("DButton", frame)
        W13:SetPos(180, 275)
        W13:SetSize(125, 45)
        W13:SetText(" Wooden platform \n ("..ClampResource(12, PlayerResourceSaving).." Woods, "..ClampResource(4, PlayerResourceSaving).." Irons)")
        W13:SetVisible(false)
        W13.DoClick = function()
            net.Start("BuildNetworking")
            net.WriteInt(1, 6)
            net.WriteInt(33, 32)
            net.WriteInt(ClampResource(12, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(4, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(0, 3)
            net.SendToServer()
        end

    	-- models/nickmaps/stalker/military/unique/towers/metal_radio_tower_antenna.mdl

    	local CAF = vgui.Create("DButton", frame)
        CAF:SetPos(25, 40)
        CAF:SetSize(125, 45)
        CAF:SetText(" Tele tower \n ("..ClampResource(93, PlayerResourceSaving * 3).." Woods, "..ClampResource(82, PlayerResourceSaving * 3).." Irons) \n 120 Power, Lv.4 Base")
        CAF:SetVisible(true)
        CAF.DoClick = function()
        if(GetBaseUpgrade() >= 5) then
            if(PlayerBuildLevel >= 3) then
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(12, 32)
        	net.WriteInt(ClampResource(93, PlayerResourceSaving * 3), 10)
        	net.WriteInt(ClampResource(82, PlayerResourceSaving * 3), 10)
        	net.WriteInt(120, 32)
        	net.WriteInt(2, 3)
        	net.SendToServer()
        else
            HORDE:PlayNotification("Mastered Engineering Required!", 1)
        end
        end
    	end

    	-- models/galaxy/rust/campfire.mdl

    	local CF = vgui.Create("DButton", frame)
        CF:SetPos(25, 90)
        CF:SetSize(125, 45)
        CF:SetText(" Campfire \n ("..ClampResource(3, PlayerResourceSaving).." Woods, "..ClampResource(1, PlayerResourceSaving).." Irons) \n WorkStation")
        CF:SetVisible(true)
        CF.DoClick = function()
        if(PlayerCampfire != 0) then
        	net.Start("BuildNetworking")
        	net.WriteInt(1, 6)
        	net.WriteInt(32, 32)
        	net.WriteInt(ClampResource(3, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(1, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
        else
            HORDE:PlayNotification("Campfire Technology Required!", 1)
        end
    	end

    	-- models/galaxy/rust/bed.mdl

    	local CH = vgui.Create("DButton", frame)
        CH:SetPos(25, 140)
        CH:SetSize(125, 45)
        CH:SetText(" Healing Station \n ("..ClampResource(12, PlayerResourceSaving).." Woods, "..ClampResource(8, PlayerResourceSaving).." Irons) \n 20 Power")
        CH:SetVisible(true)
        CH.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(4, 32)
        	net.WriteInt(ClampResource(12, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(8, PlayerResourceSaving), 10)
        	net.WriteInt(20, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
    	end

    	-- models/nickmaps/rostok/bar_maquinario_p3.mdl

    	local CM = vgui.Create("DButton", frame)
        CM:SetPos(25, 190)
        CM:SetSize(125, 45)
        CM:SetText(" Cement Mixer \n ("..ClampResource(65, PlayerResourceSaving * 3).." Woods, "..ClampResource(50, PlayerResourceSaving * 3).." Irons) \n 100 Power, Lv.2 Base \n ")
        CM:SetVisible(true)
        CM.DoClick = function()
        if(GetBaseUpgrade() >= 3) then
            if(PlayerBuildLevel >= 2) then
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(3, 32)
        	net.WriteInt(ClampResource(65, PlayerResourceSaving * 3), 10)
        	net.WriteInt(ClampResource(50, PlayerResourceSaving * 3), 10)
        	net.WriteInt(100, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
        else
            HORDE:PlayNotification("Advanced Engineering Required!", 1)
        end
        end
    	end

    	-- models/props_lab/workspace004.mdl

    	local WS = vgui.Create("DButton", frame)
        WS:SetPos(25, 240)
        WS:SetSize(125, 45)
        WS:SetText(" WorkStation \n ("..ClampResource(33, PlayerResourceSaving * 3).." Woods, "..ClampResource(27, PlayerResourceSaving * 3).." Irons) \n 65 Power")
        WS:SetVisible(true)
        WS.DoClick = function()
        if(PlayerBuildLevel >= 1) then
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(2, 32)
        	net.WriteInt(ClampResource(33, PlayerResourceSaving * 3), 10)
        	net.WriteInt(ClampResource(27, PlayerResourceSaving * 3), 10)
        	net.WriteInt(65, 32)
            net.WriteInt(0, 3)
        	net.SendToServer()
        else
            HORDE:PlayNotification("Basic Engineering Required!", 1)
        end
    	end

    	-- models/props_lab/reciever_cart.mdl

    	local G1 = vgui.Create("DButton", frame)
        G1:SetPos(180, 35)
        G1:SetSize(125, 50)
        G1:SetText(" Small Generator \n ("..ClampResource(5, PlayerResourceSaving).." Woods, "..ClampResource(5, PlayerResourceSaving).." Irons)")
        G1:SetVisible(false)
        G1.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(2, 6)
        	net.WriteInt(1, 32)
        	net.WriteInt(ClampResource(5, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(5, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
    	end

    	-- models/z-o-m-b-i-e/st/equipment_cache/st_equipment_electric_box_01.mdl

    	local G2 = vgui.Create("DButton", frame)
        G2:SetPos(330, 35)
        G2:SetSize(125, 50)
        G2:SetText(" Medium Generator \n ("..ClampResource(9, PlayerResourceSaving).." Woods, "..ClampResource(7, PlayerResourceSaving).." Irons) \n Req : WorkStation")
        G2:SetVisible(false)
        G2.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(2, 6)
        	net.WriteInt(2, 32)
        	net.WriteInt(ClampResource(9, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(7, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
    	end

    	-- models/props_wasteland/laundry_washer003.mdl

    	local G3 = vgui.Create("DButton", frame)
        G3:SetPos(180, 95)
        G3:SetSize(125, 50)
        G3:SetText(" Large Generator \n ("..ClampResource(12, PlayerResourceSaving).." Woods, "..ClampResource(10, PlayerResourceSaving).." Irons) \n Req : Cement Mixer")
        G3:SetVisible(false)
        G3.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(2, 6)
        	net.WriteInt(3, 32)
        	net.WriteInt(ClampResource(12, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(10, PlayerResourceSaving), 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(2, 3)
        	net.SendToServer()
    	end

        local G4 = vgui.Create("DButton", frame)
        G4:SetPos(330, 95)
        G4:SetSize(125, 50)
        G4:SetText(" Mega Generator \n ("..ClampResource(18, PlayerResourceSaving).." Woods, "..ClampResource(15, PlayerResourceSaving).." Irons) \n Req : Lv.4 Base")
        G4:SetVisible(false)
        G4.DoClick = function()
        if(GetBaseUpgrade() >= 5) then
            net.Start("BuildNetworking")
            net.WriteInt(2, 6)
            net.WriteInt(4, 32)
            net.WriteInt(ClampResource(18, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(15, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(2, 3)
            net.SendToServer()
        end
        end

 	 	-- models/vj_hlr/hl1/gturret_mini.mdl

    	local T1 = vgui.Create("DButton", frame)
        T1:SetPos(180, 35)
        T1:SetSize(125, 50)
        T1:SetText("Basic Turret \n ("..ClampResource(5, PlayerResourceSaving).." Woods, "..ClampResource(5, PlayerResourceSaving).." Irons) \n 15 Power")
        T1:SetVisible(false)
        T1.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(4, 6)
        	net.WriteInt(1, 32)
        	net.WriteInt(ClampResource(5, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(5, PlayerResourceSaving), 10)
        	net.WriteInt(15, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
    	end

        local Trap1 = vgui.Create("DButton", frame)
        Trap1:SetPos(330, 35)
        Trap1:SetSize(125, 50)
        Trap1:SetText("Spike trap \n ("..ClampResource(3, PlayerResourceSaving).." Woods, "..ClampResource(3, PlayerResourceSaving).." Irons)")
        Trap1:SetVisible(false)
        Trap1.DoClick = function()
            net.Start("BuildNetworking")
            net.WriteInt(1, 6)
            net.WriteInt(39, 32)
            net.WriteInt(ClampResource(3, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(3, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(0, 3)
            net.SendToServer()
        end

        local Trap2 = vgui.Create("DButton", frame)
        Trap2:SetPos(480, 35)
        Trap2:SetSize(125, 50)
        Trap2:SetText("Landmine \n ("..ClampResource(2, PlayerResourceSaving).." Woods, "..ClampResource(4, PlayerResourceSaving).." Irons)")
        Trap2:SetVisible(false)
        Trap2.DoClick = function()
            net.Start("BuildNetworking")
            net.WriteInt(1, 6)
            net.WriteInt(38, 32)
            net.WriteInt(ClampResource(2, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(4, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(0, 3)
            net.SendToServer()
        end

 	 	-- models/vj_hlr/decay/sentry.mdl

    	local T2 = vgui.Create("DButton", frame)
        T2:SetPos(180, 95)
        T2:SetSize(125, 50)
        T2:SetText("Advanced Turret \n ("..ClampResource(10, PlayerResourceSaving).." Woods, "..ClampResource(8, PlayerResourceSaving).." Irons) \n 20 Power, Lv.2 Base")
        T2:SetVisible(false)
        T2.DoClick = function()
        if(GetBaseUpgrade() >= 3) then
        	net.Start("BuildNetworking")
        	net.WriteInt(4, 6)
        	net.WriteInt(2, 32)
        	net.WriteInt(ClampResource(10, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(8, PlayerResourceSaving), 10)
        	net.WriteInt(20, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
        end
    	end

        -- models/vj_hlr/decay/sentry.mdl

        local TR2 = vgui.Create("DButton", frame)
        TR2:SetPos(330, 95)
        TR2:SetSize(125, 50)
        TR2:SetText("Freeze Bomb \n ("..ClampResource(4, PlayerResourceSaving).." Woods, "..ClampResource(4, PlayerResourceSaving).." Irons) \n Lv.2 Base")
        TR2:SetVisible(false)
        TR2.DoClick = function()
        if(GetBaseUpgrade() >= 3) then
            net.Start("BuildNetworking")
            net.WriteInt(1, 6)
            net.WriteInt(35, 32)
            net.WriteInt(ClampResource(4, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(4, PlayerResourceSaving), 10)
            net.WriteInt(0, 32)
            net.WriteInt(1, 3)
            net.SendToServer()
        end
        end

 	 	-- models/vj_hlr/hl1/gturret.mdl

    	local T3 = vgui.Create("DButton", frame)
        T3:SetPos(180, 155)
        T3:SetSize(125, 50)
        T3:SetText("Minigun Turret \n ("..ClampResource(17, PlayerResourceSaving).." Woods, "..ClampResource(14, PlayerResourceSaving).." Irons) \n 30 Power, Lv.3 Base")
        T3:SetVisible(false)
        T3.DoClick = function()
        if(GetBaseUpgrade() >= 4) then
        	net.Start("BuildNetworking")
        	net.WriteInt(4, 6)
        	net.WriteInt(3, 32)
        	net.WriteInt(ClampResource(17, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(14, PlayerResourceSaving), 10)
        	net.WriteInt(30, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
        end
    	end

        -- models/vj_hlr/hl1/sentry.mdl

        local T4 = vgui.Create("DButton", frame)
        T4:SetPos(330, 155)
        T4:SetSize(125, 50)
        T4:SetText("Blast Turret \n ("..ClampResource(24, PlayerResourceSaving).." Woods, "..ClampResource(20, PlayerResourceSaving).." Irons) \n 40 Power, Lv.3 Base")
        T4:SetVisible(false)
        T4.DoClick = function()
        if(GetBaseUpgrade() >= 4) then
            net.Start("BuildNetworking")
            net.WriteInt(4, 6)
            net.WriteInt(4, 32)
            net.WriteInt(ClampResource(24, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(20, PlayerResourceSaving), 10)
            net.WriteInt(40, 32)
            net.WriteInt(0, 3)
            net.SendToServer()
        end
        end

        -- models/props_combine/combinethumper002.mdl

        local T5 = vgui.Create("DButton", frame)
        T5:SetPos(180, 215)
        T5:SetSize(125, 50)
        T5:SetText("Mortar Cannon \n ("..ClampResource(30, PlayerResourceSaving).." Woods, "..ClampResource(25, PlayerResourceSaving).." Irons) \n 40 Power, Lv.4 Base")
        T5:SetVisible(false)
        T5.DoClick = function()
        if(GetBaseUpgrade() >= 5) then
            net.Start("BuildNetworking")
            net.WriteInt(1, 6)
            net.WriteInt(34, 32)
            net.WriteInt(ClampResource(30, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(25, PlayerResourceSaving), 10)
            net.WriteInt(40, 32)
            net.WriteInt(2, 3)
            net.SendToServer()
        end
        end

        -- models/vj_hlr/hl1/alien_cannon.mdl

        local T6 = vgui.Create("DButton", frame)
        T6:SetPos(330, 215)
        T6:SetSize(125, 50)
        T6:SetText("Railgun Turret \n ("..ClampResource(35, PlayerResourceSaving).." Woods, "..ClampResource(28, PlayerResourceSaving).." Irons) \n 55 Power, Lv.4 Base")
        T6:SetVisible(false)
        T6.DoClick = function()
        if(GetBaseUpgrade() >= 5) then
            net.Start("BuildNetworking")
            net.WriteInt(4, 6)
            net.WriteInt(5, 32)
            net.WriteInt(ClampResource(35, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(28, PlayerResourceSaving), 10)
            net.WriteInt(55, 32)
            net.WriteInt(2, 3)
            net.SendToServer()
        end
        end

    	-- models/z-o-m-b-i-e/st/konteyner/st_container_11.mdl 

    	local ST1 = vgui.Create("DButton", frame)
        ST1:SetPos(180, 35)
        ST1:SetSize(125, 45)
        ST1:SetText("Basic Storage \n ("..ClampResource(10, PlayerResourceSaving).." Woods, "..ClampResource(8, PlayerResourceSaving).." Irons) \n 15 Power")
        ST1:SetVisible(false)
        ST1.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(1, 32)
        	net.WriteInt(ClampResource(10, PlayerResourceSaving), 10)
        	net.WriteInt(ClampResource(8, PlayerResourceSaving), 10)
        	net.WriteInt(15, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
    	end

    	-- models/nickmaps/rostok/p19_casa2.mdl

    	local ST2 = vgui.Create("DButton", frame)
        ST2:SetPos(330, 35)
        ST2:SetSize(125, 45)
        ST2:SetText("Medium Storage \n ("..ClampResource(18, PlayerResourceSaving).." Woods, "..ClampResource(12, PlayerResourceSaving).." Irons) \n 20 Power, WorkStation")
        ST2:SetVisible(false)
        ST2.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(10, 32)
            net.WriteInt(ClampResource(18, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(12, PlayerResourceSaving), 10)
        	net.WriteInt(20, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
    	end

    	-- models/z-o-m-b-i-e/stalker/jupiter/j_cement_cistern_05_roof_03.mdl

    	local ST3 = vgui.Create("DButton", frame)
        ST3:SetPos(480, 35)
        ST3:SetSize(125, 45)
        ST3:SetText("Large Storage \n ("..ClampResource(28, PlayerResourceSaving).." Woods, "..ClampResource(19, PlayerResourceSaving).." Irons) \n 35 Power, Cement Mixer")
        ST3:SetVisible(false)
        ST3.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(11, 32)
            net.WriteInt(ClampResource(28, PlayerResourceSaving), 10)
            net.WriteInt(ClampResource(19, PlayerResourceSaving), 10)
        	net.WriteInt(35, 32)
        	net.WriteInt(2, 3)
        	net.SendToServer()
    	end

    	--[[
    	local TWR = vgui.Create("DButton", frame)
        TWR:SetPos(25, 340)
        TWR:SetSize(125, 45)
        TWR:SetText("Watch tower \n "..ClampResource(43, PlayerResourceSaving * 3).." Woods, "..ClampResource(75, PlayerResourceSaving * 3).." Irons \n 35 Power, WorkStation")
        TWR:SetVisible(true)
        TWR.DoClick = function()
        	net.Start("BuildNetworking")
        	net.WriteInt(3, 6)
        	net.WriteInt(13, 32)
        	net.WriteInt(ClampResource(43, PlayerResourceSaving * 3), 10)
        	net.WriteInt(ClampResource(75, PlayerResourceSaving * 3), 10)
        	net.WriteInt(35, 32)
        	net.WriteInt(1, 3)
        	net.SendToServer()
    	end
        ]]
        

    	local ff = false
    	local tt = true

    	local ST = vgui.Create("DButton", frame)
        ST:SetPos(25, 290)
        ST:SetSize(125, 45)
        ST:SetText("Storage")
        ST:SetVisible(true)
        ST.DoClick = function()
        	W1:SetVisible(ff)
        	W2:SetVisible(ff)
        	W3:SetVisible(ff)
        	W4:SetVisible(ff)
        	W5:SetVisible(ff)
        	W6:SetVisible(ff)
        	W7:SetVisible(ff)
        	W8:SetVisible(ff)
        	W10:SetVisible(ff)
        	W11:SetVisible(ff)
        	W12:SetVisible(ff)
            W13:SetVisible(ff)
            W14:SetVisible(ff)

        	G1:SetVisible(ff)
        	G2:SetVisible(ff)
        	G3:SetVisible(ff)
            G4:SetVisible(ff)

        	T1:SetVisible(ff)
        	T2:SetVisible(ff)
        	T3:SetVisible(ff)
            T4:SetVisible(ff)
            T5:SetVisible(ff)
            T6:SetVisible(ff)

            Trap1:SetVisible(ff)
            Trap2:SetVisible(ff)

            TR2:SetVisible(ff)

        	ST1:SetVisible(tt)
        	ST2:SetVisible(tt)
        	ST3:SetVisible(tt)
    	end

    	local WS = vgui.Create("DButton", frame)
        WS:SetPos(((SizeX / 2) - 50) + 100, SizeY - 50)
        WS:SetSize(100, 35)
        WS:SetText("Obstacles")
        WS.DoClick = function()
        	W1:SetVisible(tt)
        	W2:SetVisible(tt)
        	W3:SetVisible(tt)
        	W4:SetVisible(tt)
        	W5:SetVisible(tt)
        	W6:SetVisible(tt)
        	W7:SetVisible(tt)
        	W8:SetVisible(tt)
        	W10:SetVisible(tt)
        	W11:SetVisible(tt)
        	W12:SetVisible(tt)
            W13:SetVisible(tt)
            W14:SetVisible(tt)

        	G1:SetVisible(ff)
        	G2:SetVisible(ff)
        	G3:SetVisible(ff)
            G4:SetVisible(ff)

        	T1:SetVisible(ff)
        	T2:SetVisible(ff)
        	T3:SetVisible(ff)
            T4:SetVisible(ff)
            T5:SetVisible(ff)
            T6:SetVisible(ff)

            Trap1:SetVisible(ff)
            Trap2:SetVisible(ff)

            TR2:SetVisible(ff)

        	ST1:SetVisible(ff)
        	ST2:SetVisible(ff)
        	ST3:SetVisible(ff)
    	end

    	local PG = vgui.Create("DButton", frame)
        PG:SetPos(((SizeX / 2) - 50) + 205, SizeY - 50)
        PG:SetSize(100, 35)
        PG:SetText("Generators")
        PG.DoClick = function()
        	W1:SetVisible(ff)
        	W2:SetVisible(ff)
        	W3:SetVisible(ff)
        	W4:SetVisible(ff)
        	W5:SetVisible(ff)
        	W6:SetVisible(ff)
        	W7:SetVisible(ff)
        	W8:SetVisible(ff)
        	W10:SetVisible(ff)
        	W11:SetVisible(ff)
        	W12:SetVisible(ff)
            W13:SetVisible(ff)
            W14:SetVisible(ff)

        	G1:SetVisible(tt)
        	G2:SetVisible(tt)
        	G3:SetVisible(tt)
            G4:SetVisible(tt)

        	T1:SetVisible(ff)
        	T2:SetVisible(ff)
        	T3:SetVisible(ff)
            T4:SetVisible(ff)
            T5:SetVisible(ff)
            T6:SetVisible(ff)

            Trap1:SetVisible(ff)
            Trap2:SetVisible(ff)

            TR2:SetVisible(ff)

        	ST1:SetVisible(ff)
        	ST2:SetVisible(ff)
        	ST3:SetVisible(ff)
    	end

    	local TS = vgui.Create("DButton", frame)
        TS:SetPos(((SizeX / 2) - 50) + 310, SizeY - 50)
        TS:SetSize(100, 35)
        TS:SetText("Defenses")
        TS.DoClick = function()
        	W1:SetVisible(ff)
        	W2:SetVisible(ff)
        	W3:SetVisible(ff)
        	W4:SetVisible(ff)
        	W5:SetVisible(ff)
        	W6:SetVisible(ff)
        	W7:SetVisible(ff)
        	W8:SetVisible(ff)
        	W10:SetVisible(ff)
        	W11:SetVisible(ff)
        	W12:SetVisible(ff)
            W13:SetVisible(ff)
            W14:SetVisible(ff)

        	G1:SetVisible(ff)
        	G2:SetVisible(ff)
        	G3:SetVisible(ff)
            G4:SetVisible(ff)

        	T1:SetVisible(tt)
        	T2:SetVisible(tt)
        	T3:SetVisible(tt)
            T4:SetVisible(tt)
            T5:SetVisible(tt)
            T6:SetVisible(tt)

            Trap1:SetVisible(tt)
            Trap2:SetVisible(tt)

            TR2:SetVisible(tt)

        	ST1:SetVisible(ff)
        	ST2:SetVisible(ff)
        	ST3:SetVisible(ff)
    	end

    	local button = vgui.Create("DButton", frame)
        button:SetPos((SizeX / 2) - 30, SizeY - 40)
        button:SetSize(60, 25)
        button:SetText("Close")
        button.DoClick = function()
      	  MenuOpened = false
          frame:Close()
    	end
end

function GetTechType(idx)
    if(idx == 0) then
        return "[Pistol]"
    end
    if(idx == 1) then
        return "[SMG / SG]"
    end
    if(idx == 2) then
        return "[Rifle]"
    end
    if(idx == 3) then
        return "[LMG]"
    end
end

function OpenWorkStation()
   frame = vgui.Create("DFrame")
   frame:SetSize(600, 600)
   frame:Center()
   frame:SetTitle("WorkStation")
   frame:SetVisible(true)
   frame:ShowCloseButton(false)
   frame:SetDraggable(false)
   frame:MakePopup()
   
   local vSize = frame:GetSize()

    local Button = vgui.Create("DButton", frame)
        Button:SetPos(40, 35)
        Button:SetSize(125, 50)
        Button:SetText("Make Ammos \n 4 Woods, 4 Irons")
        Button:SetVisible(true)
        Button.DoClick = function()
            net.Start("WorkStationNetWorking")
            net.WriteInt(5, 6)
            net.WriteInt(6, 32)
            net.WriteInt(4, 10)
            net.WriteInt(4, 10)
            net.WriteInt(0, 32)
            net.WriteInt(0, 3)
            net.SendToServer()
        end

	local Button = vgui.Create("DButton", frame)
        Button:SetPos(40, 95)
        Button:SetSize(125, 50)
        Button:SetText("Make Armor (15) \n 2 Woods, 3 Irons")
        Button:SetVisible(true)
        Button.DoClick = function()
        	net.Start("WorkStationNetWorking")
        	net.WriteInt(5, 6)
        	net.WriteInt(8, 32)
        	net.WriteInt(2, 10)
        	net.WriteInt(3, 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
    	end

	local Button = vgui.Create("DButton", frame)
        Button:SetPos(40, 155)
        Button:SetSize(125, 50)
        Button:SetText("Make Armor (Full) \n 18 Woods, 15 Irons")
        Button:SetVisible(true)
        Button.DoClick = function()
        	net.Start("WorkStationNetWorking")
        	net.WriteInt(5, 6)
        	net.WriteInt(9, 32)
        	net.WriteInt(18, 10)
        	net.WriteInt(15, 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
    	end

    local Button = vgui.Create("DButton", frame)
        Button:SetPos(240, 35)
        Button:SetSize(125, 50)
        if(ShelterTurret == 0) then
            Button:SetText("Basic Turret \n 30 Woods, 30 Irons")
        end
        if(ShelterTurret == 1) then
            Button:SetText("Minigun Turret \n 30 Woods, 30 Irons")
        end
        if(ShelterTurret == 2) then
            Button:SetText("--Done--")
        end
        Button:SetVisible(true)
        Button.DoClick = function()
        if(ShelterTurret < 2) then
            net.Start("WorkStationNetWorking")
            net.WriteInt(3, 6)
            net.WriteInt(40, 32)
            net.WriteInt(30, 10)
            net.WriteInt(30, 10)
            net.WriteInt(0, 32)
            net.WriteInt(0, 3)
            net.SendToServer()
        end
        end

        for k,v in next, ItemList do -- Fuck this

            local Num = v[1]

            if(Num > 3 && Num < 7) then
                Num = Num - 3
            end

            if(Num > 6 && Num < 10) then
                Num = Num - 6
            end

            if(Num > 9) then
                Num = Num - 9
            end

        local Button = vgui.Create("DButton", frame)
            Button:SetPos(40 + ((Num - 1) * 200), 320 + (v[3] * 60))
            Button:SetSize(125, 50)
            Button:SetText(""..GetTechType(v[3]).." "..v[4].."\n"..v[6].." Woods "..v[7].." Irons")
            Button:SetVisible(true)
            Button.DoClick = function()
                if(PlayerGunLevel >= v[3]) then
                    net.Start("WorkStationNetWorking")
                    net.WriteInt(5, 6)
                    net.WriteInt(v[8], 32)
                    net.WriteInt(v[6], 10)
                    net.WriteInt(v[7], 10)
                    net.WriteInt(0, 32)
                    net.WriteInt(0, 3)
                    net.SendToServer()
                else
                    if(v[3] == 1) then
                        HORDE:PlayNotification("SMG, SG Technology Required!", 1)
                    end
                    if(v[3] == 2) then
                        HORDE:PlayNotification("Rifle Technology Required!", 1)
                    end
                    if(v[3] == 3) then
                        HORDE:PlayNotification("LMG Technology Required!", 1)
                    end
                end
            end

        end

	local Button = vgui.Create("DButton", frame)
        Button:SetPos(440, 35)
        Button:SetSize(125, 50)
        Button:SetText("Increase base HP \n 25 Woods, 17 Irons")
        Button:SetVisible(true)
        Button.DoClick = function()
        	net.Start("WorkStationNetWorking")
        	net.WriteInt(3, 6)
        	net.WriteInt(36, 32)
        	net.WriteInt(25, 10)
        	net.WriteInt(17, 10)
        	net.WriteInt(0, 32)
        	net.WriteInt(0, 3)
        	net.SendToServer()
    	end

    local vCount = 0

	local Button = vgui.Create("DButton", frame)
        Button:SetPos(440, 95)
        Button:SetSize(125, 50)
        if(GetBaseUpgrade() < 3) then
        	Button:SetText("Lv.2 Base \n 82 Woods, 73 Irons \n 100 Power, WorkStation")
        else
        	Button:SetText("Lv.2 Base \n --Done--")
    	end
        Button:SetVisible(true)
        Button.DoClick = function()
        	if(GetBaseUpgrade() < 3) then
        		net.Start("WorkStationNetWorking")
        		net.WriteInt(3, 6)
        		net.WriteInt(37, 32)
        		net.WriteInt(82, 10)
        		net.WriteInt(73, 10)
        		net.WriteInt(100, 32)
        		net.WriteInt(1, 3)
        		net.SendToServer()
        	end
    	end

    local Button = vgui.Create("DButton", frame)
        Button:SetPos(440, 155)
        Button:SetSize(125, 50)
        if(GetBaseUpgrade() < 4) then
            Button:SetText("Lv.3 Base \n 157 Woods, 143 Irons \n 130 Power, Cement Mixer")
        else
            Button:SetText("Lv.3 Base \n --Done--")
        end
        Button:SetVisible(true)
        Button.DoClick = function()
            if(GetBaseUpgrade() < 4) then
                net.Start("WorkStationNetWorking")
                net.WriteInt(3, 6)
                net.WriteInt(38, 32)
                net.WriteInt(157, 10)
                net.WriteInt(143, 10)
                net.WriteInt(130, 32)
                net.WriteInt(2, 3)
                net.SendToServer()
            end
        end

    local Button = vgui.Create("DButton", frame)
        Button:SetPos(440, 215)
        Button:SetSize(125, 50)
        if(GetBaseUpgrade() < 5) then
            Button:SetText("Lv.4 Base \n 192 Woods, 170 Irons \n 150 Power, Lv.3 Base")
        else
            Button:SetText("Lv.4 Base \n --Done--")
        end
        Button:SetVisible(true)
        Button.DoClick = function()
            if(GetBaseUpgrade() < 5) then
                net.Start("WorkStationNetWorking")
                net.WriteInt(3, 6)
                net.WriteInt(39, 32)
                net.WriteInt(157, 10)
                net.WriteInt(143, 10)
                net.WriteInt(130, 32)
                net.WriteInt(2, 3)
                net.SendToServer()
            end
        end

      local button = vgui.Create("DButton", frame)
      button:SetPos(270, 565)
      button:SetSize(60, 25)
      button:SetText("Close")
      button.DoClick = function()
         frame:Close()
         WorkStationOpened = false
     end

end

function OpenBuyMenu()
   local frame = vgui.Create("DFrame")
   frame:SetSize(400, 250)
   frame:Center()
   frame:SetTitle("Storage Menu")
   frame:SetVisible(true)
   frame:ShowCloseButton(false)
   frame:SetDraggable(false)
   frame:MakePopup()
   
   local vSize = frame:GetSize()

      -- Take

      local button = vgui.Create("DButton", frame)
      button:SetPos(25, 45)
      button:SetSize(150, 30)
      button:SetText("Take a wood from storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(1, 8)
        net.WriteInt(1, 8)
        net.WriteInt(1, 8)
        net.SendToServer()
     end

      local button = vgui.Create("DButton", frame)
      button:SetPos(225, 45)
      button:SetSize(150, 30)
      button:SetText("Take a iron from storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(1, 8)
        net.WriteInt(2, 8)
        net.WriteInt(1, 8)
        net.SendToServer()
     end

      local button = vgui.Create("DButton", frame)
      button:SetPos(25, 85)
      button:SetSize(150, 30)
      button:SetText("Take 4 wood from storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(1, 8)
        net.WriteInt(1, 8)
        net.WriteInt(4, 8)
        net.SendToServer()
     end

      local button = vgui.Create("DButton", frame)
      button:SetPos(225, 85)
      button:SetSize(150, 30)
      button:SetText("Take 4 iron from storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(1, 8)
        net.WriteInt(2, 8)
        net.WriteInt(4, 8)
        net.SendToServer()
     end

     -- Put

      local button = vgui.Create("DButton", frame)
      button:SetPos(25, 135)
      button:SetSize(150, 30)
      button:SetText("Put a wood in storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(2, 8)
        net.WriteInt(1, 8)
        net.WriteInt(1, 8)
        net.SendToServer()
     end

      local button = vgui.Create("DButton", frame)
      button:SetPos(225, 135)
      button:SetSize(150, 30)
      button:SetText("Put a iron in storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(2, 8)
        net.WriteInt(2, 8)
        net.WriteInt(1, 8)
        net.SendToServer()
     end

      local button = vgui.Create("DButton", frame)
      button:SetPos(25, 175)
      button:SetSize(150, 30)
      button:SetText("Put 4 wood in storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(2, 8)
        net.WriteInt(1, 8)
        net.WriteInt(4, 8)
        net.SendToServer()
     end

      local button = vgui.Create("DButton", frame)
      button:SetPos(225, 175)
      button:SetSize(150, 30)
      button:SetText("Put 4 iron in storage")
      button.DoClick = function()
        net.Start("TransferStorage")
        net.WriteInt(2, 8)
        net.WriteInt(2, 8)
        net.WriteInt(4, 8)
        net.SendToServer()
     end

      local button = vgui.Create("DButton", frame)
      button:SetPos(170, 215)
      button:SetSize(60, 25)
      button:SetText("Close")
      button.DoClick = function()
        Ply:ConCommand("play items/ammocrate_close.wav")
         frame:Close()
         StorageOpened = false
     end


end

function ResourceType(ent)

    if(ent:GetModel() == "models/galaxy/rust/woodpile1.mdl") then
        return 1
    end
    if(ent:GetModel() == "models/props_junk/ibeam01a_cluster01.mdl") then
        return 2
    end
    if(ent:GetModel() == "models/galaxy/rust/rockore4.mdl") then
        return 3
    end

end

function DrawInfo(ent)

    if(!IsValid(ent)) then return end
    if(!IsResource(ent)) then return end
    local Pos =  (ent:GetPos() + Vector(0,0,10)):ToScreen()
    local Num = ent:Health()

    if(ResourceType(ent) == 1) then -- 1 = Wood, 2 = Iron, 3 = That rock thingy
        draw.DrawText( "[Wood] "..math.floor(ent:GetMaxHealth() / 100).."/"..math.floor(ent:Health() / 100).."", "TargetID", Pos.x, Pos.y, color_white, TEXT_ALIGN_CENTER )
    end

    if(ResourceType(ent) == 2) then
        draw.DrawText( "[Iron] "..math.floor(ent:GetMaxHealth() / 100).."/"..math.floor(ent:Health() / 100).."", "TargetID", Pos.x, Pos.y, color_white, TEXT_ALIGN_CENTER )
    end

end

function DrawArrow(ent)

	local Pos =  (ent:GetPos() + Vector(0,0,50)):ToScreen()

	draw.DrawText( "▼", "TargetID", Pos.x, Pos.y - ResourceArrowYOffset, color_white, TEXT_ALIGN_CENTER )

end

function DrawUseKey(ent)

	local Pos =  (ent:GetPos() + Vector(0,0,25)):ToScreen()

	draw.DrawText( 'Press "USE" key', "TargetID", Pos.x, Pos.y, color_white, TEXT_ALIGN_CENTER )

end

function IsResource(ent)

	if(ent:GetModel() == "models/galaxy/rust/woodpile1.mdl" || ent:GetModel() == "models/props_junk/ibeam01a_cluster01.mdl" || ent:GetModel() == "models/galaxy/rust/rockore4.mdl") then
		return true
	else
		return false
	end

end

function IsTurret(ent)

    if(ent:GetClass() == "npc_vj_hlr1_gturret_mini" || ent:GetClass() == "npc_vj_hlr1_gturret" || ent:GetClass() == "npc_vj_hlrdc_sentry" || ent:GetClass() == "npc_vj_hlr1_sentry" || ent:GetClass() == "npc_vj_hlr1_xen_cannon") then
        return true
    else
        return false
    end

end

local BHP = 0
local BMHP = 0

surface.CreateFont("DayFont", {
    size = 30,
    weight = 32,
    antialias = true,
    font = "Arial",
})

NotifyH = 0

IconAlpha = 0

UltimateCD = 0

if(ShouldLoad__()) then

hook.Add( "HUDPaint", "HUDPaint_DrawABox", function()

    if(IsValid(Ply)) then

	local FixedY = SH - 300
	local FixedY_2 = SH - 450
	local FixedY_3 = SH - 550
    local FixedY_4 = SH - 650

	if(GoalNotifyTime > CurTime()) then
		NotifyH = math.Clamp(NotifyH + 2, 0, 75)
		if(NotifyH >= 75) then
			GoalNotifyAlpha = math.Clamp(GoalNotifyAlpha + 5, 0, 230)
		end
	else
		NotifyH = math.Clamp(NotifyH - 2, 0, 75)
		GoalNotifyAlpha = math.Clamp(GoalNotifyAlpha - 10, 0, 230)
	end

	surface.SetDrawColor( 0, 0, 0, 170 )
	surface.DrawRect( 0, SH / 3, SW, NotifyH )
	draw.DrawText( GoalString, "DayFont", (SW / 2), (SH / 3) + 25, Color(255,255,255,GoalNotifyAlpha), TEXT_ALIGN_CENTER )

    draw.DrawText( "Build Menu - Hold melee + Reload Key \n SkillTree Menu - Key [N] \n Config Menu - Key [F6]", "DayFont", (SW / 2), (SH / 1.3), Color(255,255,255,HintAlpha), TEXT_ALIGN_CENTER )

    if(!DisplayHint) then
        HintAlpha = math.Clamp(HintAlpha - 5, 0, 255)
    end

	for x,y in pairs(ents.FindByClass("prop_physics_multiplayer")) do

		if(IsBase(y)) then

			BHP = y:Health()
			BMHP = y:GetMaxHealth()

		end

	end

	local Object = LocalPlayer():GetEyeTrace().Entity

	if(StartTimer > CurTime()) then
		draw.DrawText( "Game start in "..(math.floor(StartTimer - CurTime())).." seconds", "ChatFont", SW / 2, (SH / 2) + 80, color_white, TEXT_ALIGN_CENTER )
	end

	if(IsValid(Object)) then
		if(Object:GetClass() == "prop_physics_multiplayer") then
			if(IsResource(Object)) then
				draw.DrawText( "Resource Deposit | "..(Object:GetMaxHealth() / 100).." / "..(Object:Health() / 100).."", "ChatFont", SW / 2, (SH / 2) + 60, color_white, TEXT_ALIGN_CENTER )
			else
				local Num = math.floor((Object:Health() / Object:GetMaxHealth()) * 100)
                if(Object:GetModel() == "models/props_wasteland/cargo_container01.mdl") then
                    draw.DrawText( "Destructible Obstacle | "..Object:GetMaxHealth().." / "..Object:Health().." ("..Num.."%)", "ChatFont", SW / 2, (SH / 2) + 60, Color(255,200,200), TEXT_ALIGN_CENTER )
                else
                    draw.DrawText( "Friendly Building | "..Object:GetMaxHealth().." / "..Object:Health().." ("..Num.."%)", "ChatFont", SW / 2, (SH / 2) + 60, color_white, TEXT_ALIGN_CENTER )
                end
			end
		end
        if(IsTurret(Object)) then
            local Num = math.floor((Object:Health() / Object:GetMaxHealth()) * 100)
            draw.DrawText( "Friendly Turret | "..Object:GetMaxHealth().." / "..Object:Health().." ("..Num.."%)", "ChatFont", SW / 2, (SH / 2) + 60, color_white, TEXT_ALIGN_CENTER )
        end
	end

    if(PlayerAirStrike != 0 || PlayerCloak != 0) then
        local UltimateSkill = "NULL"
        if(PlayerAirStrike != 0) then
            UltimateSkill = "AirStrike"
        end
        if(PlayerCloak != 0) then
            UltimateSkill = "Cloaking"
            if(PlayerCloaking) then
                UltimateCD = GetConVar("horde_zshelter_custom_ultimate_cooldown_cloak"):GetInt()
                UltimateCoolDown = GetConVar("horde_zshelter_custom_ultimate_cooldown_cloak"):GetInt()
            end
        end
        if(input.IsKeyDown(KEY_LALT) && UltimateCoolDown <= 0) then
            if(PlayerAirStrike != 0) then
                net.Start("SendAirStrike")
                net.SendToServer()
                UltimateCD = GetConVar("horde_zshelter_custom_ultimate_cooldown_airstrike"):GetInt()
                UltimateCoolDown = GetConVar("horde_zshelter_custom_ultimate_cooldown_airstrike"):GetInt()
            end
            if(PlayerCloak != 0) then
                net.Start("SendCloak")
                net.SendToServer()
                UltimateCD = GetConVar("horde_zshelter_custom_ultimate_cooldown_cloak"):GetInt()
                UltimateCoolDown = GetConVar("horde_zshelter_custom_ultimate_cooldown_cloak"):GetInt()
            end
        end
        surface.SetDrawColor( 0, 0, 0, 128 )
        surface.DrawRect( 25, FixedY_4, 180, 80 )
        if(UltimateCoolDown <= 0) then
            draw.DrawText( "Ultimate Ready", "TargetID", 115, FixedY_4 + 13, color_white, TEXT_ALIGN_CENTER )
            draw.DrawText( "[ALT] to active", "TargetID", 115, FixedY_4 + 33, color_white, TEXT_ALIGN_CENTER )
        else
            draw.DrawText( "Ultimate in \ncooldown", "TargetID", 115, FixedY_4 + 13, color_white, TEXT_ALIGN_CENTER )
        end

        surface.SetDrawColor( 0, 0, 0, 150 )
        surface.DrawRect( 43, FixedY_4 + 60, 140, 8 )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawRect( 43, FixedY_4 + 60, 140 - ((140 / UltimateCD) * (UltimateCoolDown)), 8 )
    end

	surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawRect( 25, FixedY_3, 180, 80 )

    if(!RescueStarted) then
	   draw.DrawText( "Day : " ..GlobalDay.."", "DayFont", 115, FixedY_3 + 13, color_white, TEXT_ALIGN_CENTER )
    else
        draw.DrawText( "Rescuing", "DayFont", 115, FixedY_3 + 13, color_white, TEXT_ALIGN_CENTER )
    end
    if(!RescueStarted) then
	   if(NightOrDay) then
		  draw.DrawText( "Night - " ..GlobalTime.."", "TargetID", 110, FixedY_3 + 50, color_white, TEXT_ALIGN_CENTER )
	   else
		  draw.DrawText( "Day - " ..GlobalTime.."", "TargetID", 110, FixedY_3 + 50, color_white, TEXT_ALIGN_CENTER )
	   end
    else
        draw.DrawText( "Rescue - " ..GlobalTime.."", "TargetID", 110, FixedY_3 + 50, color_white, TEXT_ALIGN_CENTER )
    end

	surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawRect( 25, FixedY_2, 256, 128 )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( 41, FixedY_2 + 110, 220, 8 )

	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawRect( 41, FixedY_2 + 110, 220 - ((220 / BMHP) * (BMHP - BHP)), 8 )

	draw.DrawText( "Wood in base : "..GlobalWood.." / "..GlobalWoodLimit.."", "TargetID", 40, FixedY_2 + 10, color_white, TEXT_ALIGN_LEFT )
	draw.DrawText( "Iron in base : "..GlobalIron.." / "..GlobalIronLimit.."", "TargetID", 40, FixedY_2 + 35, color_white, TEXT_ALIGN_LEFT )
	draw.DrawText( "Power : "..Eletronic.."", "TargetID", 40, FixedY_2 + 60, color_white, TEXT_ALIGN_LEFT )
	draw.DrawText( "Base Health : "..math.floor((100 * (BHP / BMHP))).." %", "TargetID", 40, FixedY_2 + 85, color_white, TEXT_ALIGN_LEFT )

	surface.SetDrawColor( 0, 0, 0, 150 )
	surface.DrawRect( 41, FixedY + 109, 220, 8 )

	surface.SetDrawColor( 255, 55 + PlayerSanity * 2, 55 + PlayerSanity * 2, 255 )
	surface.DrawRect( 41, FixedY + 109, 220 - (2.2 * (100 - PlayerSanity)), 8 )

	surface.SetDrawColor( 0, 0, 0, 128 )
	surface.DrawRect( 25, FixedY, 256, 128 )

	draw.DrawText( "Wood : "..PlayerWood.." / "..PlayerWoodLimit.."", "TargetID", 40, FixedY + 10, color_white, TEXT_ALIGN_LEFT )
	draw.DrawText( "Iron : "..PlayerIron.." / "..PlayerIronLimit.."", "TargetID", 40, FixedY + 35, color_white, TEXT_ALIGN_LEFT )
    if(PlayerSkillPoints == 0) then
	   draw.DrawText( "Skill Points : "..PlayerSkillPoints.."", "TargetID", 40, FixedY + 60, color_white, TEXT_ALIGN_LEFT )
    else
        draw.DrawText( "Skill Points : "..PlayerSkillPoints.." [N]", "TargetID", 40, FixedY + 60, color_white, TEXT_ALIGN_LEFT )
    end
	draw.DrawText( "Sanity : ", "TargetID", 40, FixedY + 85, color_white, TEXT_ALIGN_LEFT )

	if(ResourceArrowYOffset <= 5) then
		ResourceYSwitch = true
	end
	if(ResourceArrowYOffset >= 40) then
		ResourceYSwitch = false
	end

	if(ResourceYSwitch) then
		ResourceArrowYOffset = ResourceArrowYOffset + 0.25
	else
		ResourceArrowYOffset = ResourceArrowYOffset - 0.25
	end

	for k,v in pairs(ents.FindByClass("prop_physics_multiplayer")) do

		if(!IsValid(v)) then continue end

		if(v:GetModel() == "models/nickmaps/rostok/p20_tank_pumps.mdl" || v:GetModel() == "models/nickmaps/rostok/p19_casa2.mdl" || v:GetModel() == "models/items/ammocrate_ar2.mdl" || v:GetModel() == "models/shigure/shelter_b_warehouse01.mdl" || v:GetModel() == "models/props_lab/workspace004.mdl" || v:GetModel() == "models/nickmaps/stalker/military/unique/towers/metal_radio_tower_antenna.mdl" || v:GetModel() == "models/props_lab/blastdoor001c.mdl") then

			if(v:GetPos():Distance(Ply:GetPos()) <= 512 && v:GetColor().a == 255) then
				DrawUseKey(v)
			end
		end

		if(IsResource(v)) then

			if(v:GetPos():Distance(Ply:GetPos()) <= 425 + (PlayerResRader * 425)) then

                if(PlayerResRader != 0) then
                    DrawInfo(v)
                end
				DrawArrow(v)

			end

		end

	end

	if(!Ply:Alive()) then
		PlayerSanity = 100
		local SpawnTime = math.floor(ReSpawnTimer - CurTime())
		if(SpawnTime >= 0) then
			draw.DrawText( "Respawn after "..SpawnTime.." seconds", "TargetID", (SW / 2), (SH / 2) + 25, Color(255,255,255,255), TEXT_ALIGN_CENTER )
		end
	end

		surface.SetDrawColor( 0, 0, 0, AlertAlpha )
		surface.DrawRect( (SW / 2) - 128, (SH / 1.8), 256, 64 )
		draw.DrawText( "Base is under attack!", "TargetID", (SW / 2), (SH / 1.8) + 18, Color(255,255,255,AlertAlpha), TEXT_ALIGN_CENTER )

		if(AlertShowTime > CurTime()) then
			AlertAlpha = math.Clamp(AlertAlpha + 5, 0, 210)
		else
			AlertAlpha = math.Clamp(AlertAlpha - 5, 0, 210)
		end

		surface.SetDrawColor( 0, 0, 0, FullNotifyAlpha )
		surface.DrawRect( (SW / 2) - 128, (SH / 1.5), 256, 64 )
		draw.DrawText( "Capacity is full \n cannot take more resources", "TargetID", (SW / 2), (SH / 1.5) + 18, Color(255,255,255,FullNotifyAlpha), TEXT_ALIGN_CENTER )

		surface.SetDrawColor( 0, 0, 0, DisplayAlpha )
		surface.DrawRect( (SW / 2) - 128, (SH / 1.5), 256, 64 )

		if(DisplayType == 1) then
			draw.DrawText( "Got "..DisplayAmout.." wood", "TargetID", (SW / 2), (SH / 1.5) + 18, Color(255,255,255,DisplayAlpha), TEXT_ALIGN_CENTER )
		end
		if(DisplayType == 2) then
			draw.DrawText( "Got "..DisplayAmout.." iron", "TargetID", (SW / 2), (SH / 1.5) + 18, Color(255,255,255,DisplayAlpha), TEXT_ALIGN_CENTER )
		end

	if(FullNotifyTime > CurTime()) then
		FullNotifyAlpha = math.Clamp(FullNotifyAlpha + 5, 0, 210)
	else
		FullNotifyAlpha = math.Clamp(FullNotifyAlpha - 5, 0, 210)
	end

	if(DisplayNotifyTime > CurTime()) then
		DisplayAlpha = math.Clamp(DisplayAlpha + 5, 0, 210)
	else
		DisplayAlpha = math.Clamp(DisplayAlpha - 5, 0, 210)
	end

end

end )
end


pColour = 0
pBrig = 1

net.Receive("ResetBrightness", function()
    pColour = 0
    pBrig = 1
end)

HandAlpha = 1

if(ShouldLoad__()) then
hook.Add("PreDrawPlayerHands", "DrawHandHandler", function()
    if(PlayerCloaking) then
        HandAlpha = 0.4
    else
        HandAlpha = 1
    end
    render.SetBlend(HandAlpha)
end)

hook.Add( "RenderScreenspaceEffects", "SpaceHandler", function()
    
local tab = {
	[ "$pp_colour_addr" ] = pColour,
	[ "$pp_colour_addg" ] = pColour,
	[ "$pp_colour_addb" ] = pColour,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = pBrig,
	[ "$pp_colour_colour" ] = pBrig,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

local tabfreeze = {
    [ "$pp_colour_addr" ] = 0.1,
    [ "$pp_colour_addg" ] = 0.1,
    [ "$pp_colour_addb" ] = 0.3,
    [ "$pp_colour_brightness" ] = 0,
    [ "$pp_colour_contrast" ] = pBrig,
    [ "$pp_colour_colour" ] = pBrig,
    [ "$pp_colour_mulr" ] = 0,
    [ "$pp_colour_mulg" ] = 0,
    [ "$pp_colour_mulb" ] = 0
}

    if(LocalPlayer():IsFrozen()) then
        DrawColorModify( tabfreeze )
    else
	   DrawColorModify( tab )
    end

end )
end

OldGTCache = 0 

if(ShouldLoad__()) then
hook.Add( "Tick", "TickHandler", function()

    if(OldGlobalTime != math.floor(CurTime())) then

        UltimateCoolDown = math.Clamp(UltimateCoolDown - 1, 0, 90)
        OldGlobalTime = math.floor(CurTime())
    end

    if(HasOtherLang != nil) then -- Unload
        if(HasOtherLang == true) then
            hook.Remove( "HUDPaint", "HUDPaint_DrawABox")
            hook.Remove( "RenderScreenspaceEffects", "SpaceHandler")
            hook.Remove( "Tick", "TickHandler")
            hook.Remove( "StartChat", "SChatHandler")
            hook.Remove( "FinishChat", "FChatHandler")
            hook.Remove( "InitPostEntity", "InitHandler")
        end
    end

    if(IsValid(Ply)) then

	if(OldGTCache != GlobalTime) then -- Runs 1/sec

		if(!NightOrDay) then
			if(GlobalTime <= 16) then
				pColour = math.Clamp(pColour - 0.015, -0.1, 0)
				pBrig  = math.Clamp(pBrig - 0.085, 0.25, 1)
			end
		else
			if(GlobalTime <= 16) then
				pColour = math.Clamp(pColour + 0.015, -0.1, 0)
				pBrig  = math.Clamp(pBrig + 0.085, 0.25, 1)
			end
		end

		OldGTCache = GlobalTime
	end

	GlobalWood = math.Clamp(GlobalWood, 0, GlobalWoodLimit)
	GlobalIron = math.Clamp(GlobalIron, 0, GlobalIronLimit)

	net.Receive("CloseMenu", function() if(IsValid(frame)) then frame:Close() MenuOpened = false StorageOpened = false WorkStationOpened = false SkillMenuOpened = false MenuCD = CurTime() + 0.35 print("Menu closed by server.") end end)
	net.Receive("BlockMenuKey", function() BlockKeyTimer = CurTime() + 0.8 end)

	if(IsValid(Ply:GetActiveWeapon())) then
		if(Ply:GetActiveWeapon():GetClass() == "arccw_horde_crowbar") then
			if(Ply:KeyDown(8192) && BlockKeyTimer < CurTime() && SkillMenuOpened == false) then
				if(!MenuOpened) then
                    DisplayHint = false
					BuildMenu()
					MenuOpened = true
				end
			end
		end
	end

    if(ReloadMenu) then
        OpenCFGMenu()
        ConfigMenuOpened = true
        ReloadMenu = false
    end

    if(input.IsKeyDown(KEY_F6) && LocalPlayer():IsAdmin()) then
        if(MenuOpened == false && SkillMenuOpened == false && !gui.IsConsoleVisible() && !ConfigMenuOpened && !WorkStationOpened) then
            OpenCFGMenu()
            ConfigMenuOpened = true
        end
    end

    if(input.IsKeyDown(KEY_N)) then
        if(MenuOpened == false && SkillMenuOpened == false && !gui.IsConsoleVisible() && MenuCD < CurTime() && !ConfigMenuOpened && !BlockSkillMenu && !WorkStationOpened) then
            DisplayHint = false
            SkillMenu()
            SkillMenuOpened = true
        end
    end

	if(PlayerSanityDropTimer < CurTime()) then

		if(PlayerSanity >= 2) then
			PlayerSanity = math.Clamp(PlayerSanity - 1, 0, 100)
		else
			net.Start("SanityHurt")
			net.SendToServer()
		end

		for x,y in pairs(ents.FindByClass("prop_physics_multiplayer")) do

			if(IsBase(y)) then

				if(Ply:GetPos():Distance(y:GetPos()) > 512) then continue end

				PlayerSanity = math.Clamp(PlayerSanity + 25, 0, 100)

			end

			if(y:GetModel() == "models/galaxy/rust/campfire.mdl") then

				if(Ply:GetPos():Distance(y:GetPos()) > 128) then continue end

				PlayerSanity = math.Clamp(PlayerSanity + 4, 0, 100)

			end

		end

		PlayerSanityDropTimer = CurTime() +  (0.5 + (PlayerSanityDropInterval / 2))
	end

	if(IsValid(HORDE.ShopGUI)) then
		if(HORDE.ShopGUI:IsVisible() && HORDE.start_game) then
    			HORDE:ToggleShop()
		end
	end

	if(DisplayAlpha <= 0) then
		DisplayAmout = 0
	end

	net.Receive("GoalNotify", function ()
		GoalString = net.ReadString()
		GoalNotifyTime = CurTime() + 2
	end)

	net.Receive("SpawnTimer", function() 
		ReSpawnTimer = CurTime() + net.ReadInt(32)
	end)

	net.Receive("SyncDataReturn", function()

		local Wood = net.ReadInt(16)
		local Iron = net.ReadInt(16)
		local WoodLimit = net.ReadInt(16)
		local IronLimit = net.ReadInt(16)
		local GWood = net.ReadInt(16)
		local GIron = net.ReadInt(16)
		local GWoodLimit = net.ReadInt(16)
		local GIronLimit = net.ReadInt(16)
		local GEletronic = net.ReadInt(32)
		local GTime = net.ReadInt(32)
		local GDay = net.ReadInt(32)
		local NoD = net.ReadBool()
		local RST = net.ReadInt(32)
		local PCP = net.ReadInt(32)
		local Materials = net.ReadInt(4)
		local FP = net.ReadFloat()
		local BuildingScaling = net.ReadFloat()
		local TurretDMG = net.ReadFloat()
        local PSI = net.ReadFloat()
        local SKP = net.ReadInt(8)
        local STB = net.ReadBool()
        local STL = net.ReadInt(8)
        local CLK = net.ReadBool()

		PlayerWood = Wood
		PlayerIron = Iron
		PlayerWoodLimit = WoodLimit
		PlayerIronLimit = IronLimit
		GlobalWood = GWood
		GlobalIron = GIron
		GlobalWoodLimit = GWoodLimit
		GlobalIronLimit = GIronLimit
		Eletronic = GEletronic
		GlobalTime = GTime
		GlobalDay = GDay
		NightOrDay = NoD
		StartTimer = RST
		PlayerCurPicking = PCP
		PlayerMaterial = Materials
		PlayerFixSpeed = FP
		PlayerBuildingHPScaling = BuildingScaling
		PlayerTurretDamageBoost = TurretDMG
        PlayerSanityDropInterval = PSI
        PlayerSkillPoints = SKP
        RescueStarted = STB
        ShelterTurret = STL
        PlayerCloaking = CLK
    end)

	net.Receive("StartNotify", function()
         sound.PlayFile( 'sound/shigure/start.mp3', 'noplay', function( station, errCode, errStr ) station:Play() end)
	end)

	net.Receive("NightNotify", function()
        sound.PlayFile( 'sound/shigure/night.mp3', 'noplay', function( station, errCode, errStr ) station:Play() end)
	end)



	net.Receive("BaseAlert", function()
		AlertShowTime = CurTime() + 1.5
	end)

	net.Receive("FullNotify", function()
		DisplayNotifyTime = 0
		DisplayAlpha = 0
		FullNotifyTime = CurTime() + 1.5
	end)

	net.Receive("ResourceNotify", function()
		FullNotifyTime = 0
		FullNotifyAlpha = 0
		local Type = net.ReadInt(4)

		if(Type != DisplayType) then
			DisplayAmout = PlayerCurPicking
			DisplayType = Type
		else

			if(DisplayNotifyTime > CurTime()) then
				DisplayAmout = DisplayAmout + PlayerCurPicking
			else
				DisplayAmout = PlayerCurPicking
			end
		end

		DisplayNotifyTime = CurTime() + 1.25
    end)

	if(SyncDataTimer < CurTime()) then

		net.Start("SyncData")
		net.SendToServer()

		SyncDataTimer = CurTime() + 0.33
	end

	net.Receive("OpenWorkStation", function()
		if(!WorkStationOpened) then
			OpenWorkStation()
			WorkStationOpened = true
		end
	end)

	net.Receive("OpenStorage", function()
		if(!StorageOpened) then
			Ply:ConCommand("play items/ammocrate_open.wav")
			OpenBuyMenu()
			StorageOpened = true
		end
	end)

else

    Ply = LocalPlayer()

    end

end)
end

net.Receive("SyncItemsReturn", function()
    local len = net.ReadUInt(32)
    local data = net.ReadData(len)
    local str = util.Decompress(data)
    ItemList = util.JSONToTable(str)
end)

net.Receive("SyncEnemysReturn", function()
    local len = net.ReadUInt(32)
    local data = net.ReadData(len)
    local str = util.Decompress(data)
    EnemyList = util.JSONToTable(str)
end)

if(ShouldLoad__()) then
hook.Add( "StartChat", "SChatHandler", function( isTeamChat )
    BlockSkillMenu = true
end )
end

if(ShouldLoad__()) then
hook.Add( "FinishChat", "FChatHandler", function( isTeamChat )
    BlockSkillMenu = false
end )
end

if(ShouldLoad__()) then
hook.Add( "InitPostEntity", "InitHandler", function()
    net.Start("SyncItems")
    net.SendToServer()
    net.Start("SyncEnemys")
    net.SendToServer()
end )

    net.Start("SyncItems") -- sync when load
    net.SendToServer()
    net.Start("SyncEnemys")
    net.SendToServer()
end