--多元宇宙奇点
local cm,m,offset=GetID()
local all_loc=LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED 
function cm.initial_effect(c)
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge0:SetCode(EVENT_PREDRAW)
	ge0:SetRange(0xff)
	ge0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	ge0:SetOperation(cm.checkop)
	c:RegisterEffect(ge0)
	if not cm.check then 
		cm.check=true
		cm[7]={}--range
		cm[5]={}--o
		cm[4]={}--s
		cm[3]={}--e
		cm[2]=1
		cm[1]=Effect.SetTargetRange 
		Effect.SetTargetRange=function(se,s,o)
			local ct=cm.find_effect(se)
			cm[4][ct]=s
			cm[5][ct]=o
			cm[1](se,s,o)
		end
		cm[6]=Effect.SetRange
		Effect.SetRange=function(se,range)
			local ct=cm.find_effect(se)
			cm[7][ct]=range 
			cm[6](se,range)
		end
		cm[0]=Card.RegisterEffect
		Card.RegisterEffect=function(v1,v2,...)
			--变成对方回合也能用的效果
			if v2:GetType()&EFFECT_TYPE_IGNITION~=0 then 
				local con_c=v2:GetCondition()
				v2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.GetFlagEffect(tp,m)>0 then return false end
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				local se=v2:Clone()
				se:SetType(EFFECT_TYPE_QUICK_O)
				se:SetCode(EVENT_FREE_CHAIN)
				se:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.GetFlagEffect(tp,m)==0 then return false end
					if Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2 then return false end 
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				cm[0](v1,se,...)
			end
			--盖放的魔法卡发动
			local pro1,pro2=v2:GetProperty()
			pro1=pro1 or 0
			pro2=pro2 or 0
			if v2:GetType()&EFFECT_TYPE_ACTIVATE~=0 and pro2&EFFECT_FLAG2_COF==0 and v1:IsType(TYPE_SPELL) and not v1:IsType(TYPE_QUICKPLAY) then 
				local con_c=v2:GetCondition()
				local se=v2:Clone()
				se:SetProperty(pro1,pro2+EFFECT_FLAG2_COF)
				se:SetCode(EVENT_CHAIN_END)
				se:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.GetFlagEffect(tp,m-2)~=0 or Duel.GetFlagEffect(tp,m-1)==0 or Duel.GetCurrentChain()~=0 or not e:GetHandler():IsLocation(LOCATION_SZONE) then return false end
					if Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2 then return false end 
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				cm[0](v1,se,...)
			end
			--
			if v2:GetCode()==EFFECT_SPSUMMON_PROC then 
				local ct=cm.find_effect(se)
			end
			return cm[0](v1,v2,...)
		end
	end
end
function cm.find_effect(e)
	local esg=cm[3]
	for i,v in pairs(esg) do 
		if v==e then 
			return i
		end
	end
	local v=cm[2]
	cm[3][v]=e
	cm[2]=cm[2]+1
	return v
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)>0 and Duel.GetFlagEffect(1-tp,m)>0 then return end
	local c=e:GetHandler()
	for p=0,1 do 
		Duel.ConfirmCards(p,c)
		--变成对方回合也能用的效果
		Duel.RegisterFlagEffect(p,m,0,0,99)
		--速攻魔法从手卡发动
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCondition(cm.quick_spell_handcon)
		Duel.RegisterEffect(e1,p)
		--魔法·陷阱卡从手卡盖放
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_END)
		e2:SetCondition(cm.setcon)
		e2:SetOperation(cm.setop)
		Duel.RegisterEffect(e2,p)
		--盖放的魔法卡发动
		Duel.RegisterFlagEffect(p,m-1,0,0,99)
		--把怪兽召唤 特殊召唤
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SUMMON_SUCCESS)
		e3:SetCondition(cm.sumtcon)
		e3:SetOperation(cm.sumop)
		Duel.RegisterEffect(e3,p)
		local e4=e3:Clone()
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e4,p)
	end
end
function cm.quick_spell_handcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function cm.main_phase_con(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.main_phase_con(e) and Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(Card.IsSSetable,tp,LOCATION_HAND,0,1,nil)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local stg=Duel.GetMatchingGroup(Card.IsSSetable,tp,LOCATION_HAND,0,nil)
	if #stg>0 and Duel.SelectYesNo(tp,aux.Stringid(1225009,3)) then 
		Duel.RegisterFlagEffect(tp,m-2,RESET_EVENT+RESET_CHAIN,0,2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=stg:Select(tp,1,#stg,nil)
		Duel.SSet(tp,sg,tp,false)
	end
end
function cm.sumtcon(e,tp,eg,ep,ev,re,r,rp)
	return cm.main_phase_con(e) and Duel.GetCurrentChain()==0 and rp~=tp
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local spg=Group.CreateGroup()
	local esg=cm[3]
	for _,v1 in pairs(esg) do 
		local chk=false 
		local sc=v1:GetHandler()
		local ct=cm.find_effect(v1)
		if v1:GetCode()==EFFECT_SPSUMMON_PROC and sc:IsLocation(cm[7][ct]) and sc:IsControler(tp) then
			local val=v1:GetValue() or 0
			if val&SUMMON_TYPE_SYNCHRO~=0 then 
				chk=sc:IsSynchroSummonable(nil)
			elseif val&SUMMON_TYPE_XYZ~=0 then 
				chk=sc:IsXyzSummonable(nil)
			elseif val&SUMMON_TYPE_LINK~=0 then 
				chk=sc:IsLinkSummonable(nil)
			else 
				local con_c=v1:GetCondition()
				chk=con_c(v1,sc)
			end
			if chk then 
				spg:AddCard(sc)
			end
		end
	end
	local nsg=Duel.GetMatchingGroup(Card.IsSummonable,tp,LOCATION_HAND,0,nil,false,nil)
	if #spg>0 or #nsg>0 then
		local off=1
		local ops={}
		local opval={}
		if #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			ops[off]=aux.Stringid(39015,0)
			opval[off-1]=1
			off=off+1
		end
		if #nsg>0 then
			ops[off]=aux.Stringid(19041767,0)
			opval[off-1]=2
			off=off+1
		end
		ops[off]=aux.Stringid(75730490,4)
		opval[off-1]=0
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==2 then
			Duel.RegisterFlagEffect(tp,m-4,RESET_EVENT+RESET_TOFIELD,0,2)
			local sg=nsg:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.Summon(tp,tc,false,nil)
		end
		if opval[op]==1 then
			Duel.RegisterFlagEffect(tp,m-4,RESET_EVENT+RESET_TOFIELD,0,2)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=spg:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			off=1
			ops={}
			opval={}
			for _,v2 in pairs(esg) do 
				local chk=false 
				local ct=cm.find_effect(v2)
				if v2:GetHandler()==sc and v2:GetCode()==EFFECT_SPSUMMON_PROC and sc:IsLocation(cm[7][ct]) then
					if v2:GetValue()&SUMMON_TYPE_SYNCHRO~=0 then 
						chk=sc:IsSynchroSummonable(nil)
					elseif v2:GetValue()&SUMMON_TYPE_XYZ~=0 then 
						chk=sc:IsXyzSummonable(nil)
					elseif v2:GetValue()&SUMMON_TYPE_LINK~=0 then 
						chk=sc:IsLinkSummonable(nil)
					else 
						local con_c=v2:GetCondition()
						chk=con_c(v2,sc)
					end
					if chk then 
						ops[off]=v2:GetDescription() or aux.Stringid(39015,0)
						opval[off-1]=v2
						off=off+1
					end
				end
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local v=opval[op]
			local vals=v:GetValue() or 0
			if vals&SUMMON_TYPE_SYNCHRO~=0 then 
				Duel.SynchroSummon(tp,sc,nil)
			elseif vals&SUMMON_TYPE_XYZ~=0 then 
				Duel.XyzSummon(tp,sc,nil)
			elseif vals&SUMMON_TYPE_LINK~=0 then 
				Duel.LinkSummon(tp,sc,nil)
			else 
				local tar_c=v:GetTarget()
				local op_c=v:GetOperation()
				if tar_c then tar_c(v,tp,eg,ep,ev,re,r,rp,1,sc) end
				if op_c then op_c(v,tp,eg,ep,ev,re,r,rp,sc) end
				local pos=POS_FACEUP 
				local ttp=tp
				if v:GetProperty()&EFFECT_FLAG_SPSUM_PARAM~=0 then 
					local ct=cm.find_effect(v)
					pos=cm[4][ct] or pos
					if cm[5][ct]==1 then ttp=1-tp end
				end
				Duel.AdjustAll()
				Duel.SpecialSummon(sc,vals,tp,ttp,true,false,pos)
			end
		end
	end
end