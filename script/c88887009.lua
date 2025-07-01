--终局犯罪 莫里亚蒂
function c88887009.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,88887002,c88887009.matfilter,2,true,true)
	--atk/def up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
	e1:SetValue(c88887009.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(88887009,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,88887009)
	e3:SetTarget(c88887009.damtg)
	e3:SetOperation(c88887009.damop)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88887009,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,18887009)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(c88887009.setg)
	e4:SetOperation(c88887009.seop)
	c:RegisterEffect(e4)
end
function c88887009.matfilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c88887009.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL+TYPE_TRAP)*200
end
function c88887009.damfilter(c)
	return c:IsFacedown()
end
function c88887009.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88887009.damfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c88887009.damfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetCount()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c88887009.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c88887009.damfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetCount()
	Duel.Damage(p,ct*500,REASON_EFFECT)
end
function c88887009.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c88887009.setg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c88887009.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)>=2
		and Duel.IsExistingTarget(c88887009.filter,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectTarget(tp,c88887009.filter,tp,0,LOCATION_MZONE,2,2,nil)
end
function c88887009.seop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE-LOCATION_FZONE)<2 then return end
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()~=2 then return end
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_MONSTER_SSET)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_TOFIELD+RESET_LEAVE+RESET_TODECK+RESET_TOHAND+RESET_TEMP_REMOVE+RESET_REMOVE+RESET_TOGRAVE)
		e1:SetValue(TYPE_SPELL)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
	Duel.SSet(tp,tg,tp,false)
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleSetCard(tg)
	if Duel.SelectYesNo(1-tp,aux.Stringid(88887009,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
		local sg=tg:Select(1-tp,1,1,nil)
		tg:Sub(sg)			
		Duel.ConfirmCards(1-tp,sg)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and sg:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then
			Duel.SpecialSummon(sg:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.ConfirmCards(1-tp,tg)
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 
			and tg:GetFirst():IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP) then
			Duel.SpecialSummon(tg:GetFirst(),0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end