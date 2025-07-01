--死灵舞者 队长·吸血鬼
function c71100577.initial_effect(c)
	c:EnableCounterPermit(0x17d7)
	--spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,71100577) 
	e1:SetCondition(c71100577.spcon)
	e1:SetTarget(c71100577.sptg)
	e1:SetOperation(c71100577.spop)
	c:RegisterEffect(e1)   
	--control 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11100577) 
	e2:SetCondition(c71100577.clcon)
	e2:SetTarget(c71100577.cltg)
	e2:SetOperation(c71100577.clop)
	c:RegisterEffect(e2) 
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e3) 
end
function c71100577.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK+LOCATION_GRAVE)
end
function c71100577.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c71100577.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		c:AddCounter(0x17d7,7)  
	end
end
function c71100577.clcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetCurrentChain()>0 
end 
function c71100577.clfil(c,tp,eg)
	return c:IsSummonPlayer(1-tp) and c:IsControlerCanBeChanged() and c:IsSummonLocation(LOCATION_HAND+LOCATION_GRAVE) and eg:IsContains(c)
end 
function c71100577.cltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c71100577.clfil(chkc,eg) end
	if chk==0 then return Duel.IsExistingTarget(c71100577.clfil,tp,0,LOCATION_MZONE,1,nil,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c71100577.clfil,tp,0,LOCATION_MZONE,1,1,nil,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c71100577.clop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1) then 
		Duel.BreakEffect()
		local xtable={aux.Stringid(71100577,4)}  
		local b1=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) 
		local b2=Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) 
		local b3=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) 
		if b1 then table.insert(xtable,aux.Stringid(71100577,1)) end 
		if b2 then table.insert(xtable,aux.Stringid(71100577,2)) end 
		if b3 then table.insert(xtable,aux.Stringid(71100577,3)) end 
		local op=Duel.SelectOption(tp,table.unpack(xtable))+1 
		if op==aux.Stringid(71100577,1) then 
			local sc=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil) 
			Duel.XyzSummon(tp,sc,nil)
		end 
		if op==aux.Stringid(71100577,2) then 
			local sc=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil) 
			Duel.SynchroSummon(tp,sc,nil)
		end 
		if op==aux.Stringid(71100577,3) then 
			local sc=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil) 
			Duel.LinkSummon(tp,sc,nil)
		end 
	end
end





