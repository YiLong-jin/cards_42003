--集团的记忆碎片
local this,id,ofs=GetID()
function this.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(this.target)
	e1:SetOperation(this.activate)
	c:RegisterEffect(e1)
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetValue(72355441)
	c:RegisterEffect(e2)
end
function this.eqtcfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function this.eqfilter(c,e)
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsRace(RACE_INSECT)
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.IsExistingMatchingCard(this.eqtcfilter,tp,0,LOCATION_MZONE,1,nil,e)
end
function this.thfilter(c)
	return c:IsLevel(2) and c:IsRace(RACE_INSECT) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(this.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e)
	local g2=Duel.GetMatchingGroup(this.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local b1=g1:GetCount()>0
	local b2=g2:GetClassCount(Card.GetCode)>=2
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else op=Duel.SelectOption(tp,aux.Stringid(id,1))+1 end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,1-tp,LOCATION_MZONE)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function this.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(this.eqfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		if tc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tg=Duel.SelectMatchingCard(tp,this.eqtcfilter,tp,0,LOCATION_MZONE,1,1,nil,e)
			local ec=tg:GetFirst()
			if not Duel.Equip(tp,tc,ec) then return end
			local e1=Effect.CreateEffect(ec)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(this.eqlimit)
			tc:RegisterEffect(e1)
		end
	else
		local g=Duel.GetMatchingGroup(this.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if hg and Duel.SendtoHand(hg,nil,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			Duel.ConfirmCards(1-tp,og)
			for sc in aux.Next(og) do 
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e3:SetTargetRange(1,0)
				e3:SetLabel(sc:GetCode())
				e3:SetTarget(this.splimit)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
				local e2=e3:Clone()
				e2:SetCode(EFFECT_CANNOT_SUMMON)
				Duel.RegisterEffect(e2,tp)
			end
		end
	end
end
function this.eqlimit(e,c)
	return e:GetOwner()==c
end
function this.splimit(e,c)
	return c:IsCode(e:GetLabel())
end
