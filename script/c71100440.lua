--侵蚀V城的伤痕
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
	e2:SetCategory(CATEGORY_DESTROY)
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
cm.Dead_souls_pawn=true --「死魂棋子」记述
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
	return c:IsCode(71100430) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if tc and Duel.SelectYesNo(tp,aux.Stringid(41546,0)) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsType,1,nil,TYPE_FUSION) and rp==tp and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT)
	end 
end
