--“虫瘴飞散”斯卡塔赫（成体）
local this,id,ofs=GetID()
function this.initial_effect(c)
	--self spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCondition(this.spcon)
	e1:SetTarget(this.sptg)
	e1:SetOperation(this.spop)
	c:RegisterEffect(e1)
	--material set 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+ofs)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetTarget(this.mattg)
	e2:SetOperation(this.matop)
	c:RegisterEffect(e2)
	if not this.global_check then
		this.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(this.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function this.checkfilter(c)
	return c:IsRank(2) and c:IsRace(RACE_INSECT) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function this.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,id)>0 then return end 
	local g=eg:Filter(this.checkfilter,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1,id,RESET_PHASE+PHASE_END,0,1)
	end
end
function this.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>0
end
function this.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function this.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function this.chkcfilter(c,tp,e)
	if c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_MZONE) then 
		local sg=c:GetOverlayGroup()
		if not e then return sg:IsExists(Card.IsAbleToHand,1,nil) end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	else 
		local xg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_XYZ)
		if not e then return c:IsCanOverlay() and xg:GetCount()>0 end 
		if c:IsImmuneToEffect(e) then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tg=xg:FilterSelect(tp,aux.NOT(Card.IsImmuneToEffect),1,1,nil,e)
		local tc=tg:GetFirst()
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end 
end
function this.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and this.chkcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(this.chkcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,this.chkcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_XYZ) and tc:IsLocation(LOCATION_MZONE) then 
		local sg=tc:GetOverlayGroup()
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
	end 
end
function this.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end 
	this.chkcfilter(tc,tp,e)
end
