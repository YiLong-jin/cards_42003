--萌生于V城的深层
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(m)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm.atkup_cache = cm.atkup_cache or {}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.atk_checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.Automatic_chess_piece=true --「自动棋子」记述
function cm.atk_checkop()
	local g=Duel.GetFieldGroup(0,LOCATION_MZONE,LOCATION_MZONE)
	local now={}
	for tc in aux.Next(g) do
		local new={}
		local tce={tc:IsHasEffect(EFFECT_UPDATE_ATTACK)}
		local vf
		local val=0
		for k,v in pairs(tce) do
			local flag=false
			for k1,v1 in pairs(cm.atkup_cache) do 
				if v==v1 then flag=true end
			end
			if not flag then
				vf=v:GetValue()
				if type(vf) == "function" then 
					val=vf(v,tc)
				elseif type(vf) ~= "function" then 
					val=vf 
				end
				if tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
					val=-val
				end
				if val>0 then 
					table.insert(new,v)
				end
			end
			table.insert(now,v)
		end
		for k2,v2 in pairs(new) do
			if tc:GetAttack()>0 then 
				Duel.RaiseEvent(tc,m,v2,REASON_EFFECT,v2:GetOwnerPlayer(),tc:GetControler(),val) 
			end
		end
	end
	cm.atkup_cache=now
end
function cm.thfilter(c)
	return c:IsCode(71100341) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if tc and Duel.SelectYesNo(tp,aux.Stringid(41546,0)) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and rp==tp and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
