--魔陷烹调师
local m=64000043
local cm=_G["c"..m]
function cm.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(64000043,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c64000043.sptg1)
	e1:SetOperation(c64000043.spop1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64000043,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetTarget(c64000043.sptg2)
	e2:SetOperation(c64000043.spop2)
	c:RegisterEffect(e2)
	
end
function c64000043.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,64000044)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c64000043.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.RegisterFlagEffect(tp,64000044,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE)
end
function c64000043.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c64000043.filter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_TOFIELD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_FIEND)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(500)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(500)
		tc:RegisterEffect(e5,true)
		local e0=e1:Clone()
		e0:SetCode(EFFECT_CHANGE_LEVEL)
		e0:SetValue(4)
		tc:RegisterEffect(e0,true)
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end
function c64000043.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,64000043)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.RegisterFlagEffect(tp,64000043,RESET_PHASE+PHASE_END,0,1)
end
function c64000043.filter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,TYPE_MONSTER,500,500,4,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_DEFENSE)
end
function c64000043.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	local ct=math.min(5,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	if ct>0 then
		local t={}
		for i=1,ct do
			t[i]=i
		end
		local ac=1
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(64000043,3))
			ac=Duel.AnnounceNumber(tp,table.unpack(t))
		end
	local g=Duel.GetDecktopGroup(tp,ac)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(c64000043.filter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(64000043,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:FilterSelect(tp,c64000043.filter,1,1,nil,e,tp)
		Duel.DisableShuffleCheck()
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET-RESET_TOFIELD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_FIEND)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(500)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(500)
		tc:RegisterEffect(e5,true)
		local e0=e1:Clone()
		e0:SetCode(EFFECT_CHANGE_LEVEL)
		e0:SetValue(4)
		tc:RegisterEffect(e0,true)
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		Duel.ShuffleDeck(tp)
	else Duel.ShuffleDeck(tp) end
end
end
