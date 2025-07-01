--交响曲·夜曲
function c69969287.initial_effect(c)
c:EnableReviveLimit()
aux.EnablePendulumAttribute(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(69969287,4))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c69969287.target)
	e1:SetOperation(c69969287.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(69969287,5))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCost(c69969287.spcost)
	e2:SetTarget(c69969287.sptg)
	e2:SetOperation(c69969287.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69969287,0))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)	
	e3:SetCountLimit(1,69969287)
	e3:SetTarget(c69969287.distg)
	e3:SetOperation(c69969287.disop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(c69969287.dtdcon2)
	c:RegisterEffect(e4)
end
function c69969287.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c69969287.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc:IsCode(ac) and tc:IsAbleToHand() then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
--2
function c69969287.rfilter(c,tp)
	return c:IsLevelAbove(1) and (c:IsControler(tp) or c:IsFaceup()) and c:IsSetCard(0x69b)
end
function c69969287.fselect(g,tp)
Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLevel,7)
		and Duel.GetMZoneCount(tp,g)>0 
end
function c69969287.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
local g=Duel.GetReleaseGroup(tp,true):Filter(c69969287.rfilter,c,tp)
	if chk==0 then return g:CheckSubGroup(c69969287.fselect,1,g:GetCount(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c69969287.fselect,true,1,g:GetCount(),tp)
	if sg then
	aux.UseExtraReleaseCount(sg,tp)
	Duel.Release(sg,REASON_COST)
end
end
function c69969287.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c69969287.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:SetMaterial(nil)
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
end
--3
function c69969287.dtdcon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsPlayerAffectedByEffect(tp,69969252)
end 
function c69969287.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c69969287.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x69b)
end
function c69969287.thfilter(c)
	return c:IsSetCard(0x69b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c69969287.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(c69969287.cfilter,nil)
	if ct>0 then
		local b1=Duel.IsExistingMatchingCard(c69969287.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil)
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(69969287,1)
			opval[off]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(69969287,2)
			opval[off]=2
			off=off+1
		end
		ops[off]=aux.Stringid(69969287,3)
		opval[off]=0
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c69969287.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		elseif sel==2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
			Duel.HintSelection(sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sg:GetFirst():RegisterEffect(e1)
		end
	end
end