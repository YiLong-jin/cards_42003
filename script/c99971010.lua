--次元之魔女·桃乐丝
local s,id,o=GetID()
function s.initial_effect(c)
		--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,99971010)
	--e2:SetCondition(c99971010.drcon)
	e2:SetTarget(c99971010.drtg)
	e2:SetOperation(c99971010.drop)
	c:RegisterEffect(e2)
	
	
	
	
	-- 效果①：持续公开并等待9回合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99971011)
	e1:SetCondition(s.pubcon)
	e1:SetCost(s.pubcost)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)
	
			local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,2))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_DRAW)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetRange(LOCATION_HAND)
		e3:SetCondition(c99971010.coincon)
   	 	e3:SetTarget(s.sptg)
		e3:SetOperation(s.spop)
		c:RegisterEffect(e3)
end

-- 效果①：持续公开
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,99971010)==0
end

function s.pubcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971010,4))
	
end

function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	-- 无立即操作，只是设置状态
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99971010)~=0 then return end
	Duel.RegisterFlagEffect(tp,99971010,RESET_PHASE+PHASE_END,0,9)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetOperation(s.checkop)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END,9)
	Duel.RegisterEffect(e1,tp)
	e1:SetLabelObject(e1)
	c:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END,0,9)
	c99971010[c]=e1
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFlagEffect(tp,99971010)
	c:SetHint(CHINT_TURN,ct)
	Duel.RegisterFlagEffect(tp,99971010,RESET_PHASE+PHASE_END,0,10-ct)
	if ct>=9 then
	-- 第9回合时赋予效果
		Duel.Hint(HINT_CARD,1-tp,id)
		c:ResetFlagEffect(1082946)
		c:ResetFlagEffect(99971010)
		Duel.ResetFlagEffect(tp,1082946)
		Duel.ResetFlagEffect(tp,99971010)
		Duel.RegisterFlagEffect(tp,99971019,nil,0,98)
		e:GetHandler():RegisterFlagEffect(0,nil,EFFECT_FLAG_CLIENT_HINT,2,0,aux.Stringid(99971010,5))
		e:GetLabelObject():Reset()
	end
end

-------------赋予效果----------
function c99971010.coincon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99971015)==0 and Duel.GetFlagEffect(tp,99971019)~=0
end
function c99971010.filter(c)
	return c:GetFlagEffect(1082946)~=0 and (c:IsSetCard(0x67f) or c:IsCode(99971030))
end
function c99971010.filter1(c,code)
	return c:GetFlagEffect(1082946)~=0 and c:IsCode(code)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c99971010.filter,tp,0x3f,0x3f,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 特殊召唤
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		-- 自己的手卡全部除外
		Duel.RegisterFlagEffect(tp,99971015,RESET_PHASE+PHASE_END,0,1)
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
	end
		-- 自己从卡组抽3张
		Duel.Draw(tp,3,REASON_EFFECT)
		--使用3次3增幅
   	 	local flgg=3
		while flgg>0 do
		if Duel.IsExistingMatchingCard(c99971010.filter,tp,0x3f,0x3f,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
		local g=Duel.SelectMatchingCard(tp,c99971010.filter,tp,0x3f,0x3f,1,1,nil)
		local tc=g:GetFirst()
		local turne=tc[tc]
		local op=turne:GetOperation()
		local code=tc:GetCode()
		local flag=5
			flgg=flgg-1
			while flag>0 do
				if Duel.IsExistingMatchingCard(c99971010.filter1,tp,0x3f,0x3f,1,nil,code) then 
					op(turne,turne:GetOwnerPlayer(),nil,0,0,0,0,0)
					flag=flag-1
				else
					flag=0
				end
			end
		else
			flgg=0
		end
	end
end
--------------------------------------------------




















function c99971010.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99971010.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(99971030)
end
function c99971010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99971010.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99971010.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99971010.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end