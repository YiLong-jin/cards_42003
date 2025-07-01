--滅尽の覇龍樹 グリフォギィラ・ヴァルテクス
function c88884331.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,false,true,c88884331.fusfilter1,c88884331.fusfilter2,c88884331.fusfilter2,c88884331.fusfilter2,c88884331.fusfilter2)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--to hand or field
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,88884330)
	e1:SetCondition(c88884331.condition)
	e1:SetTarget(c88884331.target)
	e1:SetOperation(c88884331.operation)
	c:RegisterEffect(e1)
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetValue(1)
	--c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	--c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetValue(1)
	e4:SetTarget(c88884331.indtg)
	--c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	--c:RegisterEffect(e5)
	--cannot active
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetCondition(c88884331.con)
	e6:SetValue(c88884331.actlimit)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SSET)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetCondition(c88884331.con)
	e7:SetTarget(c88884331.setlimit)
	c:RegisterEffect(e7)
end
function c88884331.fusfilter1(c)
	return c:IsSetCard(0x8895) 
end
function c88884331.fusfilter2(c)
	return c:IsSetCard(0x8893)
end
function c88884331.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c88884331.tffilter(c,tp)
	return c:IsCode(88884332) and not c:IsForbidden()
end
function c88884331.cfilter(c)
	return c:IsSetCard(0x8894) and c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c88884331.ffilter(c)
	return c:IsCode(88884332)
end
function c88884331.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=Duel.IsExistingMatchingCard(c88884331.ffilter,tp,0,LOCATION_FZONE,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c88884331.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) or (b and Duel.IsExistingMatchingCard(c88884331.cfilter,tp,LOCATION_DECK,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88884331.operation(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.IsExistingMatchingCard(c88884331.ffilter,tp,0,LOCATION_FZONE,1,nil)
	local b1=Duel.IsExistingMatchingCard(c88884331.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c88884331.cfilter,tp,LOCATION_DECK,0,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(88884331,0)
		opval[off-1]=1
		off=off+1
	end
	if b and b2 then
		ops[off]=aux.Stringid(88884331,1)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_FZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c88884331.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
		if tc then
			if #g~=0 then Duel.SendtoGrave(g,REASON_RULE) end
			Duel.MoveToField(tc,tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c88884331.cfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c88884331.indtg(e,c)
	return c:IsSetCard(0x8895) and c:IsType(TYPE_FUSION)
end
function c88884331.con(e,c)
	return Duel.IsExistingMatchingCard(c88884331.ffilter,0,0,LOCATION_FZONE,1,nil)
end
function c88884331.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c88884331.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end