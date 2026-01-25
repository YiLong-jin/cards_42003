--想起「乐园的悦乐」 2026/01/06 14:31:20 scripted by 翼龙
local this,id,ofs=GetID()
function this.initial_effect(c)
	--select effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(this.target)
	e1:SetOperation(this.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(this.target)
	e2:SetOperation(this.op)
	c:RegisterEffect(e2)
end
function this.setfilter(c)
	return c:IsSetCard(0x7d2,0x7d7) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function this.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function this.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local res1=Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(this.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local res2=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(this.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return res1 or res2 end
	local op=0
	if res1 and not res2 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
		op=1
	end
	if res2 and not res1 then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
		op=2
	end
	if res1 and res2 then
		op=aux.SelectFromOptions(tp,
			{res1,aux.Stringid(id,0),1},
			{res2,aux.Stringid(id,1),2})
	end
	e:SetLabel(op)
	Duel.RegisterFlagEffect(tp,id+op-1,RESET_PHASE+PHASE_END,0,1)
	if op==1 then
		e:SetCategory(0)
	elseif op==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	end
end
function this.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
		local g=Duel.SelectMatchingCard(tp,this.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then Duel.SSet(tp,g:GetFirst()) end
	elseif e:GetLabel()==2 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(this.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
	end
end
