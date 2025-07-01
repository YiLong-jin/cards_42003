--彩光超 欧米伽公主
local m=65846696
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,65846687)
	aux.AddFusionProcCode2(c,65846684,65846686,true,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)  
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(1)
	c:RegisterEffect(e0)  
end
function cm.thtrfat(c)
	return c:IsCode(65846687) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local b=Duel.IsExistingMatchingCard(cm.thtrfat,tp,LOCATION_ONFIELD,0,1,nil)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil)
	if chk==0 then return true end
	local op=0
	if b then op=6
	elseif b2 and b3 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b3 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,2))*2
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	end
	e:SetLabel(op)
	if op==6 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
		e:SetCategory(CATEGORY_RECOVER+CATEGORY_POSITION+CATEGORY_TODECK)
	elseif op==0 then
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,2000)
		e:SetCategory(CATEGORY_RECOVER)
	elseif op==1 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_GRAVE)
		e:SetCategory(CATEGORY_TODECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)   
		e:SetCategory(CATEGORY_POSITION)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local a=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil)
	local b=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ag=Group.CreateGroup()
	if op==6 then
		local lp=Duel.Recover(p,d,REASON_EFFECT)
		if lp~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			c:RegisterEffect(e1)
		end
		if a or b then Duel.BreakEffect() end
		if b then
			local tg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			local tc=tg:GetFirst()
			while tc do
				local ct=Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
				if ct==0 then ag:AddCard(tc) end
				tc=tg:GetNext()
			end
			if ag:GetCount()>0 then
				Duel.SendtoGrave(ag,REASON_RULE)
			end
			if a then Duel.BreakEffect() end
		end
		if a then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,3,nil)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	elseif op==0 then
		local lp=Duel.Recover(p,d,REASON_EFFECT)
		if lp~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(1000)
			c:RegisterEffect(e1)
		end
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,3,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		local tg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
		local tc=tg:GetFirst()
		while tc do
			local ct=Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			if ct==0 then ag:AddCard(tc) end
			tc=tg:GetNext()
		end
		if ag:GetCount()>0 then
			Duel.SendtoGrave(ag,REASON_RULE)
		end
	end
end