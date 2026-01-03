--小阿卡那 宝剑
function c65840080.initial_effect(c)
	aux.AddCodeList(c,65842060)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65840080,0))
	--e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c65840080.target)
	e1:SetOperation(c65840080.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65840080,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(c65840080.actcon)
	c:RegisterEffect(e2)
	if not c65840080.global_check then
		c65840080.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c65840080.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function c65840080.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re or not aux.IsCodeListed(re:GetHandler(),65842060) then return end
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(65840080,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c65840080.actcon(e)
	return e:GetHandler():GetFlagEffect(65840080)>0
end
function c65840080.tgfilter(c)
	return c:IsSetCard(0x1d1) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c65840080.thfilter(c)
	return aux.IsCodeListed(c,65842060) and c:IsAbleToHand()
end
function c65840080.mfilter(c)
	return aux.IsCodeListed(c,65842060) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c65840080.syncheck(g,tp,syncard)
	return g:IsExists(c65840080.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c65840080.scfilter(c,tp,mg)
	return mg:CheckSubGroup(c65840080.syncheck,2,#mg,tp,c)
end
function c65840080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local b1=Duel.IsExistingMatchingCard(c65840080.thfilter,tp,LOCATION_DECK,0,1,nil)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,65840080)==0)
	local b2=Duel.IsExistingMatchingCard(c65840080.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg)
		and (not e:IsCostChecked() or Duel.GetFlagEffect(tp,65840080+1000000)==0)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 or b2 then
		op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(65840080,2),1},
			{b2,aux.Stringid(65840080,3),2})
	end
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.RegisterFlagEffect(tp,65840080,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	elseif op==2 then
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			Duel.RegisterFlagEffect(tp,65840080+1000000,RESET_PHASE+PHASE_END,0,1)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function c65840080.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c65840080.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif e:GetLabel()==2 then
		local g=Duel.GetMatchingGroup(c65840080.scfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
		if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			local tg=mg:SelectSubGroup(tp,c65840080.syncheck,false,2,#mg,tp,sc)
			Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)
		end
	end
end