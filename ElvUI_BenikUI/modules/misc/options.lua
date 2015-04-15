local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local BXR = E:GetModule('BUIExpRep');

if E.db.buixprep == nil then E.db.buixprep = {} end

local function xprepTable()
	E.Options.args.bui.args.config.args.buixprep = {
		order = 30,
		type = 'group',
		name = COMBAT_XP_GAIN.."/"..REPUTATION,
		childGroups = "tab",
		disabled = function() return not E.db.ufb.barshow or not E.private.unitframe.enable end,
		args = {
			enable = {
				order = 1,
				type = 'toggle',
				name = ENABLE,
				width = 'full',
				get = function(info) return E.db.buixprep.enable end,
				set = function(info, value) E.db.buixprep.enable = value E:StaticPopup_Show('PRIVATE_RL'); end,
			},
			show = {
				order = 2,
				type = 'select',
				name = L['Show in PlayerBar'],
				desc = L['Empty Frames must be enabled \n(in UnitFrames options)'],
				disabled = function() return not E.db.buixprep.enable end,
				values = {
					['REP'] = REPUTATION,
					['XP'] = COMBAT_XP_GAIN,
				},
				get = function(info) return E.db.buixprep.show end,
				set = function(info, value) E.db.buixprep.show = value; BXR:EnableDisable_ReputationBar(); BXR:EnableDisable_ExperienceBar(); end,
			},
			text = {
				order = 3,
				type = 'group',
				name = L['Text'],
				guiInline = true,
				disabled = function() return not E.db.buixprep.enable end,
				args = {
					tStyle = {
						order = 1,
						type = 'select',
						name = L['Copy Font Style from'],
						values = {
							['DEFAULT'] = DEFAULT,
							['DTS'] = L['DataTexts'],
							['UNIT'] = L['UnitFrames'],
						},
						get = function(info) return E.db.buixprep.text.tStyle end,
						set = function(info, value) E.db.buixprep.text.tStyle = value; BXR:ChangeRepXpFont(); end,
					},
					xpTextFormat = {
						order = 2,
						type = 'select',
						name = L['Text Format']..' ('..COMBAT_XP_GAIN..')',
						disabled = function() return E.db.buixprep.show == 'REP' end,
						values = {
							NONE = NONE,
							PERCENT = L['Percent'],
							CURMAX = L['Current - Max'],
							CURPERC = L['Current - Percent'],
						},
						get = function(info) return E.db.buixprep.text.xpTextFormat end,
						set = function(info, value) E.db.buixprep.text.xpTextFormat = value; BXR:UpdateExperience() end,
					},
					repTextFormat = {
						order = 3,
						type = 'select',
						name = L['Text Format']..' ('..REPUTATION..')',
						disabled = function() return E.db.buixprep.show == 'XP' end,
						values = {
							NONE = NONE,
							PERCENT = L['Percent'],
							CURMAX = L['Current - Max'],
							CURPERC = L['Current - Percent'],
						},
						get = function(info) return E.db.buixprep.text.repTextFormat end,
						set = function(info, value) E.db.buixprep.text.repTextFormat = value; BXR:UpdateReputation() end,
					},
					mouseOver = {
						order = 4,
						type = 'toggle',
						name = L['Hide PlayerBar text values'],
						desc = L['Hides health, power and custom text values when mousing over, if their yOffset is']..' < -10',
						get = function(info) return E.db.buixprep.text.mouseOver end,
						set = function(info, value) E.db.buixprep.text.mouseOver = value end,
					},
				},
			},
			color = {
				order = 4,
				type = 'group',
				name = COLOR,
				childGroups = "tab",
				disabled = function() return not E.db.buixprep.enable end,
				args = {
					experience = {
						order = 1,
						type = 'group',
						name = COMBAT_XP_GAIN,
						args = {
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.buixprep.color.experience.default end,
								set = function(info, value) E.db.buixprep.color.experience.default = value; BXR:ChangeXPcolor(); end,
							},
							xp = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = COMBAT_XP_GAIN,
								disabled = function() return E.db.buixprep.color.experience.default end,
								get = function(info)
									local t = E.db.buixprep.color.experience.xp
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b, a)
									local t = E.db.buixprep.color.experience.xp
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeXPcolor()
								end,
							},
							rested = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = TUTORIAL_TITLE26,
								disabled = function() return E.db.buixprep.color.experience.default end,
								get = function(info)
									local t = E.db.buixprep.color.experience.rested
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b, a)
									local t = E.db.buixprep.color.experience.rested
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeXPcolor()
								end,
							},
							separator = {
								order = 4,
								name = "",
								type = 'header',					
							},
							applyInElvUI = {
								order = 5,
								type = 'toggle',
								name = L['Apply in ElvUI'],
								desc = L['Also apply these colors in ElvUI xp bar.'],
								get = function(info) return E.db.buixprep.color.experience.applyInElvUI end,
								set = function(info, value) E.db.buixprep.color.experience.applyInElvUI = value; BXR:ChangeXPcolor(); end,
							},
						},
					},
					reputation = {
						order = 2,
						type = 'group',
						name = REPUTATION,
						args = {				
							default = {
								order = 1,
								type = 'toggle',
								name = DEFAULT,
								width = 'full',
								get = function(info) return E.db.buixprep.color.reputation.default end,
								set = function(info, value) E.db.buixprep.color.reputation.default = value; BXR:ChangeRepColor(); end,
							},
							friendly = {
								order = 2,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL5.."+",
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.friendly
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b, a)
									local t = E.db.buixprep.color.reputation.friendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							neutral = {
								order = 3,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL4,
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.neutral
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b, a)
									local t = E.db.buixprep.color.reputation.neutral
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							unfriendly = {
								order = 4,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL3,
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.unfriendly
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b, a)
									local t = E.db.buixprep.color.reputation.unfriendly
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							hated = {
								order = 5,
								type = 'color',
								hasAlpha = true,
								name = FACTION_STANDING_LABEL2.."/"..FACTION_STANDING_LABEL1,
								disabled = function() return E.db.buixprep.color.reputation.default end,
								get = function(info)
									local t = E.db.buixprep.color.reputation.hated
									return t.r, t.g, t.b, t.a
									end,
								set = function(info, r, g, b, a)
									local t = E.db.buixprep.color.reputation.hated
									t.r, t.g, t.b, t.a = r, g, b, a
									BXR:ChangeRepColor()
								end,
							},
							separator = {
								order = 6,
								name = "",
								type = 'header',					
							},
							applyInElvUI = {
								order = 7,
								type = 'toggle',
								name = L['Apply in ElvUI'],
								desc = L['Also apply these colors in ElvUI rep bar.'],
								get = function(info) return E.db.buixprep.color.reputation.applyInElvUI end,
								set = function(info, value) E.db.buixprep.color.reputation.applyInElvUI = value; BXR:ChangeRepColor(); end,
							},							
						},
					},
				},
			},
		},
	}
end

table.insert(E.BuiConfig, xprepTable)